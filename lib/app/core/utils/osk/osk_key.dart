import 'package:flutter/material.dart';

class OSKKeyWidget extends StatelessWidget {
  final String label;
  final GestureTapCallback? onTap;

  const OSKKeyWidget({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.pink,
        ),
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(8),
        child: Center(child: Text(label)),
      ),
    );
  }
}
