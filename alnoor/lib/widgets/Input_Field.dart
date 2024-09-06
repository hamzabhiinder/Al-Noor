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

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenSize.height * 0.007, // Adjusting vertical spacing
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: screenSize.width * 0.045, // Adjusting font size
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: screenSize.width * 0.04, // Adjusting left padding for icon
              right: screenSize.width * 0.03,
            ),
            child: Image.asset(
              iconAssetPath,
              width: screenSize.width * 0.065, // Adjusting icon width
              height: screenSize.width * 0.065, // Adjusting icon height
            ),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.85), // Adjust opacity
          contentPadding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.02, // Add vertical padding inside field
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenSize.width * 0.03), // Slightly more rounded
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
        style: TextStyle(fontSize: screenSize.width * 0.045), // Adjust text style
      ),
    );
  }
}
