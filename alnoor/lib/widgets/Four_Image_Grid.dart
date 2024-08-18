// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:alnoor/classes/image_manager.dart';
import 'package:flutter/material.dart';
import '../screens/Home/four_image_moodboard.dart';

// ignore: must_be_immutable
class FourImageDragTargetContainer extends StatefulWidget {
  @override
  _FourImageDragTargetContainerState createState() =>
      _FourImageDragTargetContainerState();
}

class _FourImageDragTargetContainerState
    extends State<FourImageDragTargetContainer> {
  @override
  Widget build(BuildContext context) {
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

          setState(() {
            ImageManager().getImage(3);
            ImageManager().getImage(4);
            ImageManager().getImage(5);
            ImageManager().getImage(6);
          });
        }
      },
      child: DragTarget<String>(
        onWillAccept: (data) {
          return true;
        },
        onAcceptWithDetails: (DragTargetDetails<String> details) {
          final String newImageUrl = details.data;
          setState(() {
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
          });
        },
        builder: (BuildContext context, List<String?> candidateData,
            List<dynamic> rejectedData) {
          return Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _displayImage(ImageManager().getImage(3)),
                      ),
                      Container(
                        width: 1.0,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: _displayImage(ImageManager().getImage(4)),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1.0,
                  color: Colors.black,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _displayImage(ImageManager().getImage(5)),
                      ),
                      Container(
                        width: 1.0,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: _displayImage(ImageManager().getImage(6)),
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
    if (imageUrl == null) {
      return Container();
    } else if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Text('Failed to load image'));
        },
      );
    } else {
      return Image.file(
        width: double.infinity,
        height: double.infinity,
        File(imageUrl),
        fit: BoxFit.cover,
      );
    }
  }
}
