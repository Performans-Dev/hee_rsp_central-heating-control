import 'package:flutter/material.dart';

class StackBottomLeftWidget extends StatelessWidget {
  const StackBottomLeftWidget(
      {super.key, required this.child, this.hasMargin = true});
  final Widget child;
  final bool hasMargin;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: hasMargin ? const EdgeInsets.all(16) : null,
        child: child,
      ),
    );
  }
}
