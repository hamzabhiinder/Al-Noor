import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final String iconAssetPath;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomInputField({
    Key? key,
    required this.hintText,
    required this.iconAssetPath,
    required this.controller,
    this.obscureText = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width * 0.6, // Matching the width of the buttons
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.01, // Adjusting vertical spacing
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: screenSize.width * 0.035, // Matching font size
              color: Colors.white, // Ensure text is visible on dark background
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: screenSize.width * 0.03, // Adjusted padding
                right: screenSize.width * 0.02,
              ),
              child: Image.asset(
                iconAssetPath,
                width: screenSize.width * 0.06, // Adjusted icon size
                height: screenSize.width * 0.06,
                color: Colors.white, // Ensure icon is visible on dark background
              ),
            ),
            filled: true,
            fillColor: Colors.transparent, // Transparent to match button style
            contentPadding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.02, // Matching button padding
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0), // Matching border radius
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: validator,
          style: TextStyle(
            fontSize: screenSize.width * 0.035,
            color: Colors.white, // Ensure input text is visible
          ),
        ),
      ),
    );
  }
}
