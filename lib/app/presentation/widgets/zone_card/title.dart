import 'package:flutter/material.dart';

class ZoneCardTitleWidget extends StatelessWidget {
  const ZoneCardTitleWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(title),
    );
  }
}
