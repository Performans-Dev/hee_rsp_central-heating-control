import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:flutter/material.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class TextInputWidget extends StatelessWidget {
  final String labelText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final double radius;
  final bool obscureText;
  final String? obscuringCharacter;
  final int? maxLenght;
  final int? minLength;
  final OSKInputType? type;
  const TextInputWidget({
    super.key,
    required this.labelText,
    this.keyboardType,
    this.controller,
    this.radius = 16,
    this.obscureText = false,
    this.obscuringCharacter,
    this.maxLenght,
    this.minLength,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: UiDimens.formBorder,
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
            minLength: minLength,
            maxLength: maxLenght,
            type: type ?? OSKInputType.text,
            feedbackFunction: () {
              Buzz.feedback();
            },
          );
          controller?.text = result;
        },
      ),
    );
  }
}
