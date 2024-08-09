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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(iconAssetPath),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
