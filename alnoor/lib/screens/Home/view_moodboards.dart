// ignore_for_file: deprecated_member_use

import 'package:alnoor/blocs/favorites_bloc.dart';
import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/widgets/Add_To_Compare_Row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Moodboards(
        index: 0,
        isGuestUser: false,
      ),
    );
  }
}

class Moodboards extends StatefulWidget {
  final int index;
  final bool isGuestUser;

  Moodboards({required this.index, this.isGuestUser = false});

  @override
  _MoodboardsState createState() => _MoodboardsState();
}

class _MoodboardsState extends State<Moodboards> {
  FocusNode _focusNode = FocusNode();
  int currentPage = 0;
  late PageController _pageController;
  int filterIndex = 0;
  late ValueNotifier<bool> _isMenuVisibleNotifier;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isMenuVisibleNotifier = ValueNotifier<bool>(false);
    _focusNode.addListener(() {
      setState(() {
        print("five");
      });
    });
    setState(() {
      print("six");
      filterIndex = widget.index;
    });
    _pageController = PageController(initialPage: currentPage);
    context.read<FavouriteBloc>().add(LoadFavourites(search: ""));
  }

  void _onSearchSubmit() {
    setState(() {
      print("seven");
      filterIndex = 0;
    });
    context
        .read<FavouriteBloc>()
        .add(LoadFavourites(search: _textController.text));
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    _isMenuVisibleNotifier.dispose();
    super.dispose();
  }

  void setFilterIndex(int value) {
    setState(() {
      print("nine");
      filterIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop([
          ImageManager().getImage(1),
          ImageManager().getImage(2),
          ImageManager().getImage(3),
          ImageManager().getImage(4),
          ImageManager().getImage(5),
          ImageManager().getImage(6),
        ]);
        return false;
      },
      child: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
          _isMenuVisibleNotifier.value = false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            toolbarHeight: screenWidth * 0.125,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.03),
                  child: SvgPicture.asset(
                    'assets/images/Logo_Black.svg',
                    width: screenWidth * 0.14,
                    height: screenWidth * 0.14,
                  )),
            ),
            actions: [
              if (!widget
                  .isGuestUser) // Show menu button only if the user is not a guest
                Padding(
                  padding: EdgeInsets.only(
                      right: screenWidth * 0.02), // Adjust the value as needed
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/menu.svg',
                      width: screenWidth * 0.065,
                      height: screenWidth * 0.065,
                    ),
                    onPressed: () {
                      _isMenuVisibleNotifier.value =
                          !_isMenuVisibleNotifier.value;
                    },
                  ),
                ),
            ],
          ),
          body: Stack(
            children: [
              _buildMainContent(screenWidth, screenHeight, context),
              ValueListenableBuilder<bool>(
                  valueListenable: _isMenuVisibleNotifier,
                  builder: (context, isVisible, child) {
                    return isVisible
                        ? Positioned(
                            top:
                                screenHeight * 0.002, // Adjust the top position
                            right: 10, // Adjust the right position
                            child: HamburgerMenu(
                              isGuestUser: widget.isGuestUser,
                              isMenuVisible: isVisible,
                              onMenuToggle: _toggleMenu,
                            ),
                          )
                        : SizedBox.shrink();
                  }),
            ],
          ),
          bottomNavigationBar: AddToCompareRow(
            showCamera: true,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(
      double screenWidth, double screenHeight, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: screenHeight * 0.035,
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  onChanged: (text) {
                    if (_textController.text.isEmpty) {
                      _onSearchSubmit();
                    }
                  },
                  onSubmitted: (text) {
                    _onSearchSubmit();
                  },
                  decoration: InputDecoration(
                    suffixIcon: _textController.text.isNotEmpty
                        ? IconButton(
                            icon: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.close,
                                size: screenSize.width * 0.03,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _textController.text = "";
                              });
                              _onSearchSubmit(); // Optionally call this if you want to trigger the search when clearing the text
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Color(0xFFEFEFEF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.038),
                  ),
                  style: TextStyle(fontSize: screenHeight * 0.015),
                  textAlign: TextAlign.left,
                ),
              ),
              if (!_focusNode.hasFocus && _textController.text.isEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search,
                        color: Colors.grey, size: screenHeight * 0.02),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Search Your Moodboards Here',
                      style: GoogleFonts.poppins(
                        fontSize: screenHeight * 0.012,
                        color: Color(0xFF9A9A9A),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: screenHeight * 0.011),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Moodboards',
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          ]),
          SizedBox(height: screenHeight * 0.012),
        ],
      ),
    );
  }

  void _toggleMenu() {
    setState(() {
      print("thirteen");
      _isMenuVisibleNotifier.value = !_isMenuVisibleNotifier.value;
    });
  }
}
