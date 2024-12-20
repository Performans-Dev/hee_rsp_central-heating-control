import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupStartScreen extends StatelessWidget {
  const SetupStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      builder: (sc) {
        return GetBuilder<AppController>(
          builder: (app) {
            return SetupLayout(
              title: 'Welcome to Central Controller'.tr,
              nextCallback: () async {
                Buzz.feedback();
                app.setPreferencesDefinition(app.preferencesDefinition.copyWith(
                  didWelcomeShown: true,
                ));
                sc.refreshSetupSequenceList();
                NavController.toHome();
              },
              isExpanded: true,
              child: Center(
                child: Text(
                    'Before starting, we need to know a few things. Please proceed to setup sequence.'
                        .tr),
              ),
            );
          },
        );
      },
    );
  }
}
