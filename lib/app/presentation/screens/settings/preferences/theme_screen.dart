import 'dart:math' as math;

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/restart.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  final AppController appController = Get.find();
  late String selectedTheme;

  @override
  void initState() {
    super.initState();
    selectedTheme = appController.preferences.appTheme;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: 'Theme'.tr,
        hasBackAction: true,
        selectedMenuIndex: 1,
        body: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Themes'.tr),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: [
                        ...StaticProvider.getThemeList.map(
                          (t) => Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: RadioListTile(
                              value: t,
                              groupValue: selectedTheme,
                              onChanged: (v) {
                                setState(() {
                                  selectedTheme = v!;
                                });
                                app.setPreferences(
                                    app.preferences.copyWith(appTheme: v));

                                RestartWidget.restartApp(context);
                              },
                              selected: selectedTheme == t,
                              title: Text(t.tr),
                              shape: RoundedRectangleBorder(
                                  borderRadius: UiDimens.br12),
                              tileColor: Theme.of(context).colorScheme.surface,
                              selectedTileColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: SwitchListTile(
                      value: app.preferences.isDark,
                      onChanged: (v) {
                        Get.changeThemeMode(
                            v ? ThemeMode.dark : ThemeMode.light);
                        app.setPreferences(app.preferences.copyWith(isDark: v));
                      },
                      title: Text('Dark Mode'.tr),
                      shape:
                          RoundedRectangleBorder(borderRadius: UiDimens.br12),
                      tileColor: Theme.of(context).colorScheme.surface,
                      selectedTileColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              flex: 7,
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: UiDimens.br12,
                  ),
                  elevation: 12,
                  child: ClipRRect(
                    borderRadius: UiDimens.br12,
                    child: SizedBox(
                      height: 320,
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Transform.rotate(
                              angle: -math.pi / 8.0,
                              child: Icon(
                                Icons.sensors,
                                color: app.preferences.isDark
                                    ? Theme.of(context).highlightColor
                                    : Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.8),
                                size: 240,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            color: Theme.of(context).colorScheme.surface,
                            child: Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Title',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text('Description'),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Sample')),
                                OutlinedButton(
                                    onPressed: () {},
                                    child: const Text('Sample')),
                                TextButton(
                                    onPressed: () {},
                                    child: const Text('Sample')),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .errorContainer,
                                      borderRadius: UiDimens.br12),
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    'Error'.tr,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.back(),
          child: const Icon(Icons.check),
        ),
      );
    });
  }
}
