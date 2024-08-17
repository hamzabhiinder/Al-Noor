// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class TwoImageScreen extends StatefulWidget {
  final String? initialImage1;
  final String? initialImage2;
  final VoidCallback? onClearImage1;
  final VoidCallback? onClearImage2;

  const TwoImageScreen({
    Key? key,
    this.initialImage1,
    this.initialImage2,
    this.onClearImage1,
    this.onClearImage2,
  }) : super(key: key);

  @override
  _TwoImageScreenState createState() => _TwoImageScreenState();
}

class _TwoImageScreenState extends State<TwoImageScreen> {
  String? image1;
  String? image2;

  @override
  void initState() {
    super.initState();
    image1 = widget.initialImage1;
    image2 = widget.initialImage2;
  }

  void _swapImages() {
    setState(() {
      final temp = image1;
      image1 = image2;
      image2 = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop([image1, image2]);
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
                      if (image1 != null)
                        (Uri.parse(image1!).isAbsolute &&
                                image1!.startsWith('http'))
                            ? Image.network(
                                image1!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                      child: Text('Failed to load image'));
                                },
                              )
                            : Image.file(
                                File(image1!),
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
                              image1 = null;
                            });
                            if (widget.onClearImage1 != null) {
                              widget.onClearImage1!();
                            }
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
                      if (image2 != null)
                        (Uri.parse(image2!).isAbsolute &&
                                image2!.startsWith('http'))
                            ? Image.network(
                                image2!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                      child: Text('Failed to load image'));
                                },
                              )
                            : Image.file(
                                File(image2!),
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
                              image2 = null;
                            });
                            if (widget.onClearImage2 != null) {
                              widget.onClearImage2!();
                            }
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
                  Navigator.of(context).pop([image1, image2]);
                },
              ),
            ),
            if (image1 != null && image2 != null)
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
          image1 = image.path;
        } else if (targetImage == 2) {
          image2 = image.path;
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
