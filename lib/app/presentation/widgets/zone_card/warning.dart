import 'package:flutter/material.dart';

class ZoneCardWarningDisplayWidget extends StatelessWidget {
  const ZoneCardWarningDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Icon(Icons.warning),
    );
  }
}
