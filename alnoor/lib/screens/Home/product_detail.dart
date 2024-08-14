import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alnoor/models/product.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

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
                      child: Image.network(
                        "https://alnoormdf.com/" + product.productImage,
                        fit: BoxFit.cover,
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
                                width: screenWidth * 0.08, // Adjust icon size based on screen width
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.menu, color: Colors.white, size: screenWidth * 0.08),
                              onPressed: () {
                                // Handle drawer or menu
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
                    product.productName,
                    style: GoogleFonts.poppins(
                      fontSize: constraints.maxWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Decor Type: ${product.productType}",
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
                      product.productShortDesc,
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
                    width: constraints.maxWidth * 0.6, // Adjust button width based on screen width
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle navigation to more decor
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
    final String imageUrl = "https://alnoormdf.com/" + product.productImage;
    Share.share(imageUrl, subject: product.productName);
  }

  Future<void> _downloadImage(BuildContext context) async {
    final String imageUrl = "https://alnoormdf.com/" + product.productImage;
    try {
      // Get the directory to store the file.
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/${product.productName}.jpg';

      // Download the image file.
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


