
import 'package:alnoor/screens/Home/favourites.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:alnoor/widgets/Image_Collection.dart';
import 'package:alnoor/widgets/menu.dart'; // Import the menu widget
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AddToFavourites extends StatefulWidget {
  final String productId;

  AddToFavourites({required this.productId});

  @override
  _AddToFavouritesState createState() => _AddToFavouritesState();
}

class _AddToFavouritesState extends State<AddToFavourites> {
  int filterIndex = 0;
  bool _isMenuVisible = false; // State to control the menu visibility

  @override
  void initState() {
    super.initState();
  }

  void setFilterIndex(int value) {
    setState(() {
      filterIndex = value;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Favourites(
                index: value,
              )),
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          child: SvgPicture.asset(
            'assets/images/Logo_Black.svg',
            width: 47,
            height: 47,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/menu.svg',
              width: 30,
              height: 30,
            ),
            onPressed: _toggleMenu,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Favourites',
                    style: GoogleFonts.poppins(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                ]),
                SizedBox(height: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Choose A Collection:",
                              style: GoogleFonts.poppins(
                                  fontSize: 14.0, fontWeight: FontWeight.w600),
                            )
                          ]),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 142,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: OverlappingImagesWidget(
                                    imageUrls: [
                                      'assets/images/Kitchen2.jpg',
                                      'assets/images/Kitchen3.jpg',
                                      'assets/images/Kitchen1.jpg'
                                    ],
                                    text: 'MY KITCHEN',
                                    index: 0,
                                    setFilter: setFilterIndex,
                                    selected: false,
                                    productId: widget.productId,
                                    isFavourites: false),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Favourites(
                                              index: 1,
                                            )),
                                  );
                                },
                                child: OverlappingImagesWidget(
                                    imageUrls: [
                                      'assets/images/Bedroom2.jpg',
                                      'assets/images/Bedroom3.jpg',
                                      'assets/images/Bedroom1.jpg'
                                    ],
                                    text: 'MY BEDROOM',
                                    selected: false,
                                    setFilter: setFilterIndex,
                                    index: 1,
                                    productId: widget.productId,
                                    isFavourites: false),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 142,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Favourites(
                                              index: 2,
                                            )),
                                  );
                                },
                                child: OverlappingImagesWidget(
                                    imageUrls: [
                                      'assets/images/Bedroom2.jpg',
                                      'assets/images/Bedroom3.jpg',
                                      'assets/images/Bedroom1.jpg'
                                    ],
                                    text: 'MY LOUNGE',
                                    index: 2,
                                    productId: widget.productId,
                                    setFilter: setFilterIndex,
                                    selected: false,
                                    isFavourites: false),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (_isMenuVisible) // Show menu when it's visible
            Positioned(
              top: screenHeight * 0.002,
              right: 10,
              child: HamburgerMenu(
                isGuestUser: false,
                isMenuVisible: _isMenuVisible,
                onMenuToggle: _toggleMenu,
              ),
            ),
        ],
      ),
    );
  }
}
