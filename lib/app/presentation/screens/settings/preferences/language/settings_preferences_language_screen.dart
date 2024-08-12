import 'dart:developer';

import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesLanguageScreen extends StatefulWidget {
  const SettingsPreferencesLanguageScreen({super.key});

  @override
  State<SettingsPreferencesLanguageScreen> createState() =>
      _SettingsPreferencesLanguageScreenState();
}

class _SettingsPreferencesLanguageScreenState
    extends State<SettingsPreferencesLanguageScreen> {
  String? _selectedLanguage;

  final AppController app = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (ac) {
      return AppScaffold(
        title: 'Language',
        selectedIndex: 3,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RadioListTile(
                      dense: true,
                      value: app.languages[index].name,
                      groupValue: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                      },
                      title: Text(app.languages[index].name),
                      subtitle: Text(app.languages[index].countryCode),
                    )),
                itemCount: app.languages.length,
              ),
            ),
            actionButton,
          ],
        ),
      );
    });
  }

  Widget get actionButton => Container(
        // color: Theme.of(context).focusColor,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancel")),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: _selectedLanguage != null
                    ? () async {
                        await app.onLanguageSelected(app.languages.indexWhere(
                            (element) => element.name == _selectedLanguage));
                        Get.back();

                        log("TODO: $_selectedLanguage seçildi. Kaydediliyor...");
                      }
                    : null,
                child: const Text("Confirm")),
          ],
        ),
      );

  Future<void> loadLocale() async {
    var locale = await LocalizationService().applySavedLocale();
    setState(() {
      _selectedLanguage = locale.languageCode;
    });
  }
}
