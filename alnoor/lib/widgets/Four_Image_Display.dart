import 'dart:io';
import 'package:alnoor/classes/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../screens/Home/four_image_moodboard.dart';

class FourImageDisplay extends StatefulWidget {
  final String imageUrl1;
  final String imageUrl2;
  final String imageUrl3;
  final String imageUrl4;
  final String id;
  final String name;

  const FourImageDisplay({
    Key? key,
    required this.imageUrl1,
    required this.imageUrl2,
    required this.imageUrl3,
    required this.imageUrl4,
    required this.id,
    required this.name,
  }) : super(key: key);

  @override
  _FourImageDisplayState createState() => _FourImageDisplayState();
}

class _FourImageDisplayState extends State<FourImageDisplay> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final containerSize = screenSize.width * 0.1;
    final dividerThickness = screenSize.width * 0.005;

    return GestureDetector(
      onTap: () async {
        ImageManager().setImage(3, widget.imageUrl1);
        ImageManager().setImage(4, widget.imageUrl2);
        ImageManager().setImage(5, widget.imageUrl3);
        ImageManager().setImage(6, widget.imageUrl4);
        ImageManager().setName(4, widget.name);
        ImageManager().setId(widget.id);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FourImageScreen(),
          ),
        );
      },
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(child: _displayImage(widget.imageUrl1)),
                    Container(
                      width: dividerThickness,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                        ),
                        child: _displayImage(widget.imageUrl2),
                      ),
                    ),
                  ],
                ),
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
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                      child: _displayImage(widget.imageUrl3),
                    ),
                  ),
                  Container(
                    width: dividerThickness,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(16),
                      ),
                      child: _displayImage(widget.imageUrl4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayImage(String imageUrl) {
    return (imageUrl.startsWith('http') || imageUrl.startsWith('https'))
        ? Image.network(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return _buildShimmer();
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('Failed to load image'));
            },
          )
        : Image.file(
            File(imageUrl),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
      ),
    );
  }
}
