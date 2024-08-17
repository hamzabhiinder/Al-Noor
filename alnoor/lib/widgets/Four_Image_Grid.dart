// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/Home/four_image_moodboard.dart';

// ignore: must_be_immutable
class FourImageDragTargetContainer extends StatefulWidget {
  final void Function(int, dynamic) setImageCallback;
  var imageUrl1;
  var imageUrl2;
  var imageUrl3;
  var imageUrl4;

  FourImageDragTargetContainer(
      {required this.setImageCallback,
      required this.imageUrl1,
      required this.imageUrl2,
      required this.imageUrl3,
      required this.imageUrl4});

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
            builder: (context) => FourImageScreen(
              initialImage1: widget.imageUrl1,
              initialImage2: widget.imageUrl2,
              initialImage3: widget.imageUrl3,
              initialImage4: widget.imageUrl4,
              onClearImage1: () {
                widget.setImageCallback(3, "");
              },
              onClearImage2: () {
                widget.setImageCallback(4, "");
              },
              onClearImage3: () {
                widget.setImageCallback(5, "");
              },
              onClearImage4: () {
                widget.setImageCallback(6, "");
              },
            ),
          ),
        );

        if (images != null && images is List<String?>) {
          widget.setImageCallback(3, images[0]);
          widget.setImageCallback(4, images[1]);
          widget.setImageCallback(5, images[2]);
          widget.setImageCallback(6, images[3]);
        }
      },
      child: DragTarget<String>(
        onWillAccept: (data) {
          return true;
        },
        onAcceptWithDetails: (DragTargetDetails<String> details) {
          final String newImageUrl = details.data;
          setState(() {
            if (widget.imageUrl1 == null || widget.imageUrl1!.isEmpty) {
              widget.setImageCallback(3, newImageUrl);
            } else if (widget.imageUrl2 == null || widget.imageUrl2!.isEmpty) {
              widget.setImageCallback(4, newImageUrl);
            } else if (widget.imageUrl3 == null || widget.imageUrl3!.isEmpty) {
              widget.setImageCallback(5, newImageUrl);
            } else if (widget.imageUrl4 == null || widget.imageUrl4!.isEmpty) {
              widget.setImageCallback(6, newImageUrl);
            } else {
              widget.setImageCallback(3, newImageUrl);
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
                        child: _displayImage(widget.imageUrl1),
                      ),
                      Container(
                        width: 1.0,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: _displayImage(widget.imageUrl2),
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
                        child: _displayImage(widget.imageUrl3),
                      ),
                      Container(
                        width: 1.0,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: _displayImage(widget.imageUrl4),
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
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Text('Failed to load image'));
        },
      );
    } else {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
      );
    }
  }
}
