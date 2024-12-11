import "package:central_heating_control/app/core/theme/color_schemes/default.dart";
import "package:central_heating_control/app/data/services/app.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);
  ThemeData light() {
    final AppController app = Get.find();
    switch (app.preferencesDefinition.themeIndex) {
      case 2:
        return theme(ColorSchemes.warmyLightScheme());
      case 1:
        return theme(ColorSchemes.natureLightScheme());
      case 3:
        return theme(ColorSchemes.crimsonLightScheme());
      default:
        return theme(ColorSchemes.defaultLightScheme());
    }
  }

  ThemeData lightMediumContrast() {
    final AppController app = Get.find();
    switch (app.preferencesDefinition.themeIndex) {
      case 2:
        return theme(ColorSchemes.warmyLightMediumContrastScheme());
      case 1:
        return theme(ColorSchemes.natureLightMediumContrastScheme());
      case 3:
        return theme(ColorSchemes.crimsonLightMediumContrastScheme());
      default:
        return theme(ColorSchemes.defaultLightMediumContrastScheme());
    }
  }

  ThemeData lightHighContrast() {
    final AppController app = Get.find();
    switch (app.preferencesDefinition.themeIndex) {
      case 2:
        return theme(ColorSchemes.warmyLightHighContrastScheme());
      case 1:
        return theme(ColorSchemes.natureLightHighContrastScheme());
      case 3:
        return theme(ColorSchemes.crimsonLightHighContrastScheme());
      default:
        return theme(ColorSchemes.defaultLightHighContrastScheme());
    }
  }

  ThemeData dark() {
    final AppController app = Get.find();
    switch (app.preferencesDefinition.themeIndex) {
      case 2:
        return theme(ColorSchemes.warmyDarkScheme());
      case 1:
        return theme(ColorSchemes.natureDarkScheme());
      case 3:
        return theme(ColorSchemes.crimsonDarkScheme());
      default:
        return theme(ColorSchemes.defaultDarkScheme());
    }
  }

  ThemeData darkMediumContrast() {
    final AppController app = Get.find();
    switch (app.preferencesDefinition.themeIndex) {
      case 2:
        return theme(ColorSchemes.warmyDarkMediumContrastScheme());
      case 1:
        return theme(ColorSchemes.natureDarkMediumContrastScheme());
      case 3:
        return theme(ColorSchemes.crimsonDarkMediumContrastScheme());
      default:
        return theme(ColorSchemes.defaultDarkMediumContrastScheme());
    }
  }

  ThemeData darkHighContrast() {
    final AppController app = Get.find();
    switch (app.preferencesDefinition.themeIndex) {
      case 2:
        return theme(ColorSchemes.warmyDarkHighContrastScheme());
      case 1:
        return theme(ColorSchemes.natureDarkHighContrastScheme());
      case 3:
        return theme(ColorSchemes.crimsonDarkHighContrastScheme());
      default:
        return theme(ColorSchemes.defaultDarkHighContrastScheme());
    }
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
