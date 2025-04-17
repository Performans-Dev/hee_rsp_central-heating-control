import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';

class NetworkStatusIndicatorWidget extends StatelessWidget {
  const NetworkStatusIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.wifi),
      onPressed: () => Get.toNamed(Routes.preferencesNetworkConnections),
    );
  }
}
