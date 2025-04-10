import 'package:flutter/material.dart';

class FabWidget extends StatelessWidget {
  const FabWidget({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.heroTag,
    this.enabled = true,
    this.color,
    this.trailingIcon = false,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final String heroTag;
  final bool enabled;
  final ColorType? color;
  final bool trailingIcon;

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? foregroundColor;
    if (color != null) {
      switch (color!) {
        case ColorType.primary:
          backgroundColor = Theme.of(context).colorScheme.primary;
          foregroundColor = Theme.of(context).colorScheme.onPrimary;
          break;
        case ColorType.secondary:
          backgroundColor = Theme.of(context).colorScheme.secondary;
          foregroundColor = Theme.of(context).colorScheme.onSecondary;
          break;
        case ColorType.tertiary:
          backgroundColor = Theme.of(context).colorScheme.tertiary;
          foregroundColor = Theme.of(context).colorScheme.onTertiary;
          break;
        case ColorType.error:
          backgroundColor = Theme.of(context).colorScheme.error;
          foregroundColor = Theme.of(context).colorScheme.onError;
          break;
      }
    }
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: SizedBox(
        height: 42,
        child: FloatingActionButton.extended(
          onPressed: enabled ? onPressed : null,
          extendedPadding:
              trailingIcon ? const EdgeInsets.only(left: 20, right: 14) : null,
          label: trailingIcon
              ? Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label),
                    Icon(icon),
                  ],
                )
              : Text(label),
          icon: trailingIcon ? null : Icon(icon),
          heroTag: heroTag,
          elevation: enabled ? null : 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
      ),
    );
  }
}

enum ColorType { primary, secondary, tertiary, error }
