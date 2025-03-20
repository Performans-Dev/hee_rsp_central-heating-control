import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSuccessScreen extends StatelessWidget {
  const SetupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      builder: (sc) {
        return GetBuilder<AppController>(
          builder: (app) {
            return SetupLayout(
              title: 'Setup Completed'.tr,
              isExpanded: true,
              nextCallback: () {
                Buzz.feedback();
                app.setPreferencesDefinition(app.preferencesDefinition.copyWith(
                  didThankyouShown: true,
                ));
                sc.refreshSetupSequenceList();
                NavController.toHome();
              },
              child: Center(
                child: Text(
                    'Setup is now completed. You may start using the Central Controller.'
                        .tr),
              ),
            );
          },
        );
      },
    );
  }
}
