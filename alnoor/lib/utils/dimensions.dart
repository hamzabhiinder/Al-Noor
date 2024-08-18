import 'package:flutter/material.dart';

class CommonDimensions {
  final double containerWidth;
  final double containerHeight;
  final double dividerThickness;
  final double iconSize;

  CommonDimensions(BuildContext context)
      : containerWidth = MediaQuery.of(context).size.width * 0.1,
        containerHeight = MediaQuery.of(context).size.height * 0.1,
        dividerThickness = MediaQuery.of(context).size.width * 0.005,
        iconSize = MediaQuery.of(context).size.width * 0.1;
}
