// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/utils/reusable_cache_image.dart';
import 'package:flutter/material.dart';
import '../screens/Home/four_image_moodboard.dart';

class FourImageDragTargetContainer extends StatefulWidget {
  @override
  _FourImageDragTargetContainerState createState() =>
      _FourImageDragTargetContainerState();
}

class _FourImageDragTargetContainerState
    extends State<FourImageDragTargetContainer> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final containerSize = screenSize.width * 0.1; // Use consistent size
    final dividerThickness = screenSize.width * 0.005;

    return GestureDetector(
      onTap: () async {
        final images = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FourImageScreen(),
          ),
        );

        if (images != null && images is List<String?>) {
          ImageManager().setImage(3, images[0]);
          ImageManager().setImage(4, images[1]);
          ImageManager().setImage(5, images[2]);
          ImageManager().setImage(6, images[3]);
        }
      },
      child: DragTarget<String>(
        onWillAccept: (data) {
          return true;
        },
        onAcceptWithDetails: (DragTargetDetails<String> details) {
          final String newImageUrl = details.data;
          if (ImageManager().getImage(3) == null ||
              ImageManager().getImage(3) == "") {
            ImageManager().setImage(3, newImageUrl);
          } else if (ImageManager().getImage(4) == null ||
              ImageManager().getImage(4) == "") {
            ImageManager().setImage(4, newImageUrl);
          } else if (ImageManager().getImage(5) == null ||
              ImageManager().getImage(5) == "") {
            ImageManager().setImage(5, newImageUrl);
          } else if (ImageManager().getImage(6) == null ||
              ImageManager().getImage(6) == "") {
            ImageManager().setImage(6, newImageUrl);
          } else {
            ImageManager().setImage(3, newImageUrl);
          }
        },
        builder: (BuildContext context, List<String?> candidateData,
            List<dynamic> rejectedData) {
          return Container(
            width: containerSize,
            height: containerSize, // Use consistent size
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<String?>(
                          valueListenable: ImageManager().getImageNotifier(3),
                          builder: (context, imagePath, child) {
                            return _displayImage(imagePath);
                          },
                        ),
                      ),
                      Container(
                        width: dividerThickness,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: ValueListenableBuilder<String?>(
                          valueListenable: ImageManager().getImageNotifier(4),
                          builder: (context, imagePath, child) {
                            return _displayImage(imagePath);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: dividerThickness,
                  color: Colors.black,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<String?>(
                          valueListenable: ImageManager().getImageNotifier(5),
                          builder: (context, imagePath, child) {
                            return _displayImage(imagePath);
                          },
                        ),
                      ),
                      Container(
                        width: dividerThickness,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: ValueListenableBuilder<String?>(
                          valueListenable: ImageManager().getImageNotifier(6),
                          builder: (context, imagePath, child) {
                            return _displayImage(imagePath);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _displayImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container();
    } else if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return ReusableCachedImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: double.infinity,
      );
      // Image.network(
      //   imageUrl,
      //   width: double.infinity,
      //   height: double.infinity,
      //   fit: BoxFit.cover,
      //   errorBuilder: (context, error, stackTrace) {
      //     return Center(child: Text('Failed to load image'));
      //   },
      // );
    } else {
      return Image.file(
        File(imageUrl),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }
}
