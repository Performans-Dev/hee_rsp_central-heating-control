import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/data/models/language_definition.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatefulWidget {
  LanguageScreen({super.key});

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
      return Scaffold(
        appBar: AppBar(
          title: Text("Language"),
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CheckboxListTile(
                        dense: true,
                        value: _selectedLanguage == app.languages[index].name,
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedLanguage =
                                value! ? app.languages[index].name : null;
                          });
                        },
                        title: Text(app.languages[index].name),
                        subtitle: Text(app.languages[index].countryCode),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    itemCount: app.languages.length,
                  ),
                ),
              ],
            ),
            actionButton,
          ],
        ),
      );
    });
  }

  Widget get actionButton => Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Cancel")),
            SizedBox(width: 10),
            ElevatedButton(
                onPressed: _selectedLanguage != null
                    ? () async {
                        await app.onLanguageSelected(app.languages.indexWhere(
                            (element) => element.name == _selectedLanguage));
                        Get.back();

                        print("$_selectedLanguage seçildi. Kaydediliyor...");
                      }
                    : null,
                child: Text("Confirm")),
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
