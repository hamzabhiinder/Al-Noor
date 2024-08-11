import 'package:flutter/material.dart';

List<Widget> buildPageIndicators(
    int totalPages, int currentPage, PageController _pageController) {
  List<Widget> indicators = [];

  if (totalPages <= 4) {
    for (int i = 0; i < totalPages; i++) {
      indicators.add(buildIndicator(i, _pageController, currentPage));
    }
  } else {
    indicators.add(buildIndicator(0, _pageController, currentPage));

    if (currentPage == 0) {
      indicators.add(buildIndicator(1, _pageController, currentPage));
    }

    if (currentPage > 1) {
      indicators.add(buildEllipsis());
    }

    if (currentPage > 0 && currentPage < totalPages - 1) {
      indicators.add(buildIndicator(currentPage, _pageController, currentPage));
    }

    if (currentPage < totalPages - 2) {
      indicators.add(buildEllipsis());
    }

    if (currentPage > totalPages - 2) {
      indicators
          .add(buildIndicator(totalPages - 2, _pageController, currentPage));
    }
    indicators
        .add(buildIndicator(totalPages - 1, _pageController, currentPage));
  }

  return indicators;
}

Widget buildIndicator(
    int pageIndex, PageController _pageController, int currentPage) {
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
