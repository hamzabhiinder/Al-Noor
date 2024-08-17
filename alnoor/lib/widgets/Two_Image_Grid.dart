// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';

import '../screens/Home/moodboard.dart';

class DragTargetContainer1 extends StatefulWidget {
  final void Function(int, dynamic) setImageCallback;
  var image1;
  var image2;

  DragTargetContainer1(
      {required this.setImageCallback,
      required this.image1,
      required this.image2});

  @override
  _DragTargetContainerState createState() => _DragTargetContainerState();
}

class _DragTargetContainerState extends State<DragTargetContainer1> {
  void _clearImage1() {
    widget.setImageCallback(1, "");
  }

  void _clearImage2() {
    widget.setImageCallback(2, "");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TwoImageScreen(
              initialImage1: widget.image1,
              initialImage2: widget.image2,
              onClearImage1: _clearImage1,
              onClearImage2: _clearImage2,
            ),
          ),
        );

        if (result != null && result is List<String?>) {
          setState(() {
            widget.setImageCallback(1, result[0]);
            widget.setImageCallback(2, result[1]);
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
            if (widget.image1 == null || widget.image1.isEmpty) {
              widget.setImageCallback(1, newImageUrl);
            } else if (widget.image2 == null || widget.image2.isEmpty) {
              widget.setImageCallback(2, newImageUrl);
            } else {
              widget.setImageCallback(1, newImageUrl);
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
                  child: widget.image1 != null
                      ? (Uri.parse(widget.image1).isAbsolute &&
                              widget.image1.startsWith('http'))
                          ? Image.network(
                              widget.image1,
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                          : Image.file(
                              File(widget.image1),
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
                  child: widget.image2 != null
                      ? (Uri.parse(widget.image2).isAbsolute &&
                              widget.image2.startsWith('http'))
                          ? Image.network(
                              widget.image2,
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                          : Image.file(
                              File(widget.image2),
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
