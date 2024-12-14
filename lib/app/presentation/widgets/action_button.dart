import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final GestureTapCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  const ActionButton({
    super.key,
    required this.label,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
        top: 4,
      ),
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 50,
        child: OutlinedButton(
          onPressed: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              prefixIcon ?? Container(),
              Text(label),
              suffixIcon ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
