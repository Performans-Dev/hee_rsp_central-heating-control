import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesScreen extends StatelessWidget {
  const SettingsPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = LocalizationService.locale;
    late TimezoneDefinition currentTimezone;
    try {
      currentTimezone = TimezoneDefinition.fromJson(
          Box.getString(key: Keys.selectedTimezone));
    } on Exception catch (e) {
      if (kDebugMode) {
        print('cant parse timezone: $e');
      }
      Buzz.alarm();
    }

    return AppScaffold(
      title: 'Preferences',
      selectedIndex: 3,
      body: PiScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Theme'),
              subtitle: Text(
                '${Box.getString(key: Keys.selectedTheme).camelCaseToHumanReadable()} - ${ThemeMode.values[Box.getInt(key: Keys.themeMode)].name.camelCaseToHumanReadable().tr}',
              ),
              leading: const Icon(Icons.color_lens),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.toNamed(Routes.settingsPreferencesTheme);
              },
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Lock Screen'),
              subtitle: Text(CommonUtils.secondsToHumanReadable(
                  Box.getInt(key: Keys.idleTimerInSeconds, defaultVal: 180))),
              leading: const Icon(Icons.screen_lock_landscape),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.toNamed(Routes.settingsPreferencesLockScreen);
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
                Get.toNamed(Routes.settingsPreferencesLanguage);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Date, Time & Timezone Settings'),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const DateTextWidget(oneLine: true),
                  Text(', ${currentTimezone.name}'),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () {
                Get.toNamed(Routes.settingsPreferencesTimezone);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.wifi),
              title: const Text('Internet Connection'),
              subtitle: const Text('WiFi & Ethernet Settings'),
              trailing: const Icon(Icons.chevron_right),
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () {
                Get.toNamed(Routes.connection);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: const Icon(Icons.settings_suggest),
              title: const Text('Advanced'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                final AppController app = Get.find();
                if (app.loggedInAppUser?.level == AppUserLevel.user ||
                    app.loggedInAppUser?.level == AppUserLevel.admin) {
                  DialogUtils.confirmDialog(
                    context: context,
                    title: 'Not Allowed',
                    description:
                        'You are not allowed to access advanced settings',
                    positiveText: 'Enter PIN',
                    negativeText: 'Back',
                    positiveCallback: () {
                      Get.toNamed(Routes.settingsPreferencesAdvanced);
                    },
                  );
                } else {
                  Get.toNamed(Routes.settingsPreferencesAdvanced);
                }
              },
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
