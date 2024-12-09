import 'package:central_heating_control/app/core/constants/assets.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
    this.size = 200,
    this.height = 100,
    this.themeMode = ThemeMode.system,
  });
  final double size;
  final double height;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return SizedBox(
        height: height,
        width: size,
        child: SvgPicture.asset(
          themeMode == ThemeMode.system
              ? app.preferencesDefinition.isDark
                  ? UiAssets.heethingsLogodark
                  : UiAssets.heethingsLogoLight
              : themeMode == ThemeMode.light
                  ? UiAssets.heethingsLogoLight
                  : UiAssets.heethingsLogodark,
          fit: BoxFit.contain,
        ),
      );
    });
  }
}
