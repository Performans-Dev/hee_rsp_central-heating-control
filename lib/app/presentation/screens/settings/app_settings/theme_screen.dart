import 'dart:math' as math;
import 'package:central_heating_control/app/app.dart';
import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text(
                      'Pick a theme',
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => RadioListTile(
                        value: index,
                        groupValue: app.themeList.indexOf(app.selectedTheme),
                        onChanged: (value) {
                          app.setSelectedTheme(app.themeList[index]);
                          RestartWidget.restartApp(context);
                        },
                        title: Text(
                          app.themeList[index].camelCaseToHumanReadable(),
                        ),
                      ),
                      itemCount: app.themeList.length,
                    ),
                  ),
                  const Divider(),
                  CheckboxListTile(
                    title: Text(
                      'Dark Mode'.tr,
                    ),
                    value: app.isDarkMode,
                    onChanged: (v) {
                      Buzz.feedback();
                      app.toggleDarkMode();
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
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
