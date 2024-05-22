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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isOther
                ? Colors.grey.withOpacity(0.7)
                : Colors.white24.withOpacity(0.3),
          ),
          width: 62,
          height: 57,
          padding: const EdgeInsets.all(8),
          child: Center(child: Text(label)),
        ),
      ),
    );
  }
}
