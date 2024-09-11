import 'package:alnoor/blocs/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:alnoor/utils/globals.dart' as globals;
import 'package:flutter_bloc/flutter_bloc.dart';

List<Widget> buildPageIndicators(int totalPages, int currentPage,
    PageController _pageController, BuildContext context, bool isFavorites) {
  List<Widget> indicators = [];

  if (totalPages <= 4) {
    for (int i = 0; i < totalPages; i++) {
      indicators.add(buildIndicator(
          i, _pageController, currentPage, context, isFavorites));
    }
  } else {
    indicators.add(
        buildIndicator(0, _pageController, currentPage, context, isFavorites));

    if (currentPage == 0) {
      indicators.add(buildIndicator(
          1, _pageController, currentPage, context, isFavorites));
    }

    if (currentPage > 1) {
      indicators.add(buildEllipsis(context));
    }

    if (currentPage > 0 && currentPage < totalPages - 1) {
      indicators.add(buildIndicator(
          currentPage, _pageController, currentPage, context, isFavorites));
    }

    if (currentPage < totalPages - 2) {
      indicators.add(buildEllipsis(context));
    }

    if (currentPage > totalPages - 2) {
      indicators.add(buildIndicator(
          totalPages - 2, _pageController, currentPage, context, isFavorites));
    }
    indicators.add(buildIndicator(
        totalPages - 1, _pageController, currentPage, context, isFavorites));
  }

  return indicators;
}

Widget buildIndicator(int pageIndex, PageController _pageController,
    int currentPage, BuildContext context, bool isFavourites) {
  final screenSize = MediaQuery.of(context).size;

  return GestureDetector(
    onTap: () {
      if (!isFavourites) {
        if (globals.categories.length != 0 && globals.done != true) {
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
      _pageController.jumpToPage(pageIndex);
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
      padding: EdgeInsets.all(screenSize.width * 0.015),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: currentPage == pageIndex ? Colors.black : Colors.white,
          width: screenSize.width * 0.002,
        ),
      ),
      child: Text(
        (pageIndex + 1).toString(),
        style: TextStyle(
          fontSize: screenSize.width * 0.02,
          color: Colors.black,
        ),
      ),
    ),
  );
}

Widget buildEllipsis(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
    padding: EdgeInsets.all(screenSize.width * 0.015),
    child: Text(
      '...',
      style: TextStyle(
        fontSize: screenSize.width * 0.02,
        color: Colors.black,
      ),
    ),
  );
}
