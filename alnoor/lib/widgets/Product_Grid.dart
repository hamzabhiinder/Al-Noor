import 'package:alnoor/blocs/product_bloc.dart';
import 'package:alnoor/models/product.dart';
import 'package:alnoor/screens/Home/add_to_favourites.dart';
import 'package:alnoor/screens/Home/product_detail.dart';
import 'package:alnoor/widgets/Image_Skeleton.dart';
import 'package:alnoor/widgets/Paginator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/Home/show_product.dart';
import 'package:alnoor/utils/globals.dart' as globals;

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final int totalPages;
  final int itemsInAPage;
  final bool isFavourites;
  final bool isGuestUser;

  ProductGrid(
      {required this.products,
      required this.totalPages,
      required this.itemsInAPage,
      required this.isFavourites,
      required this.isGuestUser});

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<ImageProvider> loadImage(String url) async {
    try {
      final image = NetworkImage(url);
      await precacheImage(image, context);
      return image;
    } catch (e) {
      return AssetImage('assets/images/Logo.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate the available height for grid items and dynamic sizing
    final horizontalPadding = screenWidth * 0.14;
    final spacing = screenHeight * 0.013;
    final availableHeight = screenHeight - (spacing * 7); // 4 rows + spacing
    final availableWidth = screenWidth - (horizontalPadding * 2) - (spacing);

    // Determine item size for a 2x4 grid
    final desiredItemHeight = availableHeight / 4;
    final desiredItemWidth = availableWidth / 2;
    final itemSize = desiredItemHeight < desiredItemWidth
        ? desiredItemHeight
        : desiredItemWidth;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 0),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                if (!widget.isFavourites) {
                  if (globals.categories.isNotEmpty && !globals.done) {
                    List<dynamic> subCategoryIds = globals.selectedSubcategories
                        .map((item) => item.sub_category_id)
                        .toList();
                    context.read<ProductBloc>().add(
                          LoadPages(
                            search: "",
                            categories: globals.categories,
                            subcategories: subCategoryIds,
                          ),
                        );

                    globals.page = globals.page + 1;
                  }
                }
                setState(() {
                  currentPage = page;
                });
              },
              itemCount: widget.totalPages,
              itemBuilder: (context, pageIndex) {
                int startIndex = pageIndex * widget.itemsInAPage;
                int endIndex =
                    (startIndex + widget.itemsInAPage > widget.products.length)
                        ? widget.products.length
                        : startIndex + widget.itemsInAPage;
                var pageProducts =
                    widget.products.sublist(startIndex, endIndex);

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two items per row
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: 1, // 1:1 ratio for square items
                  ),
                  itemCount: pageProducts.length,
                  itemBuilder: (context, index) {
                    var product = pageProducts[index];
                    return LongPressDraggable<String>(
                      data: product.thumbnailImage,
                      feedback: Opacity(
                        opacity: 0.7,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: FutureBuilder<ImageProvider>(
                            future: loadImage(product.thumbnailImage),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Image.asset(
                                    'assets/images/Logo.png',
                                    fit: BoxFit.cover,
                                    width: itemSize,
                                    height: itemSize,
                                  );
                                }
                                return Image(
                                  image: snapshot.data!,
                                  fit: BoxFit.cover,
                                  width: itemSize,
                                  height: itemSize,
                                );
                              } else {
                                return ImageSkeleton(
                                    width: itemSize, height: itemSize);
                              }
                            },
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                      product: product,
                                      isFavourites: widget.isFavourites),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: FutureBuilder<ImageProvider>(
                                future: loadImage(product.thumbnailImage),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return Image.asset(
                                        'assets/images/Logo.png',
                                        fit: BoxFit.cover,
                                        width: itemSize,
                                        height: itemSize,
                                      );
                                    }
                                    return Image(
                                      image: snapshot.data!,
                                      fit: BoxFit.cover,
                                      width: itemSize,
                                      height: itemSize,
                                    );
                                  } else {
                                    return ImageSkeleton(
                                        width: itemSize, height: itemSize);
                                  }
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: itemSize * 0.6,
                                  child: Text(
                                    product.productName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 7,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                Container(
                                  width: itemSize * 0.6,
                                  child: Text(
                                    product.productType,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 5,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if ((!widget.isFavourites) && (!widget.isGuestUser))
                            (Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                  onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddToFavourites(
                                                      productId:
                                                          product.productId)),
                                        )
                                      },
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    size: 20,
                                    color: Colors.white,
                                  )),
                            )),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: Icon(
                                  Icons.search_outlined,
                                  size: 15,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ShowProductScreen(product: product),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: currentPage > 0
                    ? () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
              ...buildPageIndicators(widget.totalPages, currentPage,
                  _pageController, context, widget.isFavourites),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  if (!widget.isFavourites) {
                    if (globals.categories.isNotEmpty && !globals.done) {
                      List<dynamic> subCategoryIds = globals
                          .selectedSubcategories
                          .map((item) => item.sub_category_id)
                          .toList();
                      context.read<ProductBloc>().add(
                            LoadPages(
                              search: "",
                              categories: globals.categories,
                              subcategories: subCategoryIds,
                            ),
                          );

                      globals.page = globals.page + 1;
                    }
                  }
                  currentPage < widget.totalPages - 1
                      ? _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        )
                      : null;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
