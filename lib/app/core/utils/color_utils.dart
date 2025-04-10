import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  static Color itemColorWithValue(BuildContext context, String value,
      {double alpha = 0.3}) {
    ItemColor c = ItemColor.values.firstWhereOrNull((e) => e.value == value) ??
        ItemColor.none;
    return itemColor(context, c, alpha: alpha);
  }
}

enum ItemColor {
  none(''),
  orange('#FF5733'), // Orange
  green('#33FF57'), // Green
  blue('#3357FF'), // Blue
  pink('#FF33A1'), // Pink
  yellow('#FFDB33'), // Yellow
  cyan('#33FFF5'), // Cyan
  purple('#B833FF'), // Purple
  lime('#A1FF33'); // Lime

  const ItemColor(this.value);
  final String value;
}
