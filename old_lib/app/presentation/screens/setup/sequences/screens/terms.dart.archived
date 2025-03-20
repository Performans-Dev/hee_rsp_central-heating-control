import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

class SetupSequenceTermsOfUseScreen extends StatefulWidget {
  const SetupSequenceTermsOfUseScreen({super.key});

  @override
  State<SetupSequenceTermsOfUseScreen> createState() =>
      _SetupSequenceTermsOfUseScreenState();
}

class _SetupSequenceTermsOfUseScreenState
    extends State<SetupSequenceTermsOfUseScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      builder: (sc) {
        return GetBuilder<AppController>(
          builder: (app) {
            String languageCode =
                Box.getString(key: Keys.localeLang, defaultVal: 'en');
            final data = StaticProvider.termsOfUse[languageCode] ?? '';
            return SetupLayout(
              title: 'Terms of Use'.tr,
              nextCallback: isChecked
                  ? () async {
                      app.setHeethingsAccount(app.heethingsAccount?.copyWith(
                        termsConsentStatus: true,
                      ));
                      sc.refreshSetupSequenceList();
                      NavController.toHome();
                    }
                  : null,
              isExpanded: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Markdown(data: data),
                  ),
                  CheckboxListTile(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: UiDimens.formRadius,
                    ),
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
