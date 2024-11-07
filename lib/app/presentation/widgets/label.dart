import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  const LabelWidget({
    super.key,
    required this.text,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Theme.of(context).colorScheme.onSurface,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
