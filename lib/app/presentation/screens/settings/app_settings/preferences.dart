import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferences extends StatelessWidget {
  SettingsPreferences({super.key});

  final AppController app = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings Preferences"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('Language'),
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
                title: const Text('Theme'),
                trailing: Icon(app.isDarkMode ? Icons.dark_mode : Icons.sunny),
                tileColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () {
                  app.toggleDarkMode();
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Timezone'),
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
                title: const Text('Wifi Credentials'),
                trailing: const Icon(Icons.chevron_right),
                tileColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
