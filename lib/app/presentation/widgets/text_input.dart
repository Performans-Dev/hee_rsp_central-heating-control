import 'package:flutter/material.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          /*   border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
          ), */
          labelText: labelText,
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter ?? " ",
        onTap: () async {
          final result = await OnScreenKeyboard.show(
            context: context,
            initialValue: controller?.text,
            label: labelText,
          );
          controller?.text = result;
        },
      ),
    );
  }
}
