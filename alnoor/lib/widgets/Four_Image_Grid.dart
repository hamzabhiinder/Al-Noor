
import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/Home/four_image_moodboard.dart';

class FourImageDragTargetContainer extends StatefulWidget {
  @override
  _FourImageDragTargetContainerState createState() =>
      _FourImageDragTargetContainerState();
}

class _FourImageDragTargetContainerState
    extends State<FourImageDragTargetContainer> {
  String? _imageUrl1;
  String? _imageUrl2;
  String? _imageUrl3;
  String? _imageUrl4;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final images = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FourImageScreen(
              initialImage1: _imageUrl1,
              initialImage2: _imageUrl2,
              initialImage3: _imageUrl3,
              initialImage4: _imageUrl4,
              // Clear image callbacks
              onClearImage1: () {
                setState(() {
                  _imageUrl1 = null;
                });
              },
              onClearImage2: () {
                setState(() {
                  _imageUrl2 = null;
                });
              },
              onClearImage3: () {
                setState(() {
                  _imageUrl3 = null;
                });
              },
              onClearImage4: () {
                setState(() {
                  _imageUrl4 = null;
                });
              },
            ),
          ),
        );
        
        // Update image URLs after returning from FourImageScreen
        if (images != null && images is List<String?>) {
          setState(() {
            _imageUrl1 = images[0];
            _imageUrl2 = images[1];
            _imageUrl3 = images[2];
            _imageUrl4 = images[3];
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
            if (_imageUrl1 == null || _imageUrl1!.isEmpty) {
              _imageUrl1 = newImageUrl;
            } else if (_imageUrl2 == null || _imageUrl2!.isEmpty) {
              _imageUrl2 = newImageUrl;
            } else if (_imageUrl3 == null || _imageUrl3!.isEmpty) {
              _imageUrl3 = newImageUrl;
            } else if (_imageUrl4 == null || _imageUrl4!.isEmpty) {
              _imageUrl4 = newImageUrl;
            } else {
              _imageUrl1 = newImageUrl;
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
                        child: _displayImage(_imageUrl1),
                      ),
                      Container(
                        width: 1.0,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: _displayImage(_imageUrl2),
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
                        child: _displayImage(_imageUrl3),
                      ),
                      Container(
                        width: 1.0,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: _displayImage(_imageUrl4),
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
      return Container(); // Empty container for null images
    } else if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      // Network image
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Text('Failed to load image'));
        },
      );
    } else {
      // Local file image
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
      );
    }
  }
}
