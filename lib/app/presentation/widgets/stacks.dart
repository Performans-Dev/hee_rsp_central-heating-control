import 'package:flutter/material.dart';

class StackTopRightWidget extends StatelessWidget {
  const StackTopRightWidget(
      {super.key, required this.child, this.hasMargin = true});
  final Widget child;
  final bool hasMargin;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: hasMargin ? const EdgeInsets.all(16) : null,
        child: child,
      ),
    );
  }
}

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
