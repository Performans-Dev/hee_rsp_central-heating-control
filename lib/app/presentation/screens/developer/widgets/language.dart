import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/preferences/language.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/presentation/widgets/common/ht_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevLanguageSwitcherWidget extends StatelessWidget {
  const DevLanguageSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('Language'.tr),
              const Spacer(),
              HtDropdown<Language>(
                initialValue: app.preferences.language,
                options: StaticProvider.getLanguageList,
                onSelected: (language) {
                  LocalizationService().changeLocale(language.code);
                },
                labelBuilder: (language) => language.name,
              ),
            ],
          ),
        ),
      );
    });
  }
}
