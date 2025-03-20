import 'package:flutter/material.dart';

class ColorUtils {
  static Color itemColor(
    BuildContext context,
    ItemColor color, {
    double alpha = 0.3,
  }) {
    return (color == ItemColor.none
            ? Theme.of(context).canvasColor
            : Color(
                int.parse(color.value.substring(1, 7), radix: 16) + 0xFF000000))
        .withValues(alpha: alpha);
  }
}

enum ItemColor {
  none(''),
  orange('#FF5733'),
  green('#33FF57'),
  blue('#3357FF'),
  pink('#FF33A1'),
  yellow('#FFDB33'),
  cyan('#33FFF5'),
  purple('#B833FF'),
  lime('#A1FF33');

  const ItemColor(this.value);
  final String value;
}
