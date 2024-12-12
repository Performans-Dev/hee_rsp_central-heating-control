import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesScreen extends StatelessWidget {
  const SettingsPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: 'Preferences',
        selectedIndex: 3,
        body: PiScrollView(
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Theme'),
                subtitle: Text(
                  '${app.preferencesDefinition.themeName} - '
                  '${app.preferencesDefinition.themeModeName}',
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
              ListTile(
                title: const Text('Lock Screen'),
                subtitle:
                    Text(app.preferencesDefinition.lockDurationIdleTimeoutName),
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
              ListTile(
                leading: const Icon(Icons.translate),
                title: const Text('Language'),
                subtitle: Text(app.preferencesDefinition.languageName),
                trailing: const Icon(Icons.chevron_right),
                tileColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () {
                  Get.toNamed(Routes.settingsPreferencesLanguage);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Date, Time & Timezone Settings'),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const DateTextWidget(oneLine: true),
                    Text(', ${app.preferencesDefinition.timezoneName}'),
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
              if (enabledConnections) ...[
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
                    Get.toNamed(Routes.settingsConnection);
                  },
                ),
              ],
              ListTile(
                tileColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: const Icon(Icons.settings_suggest),
                title: const Text('Advanced'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // final AppController app = Get.find();
                  // if (app.loggedInAppUser?.level == AppUserLevel.user ||
                  //     app.loggedInAppUser?.level == AppUserLevel.admin) {
                  //   DialogUtils.confirmDialog(
                  //     context: context,
                  //     title: 'Not Allowed',
                  //     description:
                  //         'You are not allowed to access advanced settings',
                  //     positiveText: 'Enter PIN',
                  //     negativeText: 'Back',
                  //     positiveCallback: () {
                  //       Get.toNamed(Routes.settingsPreferencesAdvanced);
                  //     },
                  //   );
                  // } else {
                  Get.toNamed(Routes.settingsPreferencesAdvanced);
                  // }
                },
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      );
    });
  }
}
