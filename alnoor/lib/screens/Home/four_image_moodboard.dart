// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:alnoor/blocs/moodboard_bloc.dart';
import 'package:alnoor/utils/globals.dart' as globals;
import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FourImageScreen extends StatefulWidget {
  @override
  _FourImageScreenState createState() => _FourImageScreenState();
}

class _FourImageScreenState extends State<FourImageScreen> {
  List<String?> images = List.generate(4, (index) => null);
  Timer? _timer;
  bool _isVisible = true;
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
    moodboardName = ImageManager().getName(4) ?? "";
    images[0] = ImageManager().getImage(3);
    images[1] = ImageManager().getImage(4);
    images[2] = ImageManager().getImage(5);
    images[3] = ImageManager().getImage(6);
    _timer = Timer(Duration(seconds: 4), () {
      setState(() {
        _isVisible = false;
      });
      globals.freshLogin = 'false';
    });
    _loadUserStatus();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dispose of the Timer
    super.dispose();
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
          moodboardName,
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
                          ImageManager().getName(4) ?? "",
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
          if (globals.freshLogin ==
              'true') // Replace `yourCondition` with your actual condition
            Center(
              child: _isVisible
                  ? Container(
                      margin: EdgeInsets.only(top: 60),
                      child: Image.asset(
                        'assets/images/animation.gif',
                        width: 130, // Set the desired width
                        height: 130, // Set the desired height
                      )) // Replace with your GIF asset path
                  : Container(), // Empty container when GIF is not visible
            ),
          ((!isGuestUser &&
                  ((images[0] != null && images[0] != "") ||
                      (images[1] != null && images[1] != "") ||
                      (images[2] != null && images[2] != "") ||
                      (images[3] != null && images[3] != "")))
              ? Center(
                  child: GestureDetector(
                      onTap: () {
                        _showSaveDialog(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 7),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      )),
                )
              : SizedBox.shrink()),
        ],
      )),
    );
  }

  Widget _buildDraggableImageContainer(BuildContext context, int index) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: DragTarget<int>(
        onAcceptWithDetails: (details) {
          setState(() {
            print("fourteen");
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
                    bottom: index == 3 || index == 2 ? 45 : 20,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          print("fifteen");
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
        TextEditingController(text: moodboardName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Save As',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'My Moodboard',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (textController.text == "") {
                  // Show a Snackbar with an error message if the moodboard name is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Moodboard name cannot be empty'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  if (textController.text != ImageManager().getName(4)) {
                    ImageManager().setId("");
                  }
                  (moodboardBloc.add(AddMoodboard(
                      image1: await getFileFromLink(images[0] ?? ""),
                      image2: await getFileFromLink(images[1] ?? ""),
                      image3: await getFileFromLink(images[2] ?? ""),
                      image4: await getFileFromLink(images[3] ?? ""),
                      name: textController.text)));
                  ImageManager().setName(4, textController.text);
                  Navigator.of(context).pop();
                } // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
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
            bottom: index == 3 || index == 2 ? 45 : 20,
            right: 15,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  print("sixteen");
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
        print("seventeen");
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
