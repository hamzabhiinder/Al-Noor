import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alnoor/blocs/product_bloc.dart';
import 'package:alnoor/models/product.dart';
import 'package:alnoor/screens/Home/add_to_favourites.dart';
import 'package:alnoor/screens/Home/product_detail.dart';
import 'package:alnoor/widgets/Image_Skeleton.dart';
import '../screens/Home/show_product.dart';
import 'package:alnoor/utils/globals.dart' as globals;

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final bool isFavourites;
  final bool isGuestUser;

  ProductGrid({
    required this.products,
    required this.isFavourites,
    required this.isGuestUser,
  });

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
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
    }
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
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 2;
          final itemHeight = widget.isFavourites
              ? (constraints.maxHeight - 10) / 2
              : (constraints.maxHeight - 20) / (4);

          return GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: itemWidth / itemHeight,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              var product = widget.products[index];
              return LongPressDraggable<String>(
                data: product.thumbnailImage,
                feedback: Opacity(
                  opacity: 0.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FutureBuilder<ImageProvider>(
                      future: loadImage(product.thumbnailImage),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Image.asset(
                              'assets/images/Logo.png',
                              fit: BoxFit.cover,
                              width: itemWidth,
                              height: itemHeight,
                            );
                          }
                          return Image(
                            image: snapshot.data!,
                            fit: BoxFit.cover,
                            width: itemWidth,
                            height: itemHeight,
                          );
                        } else {
                          return ImageSkeleton(
                            width: itemWidth,
                            height: itemHeight,
                          );
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
                              isFavourites: widget.isFavourites,
                            ),
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
                                  width: itemWidth,
                                  height: itemHeight,
                                );
                              }
                              return Image(
                                image: snapshot.data!,
                                fit: BoxFit.cover,
                                width: itemWidth,
                                height: itemHeight,
                              );
                            } else {
                              return ImageSkeleton(
                                width: itemWidth,
                                height: itemHeight,
                              );
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
                            width: itemWidth * 0.6,
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
                            width: itemWidth * 0.6,
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
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddToFavourites(
                                  productId: product.productId,
                                ),
                              ),
                            )
                          },
                          child: Icon(
                            Icons.add_circle_outline,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
                                builder: (context) => ShowProductScreen(
                                  product: product,
                                ),
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
    );
  }
}
