import 'dart:developer';

import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/main.dart';
import 'package:alnoor/utils/reusable_cache_image.dart';
import 'package:alnoor/widgets/Image_Skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/product.dart';
import '../../services/download_service.dart';
import '../../widgets/menu.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final bool isFavourites;

  ProductDetailScreen({required this.product, required this.isFavourites});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<ImageProvider> _imageFuture;
  bool isGuestUser = true; // Default to true; will be updated later
  late ValueNotifier<bool> _isMenuVisibleNotifier;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final DownloadService downloadService = DownloadService(
    scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
  );

  @override
  void initState() {
    super.initState();
    _loadUserStatus(); // Load guest user status
    _isMenuVisibleNotifier = ValueNotifier<bool>(false);
  }

  Future<void> _loadUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print("thirtytwo");
      isGuestUser = prefs.getBool('isGuestUser') ?? true;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _imageFuture =
  //       _loadImage("https://alnoormdf.com/" + widget.product.productImage);
  // }

  // Future<ImageProvider> _loadImage(String url) async {
  //   try {
  //     final image = CachedNetworkImageProvider(url); // NetworkImage(url);
  //     await precacheImage(image, context);
  //     return image;
  //   } catch (e) {
  //     return AssetImage('assets/images/Logo.png');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    log('image ${"https://alnoormdf.com/" + widget.product.productImage}');
    return GestureDetector(
      onTap: () {
        _isMenuVisibleNotifier.value = false;
      },
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: constraints.maxHeight * 0.5,
                              width: double.infinity,
                              child: Hero(
                                tag:
                                    'product-thumbnail-${widget.product.productId}',
                                child: CachedNetworkImage(
                                  imageUrl: widget.product.thumbnailImage,
                                  // "https://alnoormdf.com/" +
                                  //     widget.product.productImage,
                                  width: double.infinity,
                                  cacheManager: getIt<CacheManager>(),

                                  height: constraints.maxHeight *
                                      0.5, // Adjust as per your layout
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/images/Logo.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),

                                  errorWidget: (context, url, error) {
                                    return const Center(
                                        child: Text('Failed to load image'));
                                  },
                                ),
                              ),

                              //  FutureBuilder<ImageProvider>(
                              //   future: _imageFuture,
                              //   builder: (context, snapshot) {
                              //     if (snapshot.connectionState ==
                              //         ConnectionState.done) {
                              //       if (snapshot.hasError) {
                              //         return Image.asset(
                              //           'assets/images/Logo.png',
                              //           fit: BoxFit.cover,
                              //           width: double.infinity,
                              //           height: double.infinity,
                              //         );
                              //       }
                              //       return Image(
                              //         image: snapshot.data!,
                              //         fit: BoxFit.cover,
                              //         width: double.infinity,
                              //         height: double.infinity,
                              //       );
                              //     } else {
                              //       return ImageSkeleton(
                              //         width: double.infinity,
                              //         height: double.infinity,
                              //       );
                              //     }
                              //   },
                              // ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0,
                                    right: screenWidth * 0.02,
                                    top: constraints.maxHeight * 0.03,
                                    bottom: constraints.maxHeight * 0.03),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/images/Logo_Black.svg',
                                        width: 47,
                                        height: 47,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    if (!isGuestUser) // Show the menu icon only if not a guest user
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/images/menu.svg',
                                          width: 30,
                                          height: 30,
                                        ),
                                        onPressed: () {
                                          _isMenuVisibleNotifier.value =
                                              !_isMenuVisibleNotifier.value;
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Center(
                          child: Text(
                            widget.product.productName,
                            style: GoogleFonts.poppins(
                              fontSize: constraints.maxWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Decor Type: ${widget.product.productType == "" ? "None" : widget.product.productType}",
                            style: GoogleFonts.poppins(
                              fontSize: constraints.maxWidth * 0.035,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildIconButton(
                                iconPath: 'assets/images/Add New.png',
                                label: "Add to\nMoodboard",
                                onPressed: () {
                                  ImageManager().setImageFromCamera(
                                      widget.product.thumbnailImage);
                                  Navigator.of(context).pop({
                                    'images': [
                                      ImageManager().getImage(1),
                                      ImageManager().getImage(2),
                                      ImageManager().getImage(3),
                                      ImageManager().getImage(4),
                                      ImageManager().getImage(5),
                                      ImageManager().getImage(6),
                                    ],
                                    'snackbarMessage':
                                        'Added To Moodboard successfully',
                                  });
                                },
                                constraints: constraints),
                            _buildIconButton(
                                iconPath: 'assets/images/Buy.png',
                                label: "Order\nSample",
                                onPressed: () {},
                                constraints: constraints),
                            _buildIconButton(
                                iconPath: 'assets/images/Share.png',
                                label: "Share\nNow",
                                onPressed: () {
                                  _shareProduct(context);
                                },
                                constraints: constraints),
                            _buildIconButton(
                                iconPath: 'assets/images/Download.png',
                                label: "Download\nCatalogue",
                                onPressed: () {
                                  downloadService.downloadImage(
                                    "https://alnoormdf.com/" +
                                        widget.product.productImage,
                                    widget.product.productName,
                                  );
                                },
                                constraints: constraints),
                          ],
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05),
                          child: Center(
                            child: Text(
                              widget.product.productShortDesc,
                              style: GoogleFonts.poppins(
                                fontSize: constraints.maxWidth * 0.035,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines:
                                  8, // Set the maximum number of lines to 8
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Center(
                          child: SizedBox(
                            width: constraints.maxWidth * 0.6,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF222020),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text("More Decor"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                      valueListenable: _isMenuVisibleNotifier,
                      builder: (context, isVisible, child) {
                        return (isVisible && !isGuestUser)
                            ? Positioned(
                                top: constraints.maxHeight * 0.09,
                                right: 30,
                                child: HamburgerMenu(
                                  isGuestUser: isGuestUser,
                                  isMenuVisible: isVisible,
                                  onMenuToggle: _toggleMenu,
                                ),
                              )
                            : SizedBox.shrink();
                      }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _shareProduct(BuildContext context) {
    final String imageUrl =
        "https://alnoormdf.com/" + widget.product.productImage;
    Share.share(imageUrl, subject: widget.product.productName);
  }

  Widget _buildIconButton({
    required String iconPath,
    required String label,
    required VoidCallback onPressed,
    required BoxConstraints constraints,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Image.asset(
            iconPath,
            color: Colors.black,
            width: constraints.maxWidth * 0.08,
            height: constraints.maxWidth * 0.08,
          ),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: constraints.maxWidth * 0.03),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _toggleMenu() {
    _isMenuVisibleNotifier.value = !_isMenuVisibleNotifier.value;
  }
}
