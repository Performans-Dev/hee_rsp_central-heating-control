import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:central_heating_control/app/data/models/wifi.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferences extends StatelessWidget {
  SettingsPreferences({super.key});

  final AppController app = Get.find();
  @override
  Widget build(BuildContext context) {
    final String wifi = Box.getString(key: Keys.wifiCredentials);
    WiFiCredentials wiFiCredentials = wifi.isEmpty
        ? WiFiCredentials(ssid: '', password: '')
        : WiFiCredentials.fromJson(wifi);
    Locale currentLocale = LocalizationService.locale;
    TimezoneDefinition currentTimezone =
        TimezoneDefinition.fromJson(Box.getString(key: Keys.selectedTimezone));
    return AppScaffold(
      title: 'Preferences',
      selectedIndex: 3,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            // color: Theme.of(context).focusColor,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(20),
            child: Text(
              'Settings / Preferences',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    secondary:
                        Icon(app.isDarkMode ? Icons.dark_mode : Icons.sunny),
                    title: const Text('Theme'),
                    subtitle: Text(Get.isDarkMode ? 'Dark' : 'Light'),
                    value: Get.isDarkMode,
                    onChanged: (value) {
                      app.toggleDarkMode();
                    },
                    tileColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.translate),
                    title: const Text('Language'),
                    subtitle: Text(
                        '${currentLocale.languageCode}-${currentLocale.countryCode}'),
                    trailing: const Icon(Icons.chevron_right),
                    tileColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {
                      Get.toNamed(Routes.settingsLanguage);
                    },
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Timezone'),
                    subtitle: Text(currentTimezone.name),
                    trailing: const Icon(Icons.chevron_right),
                    tileColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {
                      Get.toNamed(Routes.settingsTimezone);
                    },
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.wifi),
                    title: const Text('Wifi Credentials'),
                    subtitle: Text(wiFiCredentials.ssid.isEmpty
                        ? 'Unknown'
                        : wiFiCredentials.ssid),
                    trailing: const Icon(Icons.chevron_right),
                    tileColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.update),
                    title: const Text('Check Updates'),
                    trailing: const Icon(Icons.chevron_right),
                    tileColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.hardware),
                    title: const Text('Hardware Config'),
                    trailing: const Icon(Icons.chevron_right),
                    tileColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.bug_report),
                    title: const Text('Developer Options'),
                    trailing: const Icon(Icons.chevron_right),
                    tileColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
