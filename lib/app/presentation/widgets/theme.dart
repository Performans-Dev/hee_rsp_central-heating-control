import 'package:central_heating_control/app/app.dart';
import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeWidget extends StatelessWidget {


  const ThemeWidget({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Pick a theme',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: StaticProvider.getThemeList.length,
                itemBuilder: (context, index) => RadioListTile(
                  value: index,
                  groupValue: app.preferencesDefinition.theme,
                  onChanged: (value) {
                    app.setPreferencesDefinition(
                        app.preferencesDefinition.copyWith(theme: index));
                    RestartWidget.restartApp(context);
                  },
                  title: Text(
                    StaticProvider.getThemeList[index]
                        .camelCaseToHumanReadable()
                        .tr,
                  ),
                ),
              ),
            ),
            const Divider(),
            Center(
              child: ToggleButtons(
                constraints: const BoxConstraints(minWidth: 80, minHeight: 48),
                isSelected: ThemeMode.values
                    .map((e) =>
                        e ==
                        ThemeMode.values[app.preferencesDefinition.themeMode])
                    .toList(),
                onPressed: (index) {
                  app.setPreferencesDefinition(
                      app.preferencesDefinition.copyWith(themeMode: index));
                  RestartWidget.restartApp(context);
                },
                borderRadius: UiDimens.formRadius,
                children: ThemeMode.values
                    .map((e) => Text(e.name.camelCaseToHumanReadable().tr))
                    .toList(),
              ),
            ),
         
          ],
        );
      },
    );
  }
}
