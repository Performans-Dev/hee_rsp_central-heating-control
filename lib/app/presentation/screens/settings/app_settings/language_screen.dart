import 'dart:developer';

import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? _selectedLanguage;

  AppController app = Get.find();

  @override
  void initState() {
    super.initState();
    // loadLocale();
    app.populateLanguages();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (ac) {
      return AppScaffold(
        title: 'Language',
        selectedIndex: 3,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Container(
            //   width: double.infinity,
            //   // color: Theme.of(context).focusColor,
            //   alignment: Alignment.centerLeft,
            //   padding: EdgeInsets.all(20),
            //   child: Text(
            //     'Settings / Preferences / Select Language',
            //     style: Theme.of(context).textTheme.titleSmall,
            //   ),
            // ),
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
                          /*       _selectedLanguage =
                            value! ? app.languages[index].name : null; */
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
