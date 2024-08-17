import 'dart:ui';
import 'package:alnoor/widgets/Four_Image_Grid.dart';
import 'package:alnoor/widgets/Two_Image_Grid.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddToCompareRow extends StatefulWidget {
  final bool showCamera;
  const AddToCompareRow({Key? key, required this.showCamera}) : super(key: key);

  @override
  _AddToCompareRowState createState() => _AddToCompareRowState();
}

class _AddToCompareRowState extends State<AddToCompareRow> {
  var _image1;
  var _image2;
  var _image3;
  var _image4;
  var _image5;
  var _image6;

  void _setImagefromCamera(String path) {
    if (_image1 == null || _image1!.isEmpty) {
      setState(() {
        _image1 = path;
      });
    } else if (_image2 == null || _image2!.isEmpty) {
      setState(() {
        _image2 = path;
      });
    } else if (_image3 == null || _image3!.isEmpty) {
      setState(() {
        _image3 = path;
      });
    } else if (_image4 == null || _image4!.isEmpty) {
      setState(() {
        _image4 = path;
      });
    } else if (_image5 == null || _image5!.isEmpty) {
      setState(() {
        _image5 = path;
      });
    } else if (_image6 == null || _image6!.isEmpty) {
      setState(() {
        _image6 = path;
      });
    } else {
      setState(() {
        _image1 = path;
      });
    }
  }

  void setImage(index, path) {
    if (index == 1) {
      setState(() {
        _image1 = path;
      });
    } else if (index == 2) {
      setState(() {
        _image2 = path;
      });
    } else if (index == 3) {
      setState(() {
        _image3 = path;
      });
    } else if (index == 4) {
      setState(() {
        _image4 = path;
      });
    } else if (index == 5) {
      setState(() {
        _image5 = path;
      });
    } else {
      setState(() {
        _image6 = path;
      });
    }
  }

  Future<void> _showImagePicker(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildButton(
                  context,
                  "Upload From Gallery",
                  Colors.white,
                  Colors.black,
                  () async {
                    Navigator.of(context).pop(
                        await picker.pickImage(source: ImageSource.gallery));
                  },
                ),
                const SizedBox(height: 10),
                _buildButton(
                  context,
                  "Take Photo",
                  Colors.black,
                  Colors.white,
                  () async {
                    Navigator.of(context).pop(
                        await picker.pickImage(source: ImageSource.camera));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (image != null) {
      print('Selected image path: ${image.path}');
      _setImagefromCamera(image.path);
    }
  }

  Widget _buildButton(BuildContext context, String text, Color backgroundColor,
      Color textColor, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Drag To View",
                style: GoogleFonts.poppins(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.showCamera)
                (Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () async {
                      await _showImagePicker(context);
                    },
                  ),
                )),
              if (widget.showCamera) (const SizedBox(width: 20)),
              DragTargetContainer1(
                  setImageCallback: setImage, image1: _image1, image2: _image2),
              const SizedBox(width: 20),
              FourImageDragTargetContainer(
                setImageCallback: setImage,
                imageUrl1: _image3,
                imageUrl2: _image4,
                imageUrl3: _image5,
                imageUrl4: _image6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
