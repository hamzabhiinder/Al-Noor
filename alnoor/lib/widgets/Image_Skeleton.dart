import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageSkeleton extends StatelessWidget {
  final double width;
  final double height;

  ImageSkeleton({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[300],
      ),
    );
  }
}
