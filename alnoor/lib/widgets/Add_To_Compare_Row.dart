import 'dart:ui';
import 'package:alnoor/classes/image_manager.dart';
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
      ImageManager().setImageFromCamera(image.path);
      setState(() {
        ImageManager().getImage(1);
        ImageManager().getImage(2);
        ImageManager().getImage(3);
        ImageManager().getImage(4);
        ImageManager().getImage(5);
        ImageManager().getImage(6);
      });
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
              DragTargetContainer1(),
              const SizedBox(width: 20),
              FourImageDragTargetContainer(),
            ],
          ),
        ],
      ),
    );
  }
}
