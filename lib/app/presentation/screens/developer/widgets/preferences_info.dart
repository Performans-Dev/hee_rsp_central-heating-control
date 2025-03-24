import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevPreferencesInfoWidget extends StatelessWidget {
  const DevPreferencesInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Preferences Info'.tr),
              const Divider(),
              Text(app.preferences.toJson())
            ],
          ),
        ),
      );
    });
  }
}
