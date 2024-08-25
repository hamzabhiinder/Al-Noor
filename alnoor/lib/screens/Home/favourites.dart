// ignore_for_file: deprecated_member_use

import 'package:alnoor/blocs/favorites_bloc.dart';
import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/widgets/Add_To_Compare_Row.dart';
import 'package:alnoor/widgets/Image_Collection.dart';
import 'package:alnoor/widgets/Product_Grid.dart';
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
      home: Favourites(
        index: 0,
        isGuestUser: false, // Change this to true if testing as a guest user
      ),
    );
  }
}

class Favourites extends StatefulWidget {
  final int index;
  final bool isGuestUser; // Pass this flag to determine if the user is a guest

  Favourites({required this.index, this.isGuestUser = false});

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  String _searchText = '';
  FocusNode _focusNode = FocusNode();
  int currentPage = 0;
  late PageController _pageController;
  int filterIndex = 0;
  bool _isMenuVisible = false; // State to control the menu visibility

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    setState(() {
      filterIndex = widget.index;
    });
    _pageController = PageController(initialPage: currentPage);
    context.read<FavouriteBloc>().add(LoadFavourites(search: ""));
  }

  void _onSearchSubmit() {
    setState(() {
      filterIndex = 0;
    });
    context.read<FavouriteBloc>().add(LoadFavourites(search: _searchText));
    _focusNode.unfocus();
  }

  void _updater(result) {
    setState(() {
      ImageManager().setImage(1, result[0]);
      ImageManager().setImage(2, result[1]);
      ImageManager().setImage(3, result[2]);
      ImageManager().setImage(4, result[3]);
      ImageManager().setImage(5, result[4]);
      ImageManager().setImage(6, result[5]);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void setFilterIndex(int value) {
    setState(() {
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
          if (_isMenuVisible) {
            setState(() {
              _isMenuVisible = false; // Hide menu when tapping outside
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                'assets/images/Logo_Black.svg',
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
              ),
            ),
            actions: [
              if (!widget
                  .isGuestUser) // Show menu button only if the user is not a guest
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/menu.svg',
                    width: screenWidth * 0.08,
                    height: screenWidth * 0.08,
                  ),
                  onPressed: () {
                    setState(() {
                      _isMenuVisible =
                          !_isMenuVisible; // Toggle menu visibility
                    });
                  },
                ),
            ],
          ),
          body: Stack(
            children: [
              _buildMainContent(screenWidth, screenHeight, context),
              if (_isMenuVisible &&
                  !widget
                      .isGuestUser) // Show menu only if visible and not a guest
                Positioned(
                  top: screenHeight * 0.002, // Adjust the top position
                  right: 10, // Adjust the right position
                  child: HamburgerMenu(
                    isGuestUser: widget.isGuestUser,
                    isMenuVisible: _isMenuVisible,
                    onMenuToggle: _toggleMenu,
                  ),
                ),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: screenHeight * 0.035,
                child: TextField(
                  focusNode: _focusNode,
                  onChanged: (text) {
                    setState(() {
                      _searchText = text;
                    });
                    if (_searchText.isEmpty) {
                      _onSearchSubmit();
                    }
                  },
                  onSubmitted: (text) {
                    _onSearchSubmit();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFEFEFEF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  ),
                  style: TextStyle(fontSize: screenHeight * 0.015),
                  textAlign: TextAlign.left,
                ),
              ),
              if (!_focusNode.hasFocus && _searchText.isEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search,
                        color: Colors.grey, size: screenHeight * 0.02),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Search Your Decor Here',
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
              'Favourites',
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          ]),
          SizedBox(height: screenHeight * 0.012),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.17,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _focusNode.unfocus();
                          },
                          child: OverlappingImagesWidget(
                            imageUrls: [
                              'assets/images/Kitchen2.jpg',
                              'assets/images/Kitchen3.jpg',
                              'assets/images/Kitchen1.jpg'
                            ],
                            text: 'MY KITCHEN',
                            index: 0,
                            selected: filterIndex == 0,
                            productId: "-1",
                            isFavourites: true,
                            setFilter: setFilterIndex,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _focusNode.unfocus();
                          },
                          child: OverlappingImagesWidget(
                              imageUrls: [
                                'assets/images/Bedroom2.jpg',
                                'assets/images/Bedroom3.jpg',
                                'assets/images/Bedroom1.jpg'
                              ],
                              text: 'MY BEDROOM',
                              index: 1,
                              productId: "-1",
                              setFilter: setFilterIndex,
                              selected: filterIndex == 1,
                              isFavourites: true),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.17,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _focusNode.unfocus();
                          },
                          child: OverlappingImagesWidget(
                              imageUrls: [
                                'assets/images/Bedroom2.jpg',
                                'assets/images/Bedroom3.jpg',
                                'assets/images/Bedroom1.jpg'
                              ],
                              text: 'MY LOUNGE',
                              index: 2,
                              productId: "-1",
                              setFilter: setFilterIndex,
                              selected: filterIndex == 2,
                              isFavourites: true),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _focusNode.unfocus();
                          },
                          child: OverlappingImagesWidget(
                              imageUrls: [
                                'assets/images/Kitchen2.jpg',
                                'assets/images/Kitchen3.jpg',
                                'assets/images/Kitchen1.jpg'
                              ],
                              text: 'MY IDEAS',
                              index: 3,
                              productId: "-1",
                              setFilter: setFilterIndex,
                              selected: filterIndex == 3,
                              isFavourites: true),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Expanded(
                  child: BlocBuilder<FavouriteBloc, FavouriteState>(
                    builder: (context, state) {
                      if (state is FavouriteLoading ||
                          state is UploadImageLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is FavouriteError) {
                        return Center(child: Text(state.message));
                      } else if (state is FavouriteLoaded) {
                        int totalPages =
                            (state.favourites[filterIndex].length / 4).ceil();
                        if (state.favourites[filterIndex].length == 0) {
                          return Center(
                              child: Text("No Items In This Collection "));
                        }
                        return ProductGrid(
                          isGuestUser: widget.isGuestUser,
                          updater: _updater,
                          isFavourites: true,
                          products: filterIndex == 0
                              ? state.favourites[0]
                              : filterIndex == 1
                                  ? state.favourites[1]
                                  : filterIndex == 2
                                      ? state.favourites[2]
                                      : state.favourites[3],
                          totalPages: totalPages,
                          itemsInAPage: 4,
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
  }
}
