import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String labelText;
  final GestureTapCallback? onPressed;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  const ActionButton({
    super.key,
    required this.labelText,
    this.onPressed,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 50,
        child: OutlinedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              prefixIcon ?? Container(),
              Text(labelText),
              suffixIcon ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
