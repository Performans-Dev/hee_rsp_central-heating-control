import 'package:flutter/material.dart';

class BaseTheme {
  static ThemeData baseTheme(brightness) {
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
    );
  }
}
