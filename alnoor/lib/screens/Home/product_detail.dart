import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:alnoor/widgets/Image_Skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alnoor/models/product.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final bool isFavourites;

  ProductDetailScreen({required this.product, required this.isFavourites});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<ImageProvider> _imageFuture;

  @override
  void initState() {
    super.initState();
    // Any other initialization code
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
      print("Hello");
      print(e);
      return AssetImage('assets/images/Logo.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.4,
                      width: double.infinity,
                      child: FutureBuilder<ImageProvider>(
                        future: _imageFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
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
                            return ImageSkeleton(
                              width: double.infinity,
                              height: double.infinity,
                            );
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/images/menu.svg',
                                width: 30,
                                height: 30,
                              ),
                              onPressed: () {},
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
                    "Decor Type: ${widget.product.productType}",
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
                          Navigator.of(context).pop([
                            ImageManager().getImage(1),
                            ImageManager().getImage(2),
                            ImageManager().getImage(3),
                            ImageManager().getImage(4),
                            ImageManager().getImage(5),
                            ImageManager().getImage(6)
                          ]);
                          // if (widget.isFavourites)
                          //   (Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => Favourites(
                          //               index: 0,
                          //             )),
                          //   ));
                          // if (!widget.isFavourites) {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => HomeScreen()),
                          //   );
                          // }
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
                          _downloadImage(context);
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
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.02),
                Center(
                  child: SizedBox(
                    width: constraints.maxWidth * 0.6,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
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
          );
        },
      ),
    );
  }

  void _shareProduct(BuildContext context) {
    final String imageUrl =
        "https://alnoormdf.com/" + widget.product.productImage;
    Share.share(imageUrl, subject: widget.product.productName);
  }

  Future<void> _downloadImage(BuildContext context) async {
    final String imageUrl =
        "https://alnoormdf.com/" + widget.product.productImage;
    try {
      Directory directory = Directory('/storage/emulated/0/Download');
      String filePath = '${directory.path}/${widget.product.productName}.jpg';
      print(filePath);
      Dio dio = Dio();
      await dio.download(imageUrl, filePath);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Downloaded to $filePath"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to download image."),
      ));
    }
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
}
