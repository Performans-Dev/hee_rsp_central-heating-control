import 'dart:math' as math;

import 'package:central_heating_control/app/app.dart';
import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesThemeScreen extends StatelessWidget {
  const SettingsPreferencesThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: 'Themes',
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text(
                      'Pick a theme',
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => RadioListTile(
                        value: index,
                        groupValue: app.themes.indexOf(app.selectedTheme),
                        onChanged: (value) {
                          app.setSelectedTheme(app.themes[index]);
                          RestartWidget.restartApp(context);
                        },
                        title: Text(
                          app.themes[index].camelCaseToHumanReadable(),
                        ),
                      ),
                      itemCount: app.themes.length,
                    ),
                  ),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                      top: 12,
                    ),
                    child: Center(
                      child: ToggleButtons(
                        constraints:
                            const BoxConstraints(minWidth: 80, minHeight: 48),
                        isSelected: ThemeMode.values
                            .map((e) => e == app.themeMode)
                            .toList(),
                        onPressed: (index) async {
                          await app.setThemeMode(ThemeMode.values[index]);
                        },
                        borderRadius: UiDimens.formRadius,
                        children: ThemeMode.values
                            .map((e) =>
                                Text(e.name.camelCaseToHumanReadable().tr))
                            .toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: UiDimens.formRadius,
                ),
                elevation: 12,
                child: ClipRRect(
                  borderRadius: UiDimens.formRadius,
                  child: SizedBox(
                    height: 160,
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Transform.rotate(
                            angle: -math.pi / 8.0,
                            child: Icon(
                              Icons.sensors,
                              color: app.isDarkMode
                                  ? Theme.of(context).highlightColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.8),
                              size: 240,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Sample')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
