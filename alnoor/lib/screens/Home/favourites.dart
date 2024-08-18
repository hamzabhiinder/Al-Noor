import 'package:alnoor/blocs/product_bloc.dart';
import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:alnoor/widgets/Add_To_Compare_Row.dart';
import 'package:alnoor/widgets/Image_Collection.dart';
import 'package:alnoor/widgets/Product_Grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Favourites(
        index: 0,
      ),
    );
  }
}

class Favourites extends StatefulWidget {
  final int index;

  Favourites({required this.index});

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  String _searchText = '';
  FocusNode _focusNode = FocusNode();
  int currentPage = 0;
  late PageController _pageController;
  int filterIndex = 0;

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
    context.read<ProductBloc>().add(LoadProducts(search: "", category: ""));
  }

  void _onSearchSubmit() {
    setState(() {
      filterIndex = -1;
    });
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
    return GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Scaffold(
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
                onPressed: () {},
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 30.0,
                      child: TextField(
                        focusNode: _focusNode,
                        onChanged: (text) {
                          setState(() {
                            _searchText = text;
                          });
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        style: TextStyle(fontSize: 12.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    if (!_focusNode.hasFocus && _searchText.isEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, color: Colors.grey, size: 15),
                          SizedBox(width: 8),
                          Text(
                            'Search Your Decor Here',
                            style: GoogleFonts.poppins(
                              fontSize: 8.0,
                              color: Color(0xFF9A9A9A),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 10.0),
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
                      SizedBox(
                        height: 142,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('MY KITCHEN tapped');
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
                                  isFavourites: true,
                                  setFilter: setFilterIndex,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('MY BEDROOM tapped');
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
                                    setFilter: setFilterIndex,
                                    selected: filterIndex == 1,
                                    isFavourites: true),
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
                                  print('MY LOUNGE tapped');
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
                                    setFilter: setFilterIndex,
                                    selected: filterIndex == 2,
                                    isFavourites: true),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            if (state is ProductLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is ProductError) {
                              return Center(child: Text(state.message));
                            } else if (state is ProductLoaded) {
                              int totalPages =
                                  (state.products.length / 4).ceil();
                              return ProductGrid(
                                updater: _updater,
                                isFavourites: true,
                                products: state.products,
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
          ),
          bottomNavigationBar: AddToCompareRow(
            showCamera: true,
          ),
        ));
  }
}
