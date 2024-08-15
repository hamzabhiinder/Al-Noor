
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TwoImageScreen extends StatefulWidget {
  final String? initialImage1;
  final String? initialImage2;
  final VoidCallback? onClearImage1;
  final VoidCallback? onClearImage2;

  const TwoImageScreen({
    Key? key,
    this.initialImage1,
    this.initialImage2,
    this.onClearImage1,
    this.onClearImage2,
  }) : super(key: key);

  @override
  _TwoImageScreenState createState() => _TwoImageScreenState();
}

class _TwoImageScreenState extends State<TwoImageScreen> {
  String? image1;
  String? image2;

  @override
  void initState() {
    super.initState();
    image1 = widget.initialImage1;
    image2 = widget.initialImage2;
  }

  void _swapImages() {
    setState(() {
      final temp = image1;
      image1 = image2;
      image2 = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    image1 != null
                        ? Image.network(
                            image1!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Text('Failed to load image'));
                            },
                          )
                        : Container(
                            color: Colors.grey,
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(child: Text('No Product Selected')),
                          ),
                    if (image1 != null)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: widget.onClearImage1,
                          child: SvgPicture.asset(
                            'assets/images/Clear.svg',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    image2 != null
                        ? Image.network(
                            image2!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Text('Failed to load image'));
                            },
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                image: AssetImage('assets/images/image.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate,
                                      size: 50, color: Colors.black),
                                  SizedBox(height: 10),
                                  Text(
                                    'SELECT NEW DECORE',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    if (image2 != null)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: widget.onClearImage2,
                          child: SvgPicture.asset(
                            'assets/images/Clear.svg',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          if (image1 != null && image2 != null)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 25,
              left: MediaQuery.of(context).size.width / 2 - 25,
              child: GestureDetector(
                onTap: _swapImages,
                child: SvgPicture.asset(
                  'assets/images/change.svg',
                  width: 50,
                  height: 50,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
