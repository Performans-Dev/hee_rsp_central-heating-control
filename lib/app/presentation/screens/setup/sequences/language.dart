import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/__temp/_setup/setup_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequenceLanguageSection extends StatefulWidget {
  const SetupSequenceLanguageSection({super.key});

  @override
  State<SetupSequenceLanguageSection> createState() =>
      _SetupSequenceLanguageSectionState();
}

class _SetupSequenceLanguageSectionState
    extends State<SetupSequenceLanguageSection> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(builder: (sc) {
      return GetBuilder<AppController>(builder: (app) {
        return SetupScaffold(
          progressValue: sc.progress,
          label: 'Language'.tr,
          nextCallback: () async {
            Buzz.feedback();
            await app.onLanguageSelected(selectedIndex);
            sc.refreshSetupSequenceList();
            NavController.toHome();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose your language'.tr),
              Divider(),
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
