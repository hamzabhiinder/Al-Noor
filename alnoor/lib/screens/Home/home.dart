import 'package:alnoor/blocs/category_bloc.dart';
import 'package:alnoor/blocs/product_bloc.dart';
import 'package:alnoor/screens/Home/favourites.dart';
import 'package:alnoor/widgets/Add_To_Compare_Row.dart';
import 'package:alnoor/widgets/Product_Grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int filterIndex = -1;
  int currentPage = 0;
  late PageController _pageController;
  late List<String?> imagesInContainer1;
  late List<String?> imagesInContainer2;
  String _searchText = '';
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
    context.read<CategoryBloc>().add(LoadCategories());
    context.read<ProductBloc>().add(LoadProducts(search: "", category: ""));
    imagesInContainer1 = List<String?>.filled(2, null);
    imagesInContainer2 = List<String?>.filled(4, null);
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  void _onSearchSubmit() {
    setState(() {
      filterIndex = -1;
    });
    context
        .read<ProductBloc>()
        .add(LoadProducts(search: _searchText, category: ""));
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                style: TextStyle(fontSize: 12.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            if (!_focusNode.hasFocus && _searchText.isEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.search,
                                      color: Colors.grey, size: 15),
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
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Favourites()),
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/images/Upload.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
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
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: state.categories
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    var category = entry.value;
                                    return GestureDetector(
                                        onTap: () => {
                                              setState(() {
                                                filterIndex = index;
                                              }),
                                              context.read<ProductBloc>().add(
                                                  LoadProducts(
                                                      search: "",
                                                      category: category.id))
                                            },
                                        child: SizedBox(
                                          height: 25,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFEFEFEF),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: SizedBox(
                                              width: 80,
                                              child: Chip(
                                                backgroundColor:
                                                    Color(0xFFEFEFEF),
                                                padding:
                                                    EdgeInsets.only(bottom: 12),
                                                label: Center(
                                                  child: Text(
                                                    category.name,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 8.0,
                                                      color: Color(0xFF9A9A9A),
                                                    ),
                                                  ),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                  side: BorderSide(
                                                    color: index == filterIndex
                                                        ? Color(0xFF937974)
                                                        : Color(0xFFEFEFEF),
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                                  }).toList(),
                                ),
                              ),
                              SizedBox(height: 20),
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
        ),
        bottomNavigationBar: AddToCompareRow(
          showCamera: true,
        ),
      ),
    );
  }
}
