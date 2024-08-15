import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FourImageScreen extends StatelessWidget {
  final String? image1;
  final String? image2;
  final String? image3;
  final String? image4;

  const FourImageScreen({
    Key? key,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height , // Adjusting aspect ratio to fill the screen
            padding: EdgeInsets.zero,
            children: [
              _buildImageContainer(image1),
              _buildImageContainer(image2),
              _buildImageContainer(image3),
              _buildImageContainer(image4),
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
        ],
      ),
    );
  }

  Widget _buildImageContainer(String? imageUrl) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text('Failed to load image'));
              },
            )
          : SvgPicture.asset(
              'assets/images/AddImage.svg',
              fit: BoxFit.cover,
            ),
    );
  }
}
