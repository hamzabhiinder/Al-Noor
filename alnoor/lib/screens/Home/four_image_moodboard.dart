import 'dart:io';
import 'dart:ui';

import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FourImageScreen extends StatefulWidget {
  @override
  _FourImageScreenState createState() => _FourImageScreenState();
}

class _FourImageScreenState extends State<FourImageScreen> {
  List<String?> images = List.generate(4, (index) => null);

  @override
  void initState() {
    super.initState();
    images[0] = ImageManager().getImage(3);
    images[1] = ImageManager().getImage(4);
    images[2] = ImageManager().getImage(5);
    images[3] = ImageManager().getImage(6);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop([
          images[0],
          images[1],
          images[2],
          images[3],
        ]);
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            GridView.builder(
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    MediaQuery.of(context).size.height,
              ),
              itemBuilder: (context, index) {
                return _buildDraggableImageContainer(context, index);
              },
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.of(context).pop([
                    images[0],
                    images[1],
                    images[2],
                    images[3],
                  ]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableImageContainer(BuildContext context, int index) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: DragTarget<int>(
        onAcceptWithDetails: (details) {
          setState(() {
            int fromIndex = details.data;
            String? temp = images[index];
            images[index] = images[fromIndex];
            images[fromIndex] = temp;
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Draggable<int>(
            data: index,
            feedback: Material(
              type: MaterialType.transparency,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                child: _buildImageContainer(context, images[index], index),
              ),
            ),
            childWhenDragging: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: images[index] != null
                      ? (Uri.parse(images[index]!).isAbsolute &&
                              images[index]!.startsWith('http'))
                          ? Image.network(
                              images[index]!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                    child: Text('Failed to load image'));
                              },
                            )
                          : Image.file(
                              File(images[index]!),
                              fit: BoxFit.cover,
                            )
                      : _buildPlaceholder(context, index),
                ),
                if (images[index] != null)
                  Positioned(
                    top: 25,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          images[index] = null;
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
            child: _buildImageContainer(context, images[index], index),
          );
        },
      ),
    );
  }

  Widget _buildImageContainer(
      BuildContext context, String? imageUrl, int index) {
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
              : _buildPlaceholder(context, index),
        ),
        if (imageUrl != null)
          Positioned(
            top: 25,
            left: 15,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  images[index] = null;
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

  Widget _buildPlaceholder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () async {
        await _showImagePicker(context, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/AddImage.svg',
                width: 150,
                height: 150,
                color: Colors.black,
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
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context, int index) async {
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
                const SizedBox(height: 10),
                _buildButton(
                  context,
                  "Select From Decor",
                  Colors.white,
                  Colors.black,
                  () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    bool? isGuestUser = prefs.getBool('isGuestUser');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen()));
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
        images[index] = image.path;
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
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
