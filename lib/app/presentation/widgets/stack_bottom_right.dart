import 'package:flutter/material.dart';

class StackBottomRightWidget extends StatelessWidget {
  const StackBottomRightWidget(
      {super.key, required this.child, this.hasMargin = true});
  final Widget child;
  final bool hasMargin;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: hasMargin ? const EdgeInsets.all(16) : null,
        child: child,
      ),
    );
  }
}
