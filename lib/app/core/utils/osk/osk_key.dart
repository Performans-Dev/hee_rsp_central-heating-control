import 'package:flutter/material.dart';

class OSKKeyWidget extends StatelessWidget {
  final String label;
  final GestureTapCallback? onTap;
  final bool isOther;

  const OSKKeyWidget(
      {super.key, required this.label, this.onTap, this.isOther = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isOther
                ? Colors.grey.withOpacity(0.7)
                : Colors.white24.withOpacity(0.3),
          ),
          width: 70,
          height: 62,
          child: Center(
              child: Text(
            label,
            style: const TextStyle(
                fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),
          )),
        ),
      ),
    );
  }
}
