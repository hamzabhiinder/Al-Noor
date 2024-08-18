// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:io';

import 'package:alnoor/classes/image_manager.dart';
import 'package:flutter/material.dart';

import '../screens/Home/moodboard.dart';

class DragTargetContainer1 extends StatefulWidget {
  @override
  _DragTargetContainerState createState() => _DragTargetContainerState();
}

class _DragTargetContainerState extends State<DragTargetContainer1> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TwoImageScreen(),
          ),
        );

        if (result != null && result is List<String?>) {
          setState(() {
            ImageManager().setImage(1, result[0]);
            ImageManager().setImage(2, result[1]);
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
            if (ImageManager().getImage(1) == null ||
                ImageManager().getImage(1) == null) {
              ImageManager().setImage(1, newImageUrl);
            } else if (ImageManager().getImage(2) == null ||
                ImageManager().getImage(2) == null) {
              ImageManager().setImage(2, newImageUrl);
            } else {
              ImageManager().setImage(1, newImageUrl);
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ImageManager().getImage(1) != null
                      ? (Uri.parse(ImageManager().getImage(1) ?? "")
                                  .isAbsolute &&
                              (ImageManager().getImage(1) ?? "")
                                  .startsWith('http'))
                          ? Image.network(
                              (ImageManager().getImage(1) ?? ""),
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                          : Image.file(
                              File((ImageManager().getImage(1) ?? "")),
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                      : Container(),
                ),
                Container(
                  width: 1.0,
                  color: Colors.black,
                ),
                Expanded(
                  child: ImageManager().getImage(2) != null
                      ? (Uri.parse(ImageManager().getImage(2) ?? "")
                                  .isAbsolute &&
                              (ImageManager().getImage(2) ?? "")
                                  .startsWith('http'))
                          ? Image.network(
                              (ImageManager().getImage(2) ?? ""),
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                          : Image.file(
                              File((ImageManager().getImage(2) ?? "")),
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                      : Container(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
