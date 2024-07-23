import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupLanguageScreen extends StatefulWidget {
  const SetupLanguageScreen({super.key});

  @override
  State<SetupLanguageScreen> createState() => _SetupLanguageScreenState();
}

class _SetupLanguageScreenState extends State<SetupLanguageScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return SetupScaffold(
        progressValue: 1 / 9,
        label: 'Language'.tr,
        // nextLabel: 'Next',
        nextCallback: () async {
          await app.onLanguageSelected(selectedIndex);

          NavController.toHome();
        },
        previousCallback: () {
          Get.toNamed(Routes.setupConnection);
        },
        // previousLabel: 'Back',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              'Choose your language'.tr,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
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
  }
}
