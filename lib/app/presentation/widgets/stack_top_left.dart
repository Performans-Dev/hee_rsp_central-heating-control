import 'package:flutter/material.dart';

class StackTopLeftWidget extends StatelessWidget {
  const StackTopLeftWidget(
      {super.key, required this.child, this.hasMargin = true});
  final Widget child;
  final bool hasMargin;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: hasMargin ? const EdgeInsets.all(16) : null,
        child: child,
      ),
    );
  }
}
