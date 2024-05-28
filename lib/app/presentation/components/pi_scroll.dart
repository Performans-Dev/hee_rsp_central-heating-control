import 'package:central_heating_control/app/core/extensions/scroll.dart';
import 'package:flutter/material.dart';

class PiScrollView extends StatelessWidget {
  const PiScrollView({
    super.key,
    required this.child,
    this.padding,
  });
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: TouchScrollBehavior(),
      child: PiScrollView(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }
}
