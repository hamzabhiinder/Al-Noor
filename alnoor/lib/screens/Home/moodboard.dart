// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'dart:io';

import 'package:alnoor/blocs/moodboard_bloc.dart';
import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:alnoor/utils/globals.dart' as globals;
import 'package:path_provider/path_provider.dart';

class TwoImageScreen extends StatefulWidget {
  @override
  _TwoImageScreenState createState() => _TwoImageScreenState();
}

class _TwoImageScreenState extends State<TwoImageScreen> {
  String moodboardName = "";
  bool isGuestUser = true;

  Future<void> _loadUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print("nineteen");
      isGuestUser = prefs.getBool('isGuestUser') ?? true;
    });
  }

  @override
  void initState() {
    super.initState();
    moodboardName = ImageManager().getName(2) ?? "";
    _loadUserStatus();
  }

  void _swapImages() {
    setState(() {
      print("twentyeight");
      final temp = ImageManager().getImage(1);
      ImageManager().setImage(1, ImageManager().getImage(2));
      ImageManager().setImage(2, temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop([
          ImageManager().getImage(1),
          ImageManager().getImage(2),
          moodboardName
        ]);
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
                        top: 45,
                        left: 15,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              print("twentynine");
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
                              print("thirty");
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
            if (ImageManager().getImage(1) != null ||
                ImageManager().getImage(2) != null)
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 40,
                left: MediaQuery.of(context).size.width / 2 - 40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
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
                        )),
                    SizedBox(height: 4),
                    (!isGuestUser
                        ? (GestureDetector(
                            onTap: () {
                              _showSaveDialog(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            )))
                        : SizedBox.shrink()),
                  ],
                ),
              ),
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Center(
                          child: Text(
                            ImageManager().getName(2) ?? "",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to determine whether the link is a URL or a local path and handle it accordingly
  Future<File?> getFileFromLink(String link) async {
    if (link.startsWith('http://') || link.startsWith('https://')) {
      return await _downloadFile(link);
    } else {
      return _getLocalFile(link);
    }
  }

// Function to download the file if it's a URL
  Future<File?> _downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/${url.split('/').last}';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        print('Failed to download file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
    return null;
  }

// Function to get the file if it's a local file path
  File? _getLocalFile(String filePath) {
    final file = File(filePath);

    if (file.existsSync()) {
      return file;
    } else {
      print('Local file does not exist at the specified path.');
      return null;
    }
  }

  void _showSaveDialog(BuildContext context) {
    final moodboardBloc = BlocProvider.of<MoodboardBloc>(context);
    final TextEditingController textController =
        TextEditingController(text: ImageManager().getName(2));
    var loader = false;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing the dialog when loading
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                loader ? '' : 'Save As',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              content: loader
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Saving...'),
                      ],
                    )
                  : TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'My Moodboard',
                      ),
                    ),
              actions: loader
                  ? [] // No actions when loading
                  : [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            loader = true;
                          });

                          if (textController.text.isEmpty) {
                            // Show a Snackbar with an error message if the moodboard name is empty
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Moodboard name cannot be empty'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            setState(() {
                              loader = false;
                            });
                          } else {
                            globals.openedTab = 2;
                            if (textController.text !=
                                ImageManager().getName(2)) {
                              ImageManager().setId(2, "");
                            }
                            var image1 = await getFileFromLink(
                                ImageManager().getImage(1) ?? "");
                            var image2 = await getFileFromLink(
                                ImageManager().getImage(2) ?? "");
                            moodboardBloc.add(AddMoodboard(
                              moodboardId: ImageManager().getId(2) ?? "",
                              image1: image1,
                              image2: image2,
                              image3: null,
                              image4: null,
                              name: textController.text,
                            ));
                            ImageManager().setName(2, textController.text);
                            setState(() {
                              loader = false;
                            });

                            Navigator.of(context).pop(); // Close the dialog
                          }
                        },
                        child: Text('Save'),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context, int targetImage) {
    return GestureDetector(
      onTap: () async {
        await _showImagePicker(context, targetImage);
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
                const SizedBox(height: 10),
                _buildButton(
                  context,
                  "Select From Library",
                  Colors.white,
                  Colors.black,
                  () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
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
        print("thirtyone");
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
