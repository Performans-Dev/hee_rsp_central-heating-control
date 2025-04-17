import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VersionInfoWidget extends StatelessWidget {
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
      child: const Text(
        '1.3.22-alpha.18', //TODO: acquire this from controller
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w300),
      ),
    );
  }
}
