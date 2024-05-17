import 'package:flutter/material.dart';

class CommonUtils {
  static Color hexToColor(BuildContext context, String hex) {
    return hex.isEmpty
        ? Theme.of(context).canvasColor
        : Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
