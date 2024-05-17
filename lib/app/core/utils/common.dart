import 'dart:ui';

class CommonUtils {
  static Color hexToColor(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
