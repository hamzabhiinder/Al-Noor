import 'package:alnoor/blocs/favorites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class OverlappingImagesWidget extends StatefulWidget {
  final List<String> imageUrls;
  final String text;
  final bool selected;
  final bool isFavourites;
  final String productId;
  final int index;
  final void Function(int) setFilter;

  const OverlappingImagesWidget(
      {Key? key,
      required this.imageUrls,
      required this.text,
      required this.selected,
      required this.isFavourites,
      required this.index,
      required this.setFilter,
      required this.productId})
      : super(key: key);

  @override
  _OverlappingImagesWidgetState createState() =>
      _OverlappingImagesWidgetState();
}

class _OverlappingImagesWidgetState extends State<OverlappingImagesWidget> {
  @override
  Widget build(BuildContext context) {
    final favouriteBloc = BlocProvider.of<FavouriteBloc>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double responsiveWidth(double size) {
      return size * (screenWidth / 375);
    }

    double responsiveHeight(double size) {
      return size * (screenHeight / 812);
    }

    double responsiveFontSize(double size) {
      return size * (screenWidth / 375);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => {
            widget.setFilter(widget.index),
            if (!widget.isFavourites)
              (favouriteBloc.add(AddFavourites(
                  productId: widget.productId,
                  collectionName: widget.index == 0
                      ? 'MY KITCHEN'
                      : widget.index == 1
                          ? "MY BEDROOM"
                          : "MY LOUNGE")))
          },
          child: SizedBox(
            width: responsiveWidth(155),
            height: responsiveHeight(125),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ...List.generate(widget.imageUrls.length, (index) {
                  double leftPosition;
                  if (index == 0) {
                    leftPosition = 0;
                  } else if (index == 1) {
                    leftPosition = responsiveWidth(40);
                  } else {
                    leftPosition = responsiveWidth(15);
                  }
                  return Positioned(
                    left: leftPosition,
                    child: Container(
                      width: responsiveWidth(105 + (index == 2 ? 10 : 0)),
                      height: responsiveHeight(100 + (index == 2 ? 10 : 0)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            responsiveWidth(10)), // Responsive border radius
                        image: DecorationImage(
                          image: AssetImage(widget.imageUrls[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
                if (widget.isFavourites == true)
                  Positioned(
                    right: responsiveWidth(35),
                    bottom: responsiveHeight(20),
                    child: CircleAvatar(
                      radius: responsiveWidth(7),
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.search_outlined,
                        size: responsiveFontSize(13),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Text(
            widget.text,
            style: GoogleFonts.poppins(
              fontSize: responsiveFontSize(6.0),
              fontWeight: FontWeight.bold,
              color: widget.selected ? Colors.red : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
