import 'package:flutter/material.dart';
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
  bool _isMenuVisible = false;
  bool isGuestUser = true; // Default to true; will be updated later

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final DownloadService downloadService = DownloadService(
    scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
  );

  @override
  void initState() {
    super.initState();
    _loadUserStatus(); // Load guest user status
  }

  Future<void> _loadUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isGuestUser = prefs.getBool('isGuestUser') ?? true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageFuture =
        _loadImage("https://alnoormdf.com/" + widget.product.productImage);
  }

  Future<ImageProvider> _loadImage(String url) async {
    try {
      final image = NetworkImage(url);
      await precacheImage(image, context);
      return image;
    } catch (e) {
      return AssetImage('assets/images/Logo.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        if (_isMenuVisible) {
          setState(() {
            _isMenuVisible = false;
          });
        }
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
                              child: FutureBuilder<ImageProvider>(
                                future: _imageFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return Image.asset(
                                        'assets/images/Logo.png',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      );
                                    }
                                    return Image(
                                      image: snapshot.data!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05,
                                    vertical: constraints.maxHeight * 0.03),
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
                                          setState(() {
                                            _isMenuVisible = !_isMenuVisible;
                                          });
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
                                onPressed: () {},
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
                              maxLines: 8, // Set the maximum number of lines to 8
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
                  if (_isMenuVisible && !isGuestUser)
                    Positioned(
                      top: constraints.maxHeight * 0.09,
                      right: 30,
                      child: HamburgerMenu(
                        isGuestUser: isGuestUser,
                        isMenuVisible: _isMenuVisible,
                        onMenuToggle: _toggleMenu,
                      ),
                    ),
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
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
  }
}
