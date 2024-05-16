import 'package:central_heating_control/app/core/constants/assets.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.size = 200, this.height = 100});
  final double size;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return SizedBox(
        height: height,
        width: size,
        child: SvgPicture.asset(
          app.isDarkMode
              ? UiAssets.heethingsLogodark
              : UiAssets.heethingsLogoLight,
          fit: BoxFit.contain,
        ),
      );
    });
  }
}
