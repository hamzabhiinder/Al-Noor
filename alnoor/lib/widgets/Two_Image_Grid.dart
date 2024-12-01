// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/models/product.dart';
import 'package:flutter/material.dart';

import '../screens/Home/moodboard.dart';

class DragTargetContainer1 extends StatefulWidget {
  @override
  _DragTargetContainerState createState() => _DragTargetContainerState();
}

class _DragTargetContainerState extends State<DragTargetContainer1> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final containerSize = screenSize.width * 0.1;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TwoImageScreen(),
          ),
        );

        if (result != null && result is List<String?>) {
          ImageManager().setImage(1, result[0]);
          ImageManager().setImage(2, result[1]);
        }
      },
      child: DragTarget<Product>(
        onWillAccept: (data) {
          return true;
        },
        onAcceptWithDetails: (DragTargetDetails<Product> details) {
          final String newImageUrl = details.data.thumbnailImage;
          if (ImageManager().getImage(1) == null) {
            ImageManager().setImage(1, newImageUrl);
          } else if (ImageManager().getImage(2) == null) {
            ImageManager().setImage(2, newImageUrl);
          } else {
            ImageManager().setImage(1, newImageUrl);
          }
        },
        builder: (BuildContext context, List<Product?> candidateData,
            List<dynamic> rejectedData) {
          return Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ValueListenableBuilder<String?>(
                    valueListenable: ImageManager().getImageNotifier(1),
                    builder: (context, imagePath, child) {
                      return imagePath != null
                          ? (Uri.parse(imagePath).isAbsolute &&
                                  imagePath.startsWith('http'))
                              ? Image.network(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                )
                              : Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                )
                          : Container();
                    },
                  ),
                ),
                Container(
                  width: screenSize.width * 0.005,
                  color: Colors.black,
                ),
                Expanded(
                  child: ValueListenableBuilder<String?>(
                    valueListenable: ImageManager().getImageNotifier(2),
                    builder: (context, imagePath, child) {
                      return imagePath != null
                          ? (Uri.parse(imagePath).isAbsolute &&
                                  imagePath.startsWith('http'))
                              ? Image.network(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                )
                              : Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                )
                          : Container();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
