import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/restart.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/preferences/language.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final AppController appController = Get.find();
  final List<Language> languages = StaticProvider.getLanguageList;
  late Language selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = appController.preferences.language;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: 'Language'.tr,
        hasBackAction: true,
        selectedMenuIndex: 1,
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView.builder(
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: RadioListTile(
                value: languages[index],
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                },
                selected: selectedLanguage.code == languages[index].code,
                title: Text(languages[index].name),
                secondary: Text(
                    '${languages[index].code}-${languages[index].country}'),
                shape: RoundedRectangleBorder(borderRadius: UiDimens.br12),
                tileColor: Theme.of(context).colorScheme.surface,
                selectedTileColor:
                    Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            itemCount: languages.length,
          ),
        ),
        floatingActionButton: Opacity(
          opacity:
              selectedLanguage.code == appController.preferences.language.code
                  ? 0.4
                  : 1,
          child: FloatingActionButton.extended(
            onPressed:
                selectedLanguage.code == appController.preferences.language.code
                    ? null
                    : () {
                        appController.setPreferences(
                          appController.preferences.copyWith(
                            language: selectedLanguage,
                          ),
                        );
                        RestartWidget.restartApp(context);
                        Get.back();
                      },
            label: Text('Save'.tr),
            icon: const Icon(Icons.save),
            elevation:
                selectedLanguage.code == appController.preferences.language.code
                    ? 0
                    : null,
          ),
        ),
      );
    });
  }
}
