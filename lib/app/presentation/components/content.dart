import 'package:flutter/material.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
