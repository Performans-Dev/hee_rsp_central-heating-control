import 'package:flutter/material.dart';

class PinResetBodyWidget extends StatelessWidget {
  final Widget child;
  final Widget footer;
  const PinResetBodyWidget(
      {super.key, required this.child, required this.footer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                child: child,
              ),
            ),
            footer
          ],
        ),
      ),
    );
  }
}
