import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogWarningIndicatorWidget extends StatelessWidget {
  const LogWarningIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.warning),
      onPressed: () => Get.toNamed(Routes.logs),
    );
  }
}
