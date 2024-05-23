import 'package:flutter/material.dart';

class OSKKeyWidget extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final bool isOther;
  final double width;

  const OSKKeyWidget(
      {super.key,
      required this.child,
      this.onTap,
      this.isOther = false,
      this.width = 60});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 3.2, vertical: 5),
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
          width: width,
          height: 60,
          child: child,
        ),
      ),
    );
  }
}
