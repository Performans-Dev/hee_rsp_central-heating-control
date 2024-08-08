import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/__temp/_setup/setup_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequenceTermsOfUseSection extends StatefulWidget {
  const SetupSequenceTermsOfUseSection({super.key});

  @override
  State<SetupSequenceTermsOfUseSection> createState() =>
      _SetupSequenceTermsOfUseSectionState();
}

class _SetupSequenceTermsOfUseSectionState
    extends State<SetupSequenceTermsOfUseSection> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      builder: (sc) {
        return GetBuilder<AppController>(
          builder: (app) {
            return SetupScaffold(
              progressValue: sc.progress,
              label: 'Terms of Use'.tr,
              nextCallback: isChecked
                  ? () async {
                      await Box.setBool(
                          key: Keys.didTermsAccepted, value: true);
                      sc.refreshSetupSequenceList();
                      NavController.toHome();
                    }
                  : null,
              expandChild: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('Terms of Use'.tr),
                  Expanded(
                    child: Center(child: Text('Terms Content'.tr)),
                  ),
                  CheckboxListTile(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('I agree to the terms of use'.tr),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
