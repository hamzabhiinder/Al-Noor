import 'package:alnoor/blocs/category_bloc.dart';
import 'package:alnoor/blocs/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;
  late PageController _pageController;
  late List<String?> imagesInContainer1;
  late List<String?> imagesInContainer2;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
    context.read<CategoryBloc>().add(LoadCategories());
    context.read<ProductBloc>().add(LoadProducts());
    imagesInContainer1 = List<String?>.filled(2, null);
    imagesInContainer2 = List<String?>.filled(4, null);
  }

  void handleDrop(String imageUrl, int containerIndex, int imageIndex) {
    setState(() {
      if (containerIndex == 1) {
        imagesInContainer1[imageIndex] = imageUrl;
      } else if (containerIndex == 2) {
        imagesInContainer2[imageIndex] = imageUrl;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/Logo_Black.svg',
                  width: 45,
                  height: 45,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 30.0,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFEFEFEF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(fontSize: 12.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, color: Colors.grey, size: 15),
                          SizedBox(width: 8),
                          Text('Search Your Decor Here',
                              style: GoogleFonts.poppins(
                                fontSize: 8.0,
                                color: Color(0xFF9A9A9A),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {},
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
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is CategoryError) {
                        return Center(child: Text(state.message));
                      } else if (state is CategoryLoaded) {
                        return Column(
                          children: [
                            Container(
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: state.categories.map((category) {
                                  return SizedBox(
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
                                          backgroundColor: Color(0xFFEFEFEF),
                                          padding: EdgeInsets.only(bottom: 12),
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
                                                BorderRadius.circular(4.0),
                                            side: BorderSide(
                                              color: Color(0xFFEFEFEF),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<CategoryBloc, CategoryState>(
                                  builder: (context, state) {
                                    if (state is CategoryLoading) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (state is CategoryError) {
                                      return Center(child: Text(state.message));
                                    } else if (state is CategoryLoaded) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 600,
                                            child: BlocBuilder<ProductBloc,
                                                ProductState>(
                                              builder: (context, state) {
                                                if (state is ProductLoading) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (state
                                                    is ProductError) {
                                                  return Center(
                                                      child:
                                                          Text(state.message));
                                                } else if (state
                                                    is ProductLoaded) {
                                                  int totalPages =
                                                      (state.products.length /
                                                              8)
                                                          .ceil();
                                                  return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 50,
                                                              vertical: 0),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: PageView
                                                                .builder(
                                                              controller:
                                                                  _pageController,
                                                              onPageChanged:
                                                                  (page) {
                                                                setState(() {
                                                                  currentPage =
                                                                      page;
                                                                });
                                                              },
                                                              itemCount:
                                                                  totalPages,
                                                              itemBuilder:
                                                                  (context,
                                                                      pageIndex) {
                                                                int startIndex =
                                                                    pageIndex *
                                                                        8;
                                                                int endIndex = (startIndex +
                                                                            8 >
                                                                        state
                                                                            .products
                                                                            .length)
                                                                    ? state
                                                                        .products
                                                                        .length
                                                                    : startIndex +
                                                                        8;
                                                                var pageProducts = state
                                                                    .products
                                                                    .sublist(
                                                                        startIndex,
                                                                        endIndex);
                                                                return GridView
                                                                    .builder(
                                                                  gridDelegate:
                                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        2,
                                                                    crossAxisSpacing:
                                                                        10,
                                                                    mainAxisSpacing:
                                                                        10,
                                                                  ),
                                                                  itemCount:
                                                                      pageProducts
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    var product =
                                                                        pageProducts[
                                                                            index];
                                                                    return LongPressDraggable<
                                                                        String>(
                                                                      data: product
                                                                          .thumbnailImage,
                                                                      feedback:
                                                                          Opacity(
                                                                        opacity:
                                                                            0.7,
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(12.0),
                                                                          child:
                                                                              Image.network(
                                                                            product.thumbnailImage,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            width:
                                                                                100,
                                                                            height:
                                                                                100,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                            child:
                                                                                Image.network(
                                                                              product.thumbnailImage,
                                                                              fit: BoxFit.cover,
                                                                              width: double.infinity,
                                                                              height: double.infinity,
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            bottom:
                                                                                10,
                                                                            left:
                                                                                10,
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  product.productName,
                                                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 7),
                                                                                ),
                                                                                Text(
                                                                                  product.productType,
                                                                                  style: TextStyle(color: Colors.white, fontSize: 5),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            top:
                                                                                10,
                                                                            right:
                                                                                10,
                                                                            child:
                                                                                Icon(
                                                                              Icons.add_circle_outline,
                                                                              size: 10,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            bottom:
                                                                                10,
                                                                            right:
                                                                                10,
                                                                            child:
                                                                                CircleAvatar(
                                                                              radius: 5,
                                                                              backgroundColor: Colors.white,
                                                                              child: Icon(Icons.search_outlined, size: 9),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .chevron_left),
                                                                onPressed:
                                                                    currentPage >
                                                                            0
                                                                        ? () {
                                                                            _pageController.previousPage(
                                                                                duration: Duration(milliseconds: 300),
                                                                                curve: Curves.easeInOut);
                                                                          }
                                                                        : null,
                                                              ),
                                                              ...buildPageIndicators(
                                                                  totalPages),
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .chevron_right),
                                                                onPressed:
                                                                    currentPage <
                                                                            totalPages -
                                                                                1
                                                                        ? () {
                                                                            _pageController.nextPage(
                                                                                duration: Duration(milliseconds: 300),
                                                                                curve: Curves.easeInOut);
                                                                          }
                                                                        : null,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ));
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
                              ],
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Drag To View",
                        style: GoogleFonts.poppins(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.zero,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(width: 20),
                        DragTargetContainer1(),
                        SizedBox(width: 20),
                        FourImageDragTargetContainer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPageIndicators(int totalPages) {
    List<Widget> indicators = [];

    if (totalPages <= 4) {
      for (int i = 0; i < totalPages; i++) {
        indicators.add(buildIndicator(i));
      }
    } else {
      indicators.add(buildIndicator(0));

      if (currentPage == 0) {
        indicators.add(buildIndicator(1));
      }

      if (currentPage > 1) {
        indicators.add(buildEllipsis());
      }

      if (currentPage > 0 && currentPage < totalPages - 1) {
        indicators.add(buildIndicator(currentPage));
      }

      if (currentPage < totalPages - 2) {
        indicators.add(buildEllipsis());
      }

      if (currentPage > totalPages - 2) {
        indicators.add(buildIndicator(totalPages - 2));
      }
      indicators.add(buildIndicator(totalPages - 1));
    }

    return indicators;
  }

  Widget buildIndicator(int pageIndex) {
    return GestureDetector(
      onTap: () {
        _pageController.jumpToPage(pageIndex);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: currentPage == pageIndex ? Colors.black : Colors.white,
            width: 1.0,
          ),
        ),
        child: Text(
          (pageIndex + 1).toString(),
          style: TextStyle(
            fontSize: 8,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildEllipsis() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      padding: EdgeInsets.all(6.0),
      child: Text(
        '...',
        style: TextStyle(
          fontSize: 8,
          color: Colors.black,
        ),
      ),
    );
  }
}

class DragTargetContainer1 extends StatefulWidget {
  @override
  _DragTargetContainerState createState() => _DragTargetContainerState();
}

class _DragTargetContainerState extends State<DragTargetContainer1> {
  String? _image1;
  String? _image2;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAcceptWithDetails: (DragTargetDetails<String> details) {
        print(details.data);
        final String newImageUrl = details.data;
        setState(() {
          if (_image1 == null || _image1!.isEmpty || _image1 == "") {
            _image1 = newImageUrl;
          } else if (_image2 == null || _image2!.isEmpty || _image2 == "") {
            _image2 = newImageUrl;
          } else {
            _image1 = newImageUrl;
          }
        });
      },
      builder: (BuildContext context, List<String?> candidateData,
          List<dynamic> rejectedData) {
        return Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _image1 != null
                    ? Image.network(
                        _image1!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                      )
                    : Container(),
              ),
              Container(
                width: 1.0,
                color: Colors.black,
              ),
              Expanded(
                child: _image2 != null
                    ? Image.network(
                        _image2!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                      )
                    : Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FourImageDragTargetContainer extends StatefulWidget {
  @override
  _FourImageDragTargetContainerState createState() =>
      _FourImageDragTargetContainerState();
}

class _FourImageDragTargetContainerState
    extends State<FourImageDragTargetContainer> {
  String? _imageUrl1;
  String? _imageUrl2;
  String? _imageUrl3;
  String? _imageUrl4;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAcceptWithDetails: (DragTargetDetails<String> details) {
        print(details.data);
        final String newImageUrl = details.data;
        setState(() {
          if (_imageUrl1 == null || _imageUrl1!.isEmpty || _imageUrl1 == "") {
            _imageUrl1 = newImageUrl;
          } else if (_imageUrl2 == null ||
              _imageUrl2!.isEmpty ||
              _imageUrl2 == "") {
            _imageUrl2 = newImageUrl;
          } else if (_imageUrl3 == null ||
              _imageUrl3!.isEmpty ||
              _imageUrl3 == "") {
            _imageUrl3 = newImageUrl;
          } else if (_imageUrl4 == null ||
              _imageUrl4!.isEmpty ||
              _imageUrl4 == "") {
            _imageUrl4 = newImageUrl;
          } else {
            _imageUrl1 = newImageUrl;
          }
        });
      },
      builder: (BuildContext context, List<String?> candidateData,
          List<dynamic> rejectedData) {
        return Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _imageUrl1 != null
                          ? Image.network(
                              _imageUrl1!,
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                          : Container(),
                    ),
                    Container(
                      width: 1.0,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: _imageUrl2 != null
                          ? Image.network(
                              _imageUrl2!,
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1.0,
                color: Colors.black,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _imageUrl3 != null
                          ? Image.network(
                              _imageUrl3!,
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                          : Container(),
                    ),
                    Container(
                      width: 1.0,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: _imageUrl4 != null
                          ? Image.network(
                              _imageUrl4!,
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
