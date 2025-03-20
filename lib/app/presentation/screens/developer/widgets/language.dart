import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevLanguageSwitcherWidget extends StatelessWidget {
  const DevLanguageSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('Language'),
              const Spacer(),
            ],
          ),
        ),
      );
    });
  }
}
