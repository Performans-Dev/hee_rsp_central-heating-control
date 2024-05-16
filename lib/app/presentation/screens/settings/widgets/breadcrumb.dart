import 'package:flutter/material.dart';

class BreadcrumbWidget extends StatelessWidget {
  final String title;
  final double padding;
  final double width;
  final Color? color;
  const BreadcrumbWidget({
    super.key,
    required this.title,
    this.padding = 20,
    this.width = double.infinity,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: color,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(padding),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
