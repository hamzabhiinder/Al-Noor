// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:ui';
import 'package:alnoor/blocs/category_bloc.dart';
import 'package:alnoor/blocs/favorites_bloc.dart';
import 'package:alnoor/blocs/product_bloc.dart';
import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/screens/Home/favourites.dart';
import 'package:alnoor/widgets/Add_To_Compare_Row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/Product_Grid.dart';
import '../../widgets/menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  int filterIndex = -1;
  int currentPage = 0;
  late PageController _pageController;
  late List<String?> imagesInContainer1;
  late List<String?> imagesInContainer2;
  String _searchText = '';
  FocusNode _focusNode = FocusNode();
  bool isGuestUser = true; // Default to true; will be updated later
  late ValueNotifier<bool> _isMenuVisibleNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
    _loadUserStatus(); // Load the guest user status
    context.read<CategoryBloc>().add(LoadCategories());
    context.read<ProductBloc>().add(LoadProducts(search: "", category: ""));
    imagesInContainer1 = List<String?>.filled(2, null);
    imagesInContainer2 = List<String?>.filled(4, null);
    _focusNode.addListener(() {
      print("eighteen");
      setState(() {});
    });
    _isMenuVisibleNotifier = ValueNotifier<bool>(false);
  }

  Future<void> _loadUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print("nineteen");
      isGuestUser = prefs.getBool('isGuestUser') ?? true;
    });
  }

  @override
  void dispose() {
    _isMenuVisibleNotifier.dispose();
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // This line ensures the mixin is properly applied
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
            _isMenuVisibleNotifier.value =
                false; // Hide menu when tapping outside
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/images/Logo_Black.svg',
                  width: screenSize.width * 0.12,
                  height: screenSize.width * 0.12,
                ),
              ),
              actions: [
                if (!isGuestUser)
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/menu.svg',
                      width: screenSize.width * 0.07,
                      height: screenSize.width * 0.07,
                    ),
                    onPressed: () {
                      _isMenuVisibleNotifier.value =
                          !_isMenuVisibleNotifier.value;
                    },
                  ),
                if (isGuestUser)
                  TextButton(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    child: Text('Guest'),
                  ),
              ],
            ),
            body: Stack(
              children: [
                _buildMainContent(screenSize, context),
                ValueListenableBuilder<bool>(
                    valueListenable: _isMenuVisibleNotifier,
                    builder: (context, isVisible, child) {
                      return (isVisible && !isGuestUser)
                          ? Positioned(
                              top: screenSize.height *
                                  0.002, // Adjust the top position
                              right: 10, // Adjust the right position
                              child: HamburgerMenu(
                                isGuestUser: isGuestUser,
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
        ));
  }

  void _toggleMenu() {
    _isMenuVisibleNotifier.value = !_isMenuVisibleNotifier.value;
  }

  Widget _buildMainContent(Size screenSize, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: screenSize.height * 0.035,
                          child: TextField(
                            focusNode: _focusNode,
                            onChanged: (text) {
                              setState(() {
                                print("twentythree");
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
                                borderRadius: BorderRadius.circular(
                                    screenSize.width * 0.02),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.025),
                            ),
                            style: TextStyle(
                              fontSize: screenSize.width * 0.03,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        if (!_focusNode.hasFocus && _searchText.isEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search,
                                  color: Colors.grey,
                                  size: screenSize.width * 0.04),
                              SizedBox(width: screenSize.width * 0.02),
                              Text(
                                'Search Your Decor Here',
                                style: GoogleFonts.poppins(
                                  fontSize: screenSize.width * 0.025,
                                  color: Color(0xFF9A9A9A),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  if (!isGuestUser) (SizedBox(width: screenSize.width * 0.03)),
                  if (!isGuestUser)
                    IconButton(
                      icon: Icon(Icons.favorite, size: screenSize.width * 0.06),
                      onPressed: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Favourites(
                                index: 0,
                              ),
                            ));

                        if (result != null && result is List<String?>) {
                          setState(() {
                            print("twentyfour");
                            ImageManager().getImage(1);
                            ImageManager().getImage(2);
                            ImageManager().getImage(3);
                            ImageManager().getImage(4);
                            ImageManager().getImage(5);
                            ImageManager().getImage(6);
                          });
                        }
                      },
                    ),
                  if (!isGuestUser) (SizedBox(width: screenSize.width * 0.03)),
                  if (!isGuestUser)
                    GestureDetector(
                      onTap: () {
                        _showImagePicker(context);
                      },
                      child: SvgPicture.asset(
                        'assets/images/Upload.svg',
                        width: screenSize.width * 0.06,
                        height: screenSize.width * 0.06,
                      ),
                    ),
                ],
              ),
              if (isGuestUser) (SizedBox(height: screenSize.height * 0.01)),
              Expanded(
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is CategoryError) {
                      return Center(child: Text(state.message));
                    } else if (state is CategoryLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Wrap(
                              spacing: screenSize.width * 0.02,
                              runSpacing: screenSize.height * 0.01,
                              children:
                                  state.categories.asMap().entries.map((entry) {
                                int index = entry.key;
                                var category = entry.value;
                                return GestureDetector(
                                    onTap: () => {
                                          setState(() {
                                            print("twentyfive");
                                            filterIndex = index;
                                          }),
                                          context.read<ProductBloc>().add(
                                              LoadProducts(
                                                  search: "",
                                                  category: category.id))
                                        },
                                    child: SizedBox(
                                      height: screenSize.height * 0.03,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFEFEFEF),
                                          borderRadius: BorderRadius.circular(
                                              screenSize.width * 0.02),
                                        ),
                                        child: SizedBox(
                                          width: screenSize.width * 0.21,
                                          child: Chip(
                                            backgroundColor: Color(0xFFEFEFEF),
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    screenSize.height * 0.015),
                                            label: Center(
                                              child: Text(
                                                category.name,
                                                style: GoogleFonts.poppins(
                                                  fontSize:
                                                      screenSize.width * 0.023,
                                                  color: Color(0xFF9A9A9A),
                                                ),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenSize.width * 0.01),
                                              side: BorderSide(
                                                color: index == filterIndex
                                                    ? Color(0xFF937974)
                                                    : Color(0xFFEFEFEF),
                                                width: screenSize.width * 0.002,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                              height: screenSize.height *
                                  (isGuestUser ? 0.013 : 0.0125)),
                          Expanded(
                            child: BlocBuilder<ProductBloc, ProductState>(
                              builder: (context, state) {
                                if (state is ProductLoading) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (state is ProductError) {
                                  return Center(child: Text(state.message));
                                } else if (state is ProductLoaded) {
                                  int totalPages =
                                      (state.products.length / 8).ceil();
                                  return ProductGrid(
                                    isGuestUser: isGuestUser,
                                    isFavourites: false,
                                    products: state.products,
                                    totalPages: totalPages,
                                    itemsInAPage: 8,
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSearchSubmit() {
    setState(() {
      print("twentysix");
      filterIndex = -1;
    });
    context
        .read<ProductBloc>()
        .add(LoadProducts(search: _searchText, category: ""));
    _focusNode.unfocus();
  }

  Future<void> _showImagePicker(BuildContext context) async {
    final favouriteBloc = BlocProvider.of<FavouriteBloc>(context);
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
      File imageFile = File(image.path);
      (favouriteBloc
          .add(UploadImage(imageFile: imageFile, collectionName: "MY IDEAS")));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Favourites(index: 3)),
      );
    }
  }

  Widget _buildButton(BuildContext context, String text, Color backgroundColor,
      Color textColor, VoidCallback onPressed) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenSize.width * 0.025),
          ),
          padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: screenSize.width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
