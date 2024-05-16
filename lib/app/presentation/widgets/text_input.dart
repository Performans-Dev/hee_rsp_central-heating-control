import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final String labelText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final double radius;
  final bool obscureText;
  final String? obscuringCharacter;
  const TextInputWidget(
      {super.key,
      required this.labelText,
      this.keyboardType,
      this.controller,
      this.radius = 16,
      this.obscureText = false,
      this.obscuringCharacter});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        labelText: labelText,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter ?? " ",
    );
  }
}
