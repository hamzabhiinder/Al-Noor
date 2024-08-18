import 'package:alnoor/models/product.dart';
import 'package:alnoor/screens/Home/add_to_favourites.dart';
import 'package:alnoor/screens/Home/product_detail.dart';
import 'package:alnoor/widgets/Image_Skeleton.dart';
import 'package:alnoor/widgets/Paginator.dart';
import 'package:flutter/material.dart';
import '../screens/Home/show_product.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final int totalPages;
  final int itemsInAPage;
  final bool isFavourites;
  final Function(dynamic) updater;

  ProductGrid(
      {required this.products,
      required this.totalPages,
      required this.itemsInAPage,
      required this.isFavourites,
      required this.updater});

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
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
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
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
                                    width: 100,
                                    height: 100,
                                  );
                                }
                                return Image(
                                  image: snapshot.data!,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                );
                              } else {
                                return ImageSkeleton(width: 100, height: 100);
                              }
                            },
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                      product: product,
                                      isFavourites: widget.isFavourites),
                                ),
                              );

                              if (result != null && result is List<String?>) {
                                print("hiii");
                                widget.updater(result);
                              }
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
                                        width: double.infinity,
                                        height: double.infinity,
                                      );
                                    }
                                    return Image(
                                      image: snapshot.data!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    );
                                  } else {
                                    return ImageSkeleton(
                                        width: double.infinity,
                                        height: double.infinity);
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
                                  width: 80,
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
                                  width: 80,
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
                          if (!widget.isFavourites)
                            (Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                  onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddToFavourites()),
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
              ...buildPageIndicators(
                  widget.totalPages, currentPage, _pageController, context),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: currentPage < widget.totalPages - 1
                    ? () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
