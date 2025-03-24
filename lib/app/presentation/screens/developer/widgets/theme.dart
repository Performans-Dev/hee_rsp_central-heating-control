import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/restart.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevThemeSwitcherWidget extends StatelessWidget {
  const DevThemeSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('Theme'.tr),
              const Spacer(),
              Text('DarkMode:'.tr),
              Switch(
                  value: app.preferences.isDark,
                  onChanged: (v) {
                    app.setPreferences(app.preferences.copyWith(
                      isDark: v,
                    ));
                    RestartWidget.restartApp(context);
                  }),
              const SizedBox(width: 20),
              ToggleButtons(
                borderRadius: UiDimens.br12,
                constraints: const BoxConstraints(minWidth: 70, minHeight: 40),
                isSelected: StaticProvider.getThemeList
                    .map((e) => app.preferences.appTheme == e)
                    .toList(),
                onPressed: (index) {
                  app.setPreferences(app.preferences.copyWith(
                    appTheme: StaticProvider.getThemeList[index],
                  ));
                  RestartWidget.restartApp(context);
                },
                children:
                    StaticProvider.getThemeList.map((e) => Text(e)).toList(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
