import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VersionInfoWidget extends GetView<AppController> {
  const VersionInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.snackbar(
          'Version Info',
          'TODO: navigate to hardware info screen',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: Text(
        '${controller.platformInfo?.appVersion}+${controller.platformInfo?.appBuild}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w300),
      ),
    );
  }
}
