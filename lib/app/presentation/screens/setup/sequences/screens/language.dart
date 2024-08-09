import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequenceLanguageScreen extends StatefulWidget {
  const SetupSequenceLanguageScreen({super.key});

  @override
  State<SetupSequenceLanguageScreen> createState() =>
      _SetupSequenceLanguageScreenState();
}

class _SetupSequenceLanguageScreenState
    extends State<SetupSequenceLanguageScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(builder: (sc) {
      return GetBuilder<AppController>(builder: (app) {
        return SetupLayout(
          title: 'Language'.tr,
          subtitle: 'Choose your language'.tr,
          nextCallback: () async {
            Buzz.feedback();
            await app.onLanguageSelected(selectedIndex);
            sc.refreshSetupSequenceList();
            NavController.toHome();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < app.languages.length; i++)
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: Icon(
                    i == selectedIndex
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                  ),
                  title: Text(app.languages[i].name),
                  trailing: Text(
                      '${app.languages[i].languageCode}-${app.languages[i].countryCode}'),
                  selected: selectedIndex == i,
                  selectedTileColor: Theme.of(context).highlightColor,
                  onTap: () {
                    //Buzz.feedback();
                    setState(() {
                      selectedIndex = i;
                    });
                    LocalizationService()
                        .changeLocale(app.languages[i].languageCode);
                  },
                ),
            ],
          ),
        );
      });
    });
  }
}
