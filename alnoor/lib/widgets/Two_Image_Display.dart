import 'dart:io';
import 'package:alnoor/classes/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../screens/Home/moodboard.dart';

class TwoImageDisplay extends StatefulWidget {
  final String imageUrl1;
  final String imageUrl2;
  final String name;
  final String id;

  const TwoImageDisplay(
      {Key? key,
      required this.imageUrl1,
      required this.imageUrl2,
      required this.name,
      required this.id})
      : super(key: key);

  @override
  _TwoImageDisplayState createState() => _TwoImageDisplayState();
}

class _TwoImageDisplayState extends State<TwoImageDisplay> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final containerSize = screenSize.width * 0.1;

    return GestureDetector(
      onTap: () async {
        ImageManager().setImage(1, widget.imageUrl1);
        ImageManager().setImage(2, widget.imageUrl2);
        ImageManager().setName(2, widget.name);
        ImageManager().setId(widget.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TwoImageScreen(),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: (Uri.parse(widget.imageUrl1).isAbsolute &&
                        widget.imageUrl1.startsWith('http'))
                    ? Image.network(
                        widget.imageUrl1,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return _buildShimmer();
                        },
                      )
                    : Image.file(
                        File(widget.imageUrl1),
                        fit: BoxFit.cover,
                        height: double.infinity,
                      ),
              ),
            ),
            Container(
              width: screenSize.width * 0.005,
              color: Colors.black,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: (Uri.parse(widget.imageUrl2).isAbsolute &&
                        widget.imageUrl2.startsWith('http'))
                    ? Image.network(
                        widget.imageUrl2,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return _buildShimmer();
                        },
                      )
                    : Image.file(
                        File(widget.imageUrl2),
                        fit: BoxFit.cover,
                        height: double.infinity,
                      ),
              ),
            ),
          ],
        ),
      ),
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
