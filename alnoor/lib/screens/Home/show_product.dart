import 'package:alnoor/utils/reusable_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:alnoor/models/product.dart';

class ShowProductScreen extends StatelessWidget {
  final Product product;

  ShowProductScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: ReusableCachedImage(
            width: double.infinity,
            height: double.infinity,
            imageUrl:
                product.thumbnailImage,
                //"https://alnoormdf.com/" + product.productImage,
            showProgress: true,
          )
              //  Image.network(
              //   "https://alnoormdf.com/" + product.productImage,
              //   fit: BoxFit.cover,
              //   height: double.infinity,
              //   width: double.infinity,
              //   alignment: Alignment.center,
              //   loadingBuilder: (BuildContext context, Widget child,
              //       ImageChunkEvent? loadingProgress) {
              //     if (loadingProgress == null) {
              //       return child; // The image has finished loading
              //     } else {
              //       return Center(
              //         child: CircularProgressIndicator(
              //           value: loadingProgress.expectedTotalBytes != null
              //               ? loadingProgress.cumulativeBytesLoaded /
              //                   (loadingProgress.expectedTotalBytes!)
              //               : null,
              //         ),
              //       );
              //     }
              //   },
              // ),
              ),
          Positioned(
            top: 40.0, // Position it a bit below the status bar
            right: 16.0, // Align it to the right edge
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop(); // Close the screen
              },
            ),
          ),
        ],
      ),
    );
  }
}
