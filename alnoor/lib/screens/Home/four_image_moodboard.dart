
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class FourImageScreen extends StatefulWidget {
  final String? initialImage1;
  final String? initialImage2;
  final String? initialImage3;
  final String? initialImage4;

  const FourImageScreen({
    Key? key,
    this.initialImage1,
    this.initialImage2,
    this.initialImage3,
    this.initialImage4, required Null Function() onClearImage1, required Null Function() onClearImage2, required Null Function() onClearImage3, required Null Function() onClearImage4,
  }) : super(key: key);

  @override
  _FourImageScreenState createState() => _FourImageScreenState();
}

class _FourImageScreenState extends State<FourImageScreen> {
  String? image1;
  String? image2;
  String? image3;
  String? image4;

  @override
  void initState() {
    super.initState();
    image1 = widget.initialImage1;
    image2 = widget.initialImage2;
    image3 = widget.initialImage3;
    image4 = widget.initialImage4;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop([image1, image2, image3, image4]);
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
              padding: EdgeInsets.zero,
              children: [
                _buildImageContainer(context, image1, 1),
                _buildImageContainer(context, image2, 2),
                _buildImageContainer(context, image3, 3),
                _buildImageContainer(context, image4, 4),
              ],
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.of(context).pop([image1, image2, image3, image4]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, String? imageUrl, int targetImage) {
  return Stack(
    children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        child: imageUrl != null
            ? (Uri.parse(imageUrl).isAbsolute && imageUrl.startsWith('http'))
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Failed to load image'));
                    },
                  )
                : Image.file(
                    File(imageUrl),
                    fit: BoxFit.cover,
                  )
            : _buildPlaceholder(context, targetImage),
      ),
      if (imageUrl != null)
        Positioned(
          top: 25,
          left: 15,
          child: GestureDetector(
            onTap: () {
              setState(() {
                switch (targetImage) {
                  case 1:
                    image1 = null;
                    break;
                  case 2:
                    image2 = null;
                    break;
                  case 3:
                    image3 = null;
                    break;
                  case 4:
                    image4 = null;
                    break;
                }
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
  );
}


  Widget _buildPlaceholder(BuildContext context, int targetImage) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage('assets/images/image.png'),
          fit: BoxFit.cover,
        ),
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
                    Navigator.of(context).pop(await picker.pickImage(source: ImageSource.gallery));
                  },
                ),
                const SizedBox(height: 10),
                _buildButton(
                  context,
                  "Take Photo",
                  Colors.black,
                  Colors.white,
                  () async {
                    Navigator.of(context).pop(await picker.pickImage(source: ImageSource.camera));
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
        switch (targetImage) {
          case 1:
            image1 = image.path;
            break;
          case 2:
            image2 = image.path;
            break;
          case 3:
            image3 = image.path;
            break;
          case 4:
            image4 = image.path;
            break;
        }
      });
    }
  }

  Widget _buildButton(BuildContext context, String text, Color backgroundColor, Color textColor, VoidCallback onPressed) {
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
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
