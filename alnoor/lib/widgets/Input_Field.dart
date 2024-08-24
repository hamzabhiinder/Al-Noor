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
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: screenSize.width * 0.045),
          prefixIcon: Padding(
            padding: EdgeInsets.all(screenSize.width * 0.03),
            child: Image.asset(
              iconAssetPath,
              width: screenSize.width * 0.06,
              height: screenSize.width * 0.06,
            ),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenSize.width * 0.025),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
        style: TextStyle(fontSize: screenSize.width * 0.045),
      ),
    );
  }
}
