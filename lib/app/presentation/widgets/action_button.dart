import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final GestureTapCallback? onTap;
  //TODO: icon ekle
  const ActionButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onTap, child: Text(text));
  }
}
