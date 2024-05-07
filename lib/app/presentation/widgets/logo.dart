import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.size = 200});
  final double size;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return SizedBox(
        width: size,
        child: Image.asset(
          'assets/images/heethings_logo_${app.isDarkMode ? 'dark' : 'light'}.png',
          fit: BoxFit.contain,
        ),
      );
    });
  }
}
