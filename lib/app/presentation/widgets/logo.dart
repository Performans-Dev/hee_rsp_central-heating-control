import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.size = 200});
  final double size;

  @override
  Widget build(BuildContext context) {
    String asset =
        'assets/images/heethings_logo_${Get.isDarkMode ? 'dark' : 'light'}.png';
    return SizedBox(
      width: size,
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
      ),
    );
  }
}
