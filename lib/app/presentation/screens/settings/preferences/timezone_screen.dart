import 'dart:math' as math;

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/restart.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/preferences/timezone.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferencesTimezoneScreen extends StatefulWidget {
  const PreferencesTimezoneScreen({super.key});

  @override
  State<PreferencesTimezoneScreen> createState() =>
      _PreferencesTimezoneScreenState();
}

class _PreferencesTimezoneScreenState extends State<PreferencesTimezoneScreen> {
  final AppController appController = Get.find();
  final List<Timezone> timezones = StaticProvider.getTimezoneList;
  late Timezone selectedTimezone;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    selectedTimezone = appController.preferences.timezone;
    scrollController = ScrollController();
    Future.delayed(const Duration(milliseconds: 100), _scrollToInitial);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToInitial() {
    final index = timezones
        .indexWhere((element) => element.zone == selectedTimezone.zone);
    scrollController.animateTo((math.max(0, (index - 2))) * 72,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Timezone'.tr,
      hasBackAction: true,
      selectedMenuIndex: 1,
      body: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          controller: scrollController,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RadioListTile(
              value: timezones[index],
              groupValue: selectedTimezone,
              onChanged: (value) {
                setState(() {
                  selectedTimezone = value!;
                });
              },
              selected: selectedTimezone == timezones[index],
              title: Text(timezones[index].name),
              secondary: Text(timezones[index].gmt),
              subtitle: Text(timezones[index].zone),
              shape: RoundedRectangleBorder(borderRadius: UiDimens.br12),
              tileColor: Theme.of(context).colorScheme.surface,
              selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          itemCount: timezones.length,
        ),
      ),
      floatingActionButton: Opacity(
        opacity:
            selectedTimezone == appController.preferences.timezone ? 0.4 : 1,
        child: FloatingActionButton.extended(
            onPressed: selectedTimezone == appController.preferences.timezone
                ? null
                : () {
                    appController.setPreferences(appController.preferences
                        .copyWith(timezone: selectedTimezone));
                    RestartWidget.restartApp(context);
                  },
            elevation: selectedTimezone == appController.preferences.timezone
                ? 0
                : null,
            icon: const Icon(Icons.save),
            label: Text('Save'.tr)),
      ),
    );
  }
}
