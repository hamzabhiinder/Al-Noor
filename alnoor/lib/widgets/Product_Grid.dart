import 'dart:developer';

import 'package:alnoor/main.dart';
import 'package:alnoor/utils/reusable_cache_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:alnoor/blocs/favorites_bloc.dart';
import 'package:alnoor/screens/Home/favourites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alnoor/blocs/product_bloc.dart';
import 'package:alnoor/models/product.dart';
import 'package:alnoor/screens/Home/product_detail.dart';
import 'package:alnoor/widgets/Image_Skeleton.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vibration/vibration.dart';
import '../screens/Home/show_product.dart';
import 'package:alnoor/utils/globals.dart' as globals;

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final bool isFavourites;
  final bool isGuestUser;
  final void Function(bool)? setIsDragging;
  final void Function(int?)? setDraggingIndex;
  final bool? isUpload;

  ProductGrid({
    required this.products,
    required this.isFavourites,
    required this.isGuestUser,
    this.setIsDragging,
    this.setDraggingIndex,
    this.isUpload,
  });

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late ScrollController _scrollController;
  Map<String, ImageProvider> _imageCache = {};

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

  // Future<ImageProvider> loadImage(String url) async {
  //   try {
  //     final image = CachedNetworkImageProvider(url); // NetworkImage(url);
  //     await precacheImage(image, context);
  //     return image;
  //   } catch (e) {
  //     return AssetImage('assets/images/Logo.png');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final favouriteBloc = BlocProvider.of<FavouriteBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 2;
          final itemHeight = (constraints.maxHeight - 20) / (4);

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
              log(' widget.products.length  ${widget.products.length}');
              var product = widget.products[index];
              return LongPressDraggable<Product>(
                data: //"https://alnoormdf.com/" + product.productImage,
                    product,
                childWhenDragging:
                    (widget.isFavourites && !(widget.isUpload == true))
                        ? Container()
                        : null,
                onDragStarted: () async {
                  if (widget.isFavourites) {
                    widget.setDraggingIndex?.call(index);
                    widget.setIsDragging?.call(true);
                  }

                  if (await Vibration.hasVibrator() ?? false) {
                    Vibration.vibrate(
                        duration: 100); // Vibrate for 100 milliseconds
                  }
                },
                onDragEnd: (_) {
                  if (widget.isFavourites) {
                    widget.setDraggingIndex?.call(null);
                    widget.setIsDragging?.call(false);
                  }
                },
                feedback: Opacity(
                  opacity: 0.7,
                  child: Hero(
                    tag: 'product-thumbnail-${product.thumbnailImage}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: CachedNetworkImage(
                        cacheManager: getIt<CacheManager>(),
                        imageUrl: //"https://alnoormdf.com/" + product.productImage,
                            product.thumbnailImage,
                        placeholder: (context, url) => ImageSkeleton(
                          width: itemWidth,
                          height: itemHeight,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/Logo.png',
                          fit: BoxFit.cover,
                          width: itemWidth,
                          height: itemHeight,
                        ),
                        fit: BoxFit.cover,
                        width: itemWidth,
                        height: itemHeight,
                      ),

                      // FutureBuilder<ImageProvider>(
                      //   future: loadImage(product.thumbnailImage),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState == ConnectionState.done) {
                      //       if (snapshot.hasError) {
                      //         return Image.asset(
                      //           'assets/images/Logo.png',
                      //           fit: BoxFit.cover,
                      //           width: itemWidth,
                      //           height: itemHeight,
                      //         );
                      //       }
                      //       return Image(
                      //         image: snapshot.data!,
                      //         fit: BoxFit.cover,
                      //         width: itemWidth,
                      //         height: itemHeight,
                      //       );
                      //     } else {
                      //       return ImageSkeleton(
                      //         width: itemWidth,
                      //         height: itemHeight,
                      //       );
                      //     }
                      //   },
                      // ),
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        log('image ${product.thumbnailImage} ${"https://alnoormdf.com/" + product.productImage}');

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              product: product,
                              isFavourites: widget.isFavourites,
                            ),
                          ),
                        );

                        if (result != null &&
                            result['snackbarMessage'] != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(result['snackbarMessage'])),
                            );
                          });
                        }
                      },
                      child: Hero(
                        tag: 'product-thumbnail-${product.thumbnailImage}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: CachedNetworkImage(
                            imageUrl: //"https://alnoormdf.com/" + product.productImage,
                                product.thumbnailImage,
                            cacheManager: getIt<CacheManager>(),
                            placeholder: (context, url) => ImageSkeleton(
                              width: itemWidth,
                              height: itemHeight,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/Logo.png',
                              fit: BoxFit.cover,
                              width: itemWidth,
                              height: itemHeight,
                            ),
                            fit: BoxFit.cover,
                            width: itemWidth,
                            height: itemHeight,
                          ),
                          //  FutureBuilder<ImageProvider>(
                          //   future: loadImage(product.thumbnailImage),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState ==
                          //         ConnectionState.done) {
                          //       if (snapshot.hasError) {
                          //         return Image.asset(
                          //           'assets/images/Logo.png',
                          //           fit: BoxFit.cover,
                          //           width: itemWidth,
                          //           height: itemHeight,
                          //         );
                          //       }
                          //       return Image(
                          //         image: snapshot.data!,
                          //         fit: BoxFit.cover,
                          //         width: itemWidth,
                          //         height: itemHeight,
                          //       );
                          //     } else {
                          //       return ImageSkeleton(
                          //         width: itemWidth,
                          //         height: itemHeight,
                          //       );
                          //     }
                          //   },
                          // ),
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
                            (favouriteBloc.add(AddFavourites(
                                productId: product.productId,
                                collectionName: 'MY KITCHEN'))),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Favourites(
                                    index: 0,
                                  ),
                                ))
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
                            log('showProduct');
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
