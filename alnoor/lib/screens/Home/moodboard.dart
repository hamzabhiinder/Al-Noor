// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'dart:io';

import 'package:alnoor/classes/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class TwoImageScreen extends StatefulWidget {
  @override
  _TwoImageScreenState createState() => _TwoImageScreenState();
}

class _TwoImageScreenState extends State<TwoImageScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _swapImages() {
    setState(() {
      final temp = ImageManager().getImage(1);
      ImageManager().setImage(1, ImageManager().getImage(2));
      ImageManager().setImage(2, temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pop([ImageManager().getImage(1), ImageManager().getImage(2)]);
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      if (ImageManager().getImage(1) != null)
                        (Uri.parse(ImageManager().getImage(1)!).isAbsolute &&
                                ImageManager().getImage(1)!.startsWith('http'))
                            ? Image.network(
                                ImageManager().getImage(1)!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                      child: Text('Failed to load image'));
                                },
                              )
                            : Image.file(
                                File(ImageManager().getImage(1)!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                      else
                        _buildPlaceholder(context, 1),
                      Positioned(
                        top: 25,
                        left: 15,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              ImageManager().setImage(1, null);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.backspace,
                              color: Colors.black,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      if (ImageManager().getImage(2) != null)
                        (Uri.parse(ImageManager().getImage(2)!).isAbsolute &&
                                ImageManager().getImage(2)!.startsWith('http'))
                            ? Image.network(
                                ImageManager().getImage(2)!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                      child: Text('Failed to load image'));
                                },
                              )
                            : Image.file(
                                File(ImageManager().getImage(2)!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                      else
                        _buildPlaceholder(context, 2),
                      Positioned(
                        top: 25,
                        left: 15,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              ImageManager().setImage(2, null);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.backspace,
                              color: Colors.black,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.of(context).pop(
                      [ImageManager().getImage(1), ImageManager().getImage(2)]);
                },
              ),
            ),
            if (ImageManager().getImage(1) != null &&
                ImageManager().getImage(2) != null)
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 40,
                left: MediaQuery.of(context).size.width / 2 - 40,
                child: GestureDetector(
                  onTap: _swapImages,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(16),
                    child: SvgPicture.asset(
                      'assets/images/reverse.svg',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, int targetImage) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await _showImagePicker(context, targetImage);
              },
              child: SvgPicture.asset(
                'assets/images/AddImage.svg',
                width: 150,
                height: 150,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'SELECT NEW DECOR',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context, int targetImage) async {
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
      setState(() {
        if (targetImage == 1) {
          ImageManager().setImage(1, image.path);
        } else if (targetImage == 2) {
          ImageManager().setImage(2, image.path);
        }
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
}
