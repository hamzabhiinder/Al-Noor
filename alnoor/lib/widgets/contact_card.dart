import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String heading;
  final String address;
  final String phone1;

  const ContactCard({
    Key? key,
    required this.heading,
    required this.address,
    required this.phone1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    // Dynamically adjust font size based on screen height
    double dynamicFontSize(double baseSize) {
      return screenHeight *
          (baseSize /
              850); // Adjust 850 to the base screen height you are designing for
    }

    final double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 8.0, // Set elevation for the shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: screenWidth / 2 - 32, // Takes half of the screen width
        height: screenWidth * 0.4,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8), // Customize background color
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Heading
            Text(
              heading,
              style: TextStyle(
                fontSize: dynamicFontSize(12), // Adjusted font size
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Address row with location icon
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.grey,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    address,
                    style: TextStyle(fontSize: dynamicFontSize(9)),
                    maxLines: null, // Allow the text to have unlimited lines
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Phone numbers column with phone icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.phone,
                  color: Colors.grey,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phone1,
                      style: TextStyle(fontSize: dynamicFontSize(9)),
                    ),
                  
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
