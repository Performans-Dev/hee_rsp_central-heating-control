import 'dart:io';

import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:window_manager/window_manager.dart';

class SettingsAdvancedScreen extends StatelessWidget {
  const SettingsAdvancedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 3,
      title: "Advanced",
      body: PiScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.minimize),
              title: const Text('Minimize App'),
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: minimizeApp,
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Close App'),
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () => killProcess(context),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.power_settings_new_rounded),
              title: const Text('Shutdown'),
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () => shutdownDevice(context),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Reboot'),
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () => rebootDevice(context),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.lock_reset_outlined),
              title: const Text('Factory Reset'),
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () => factoryReset(context),
            ),
          ],
        ),
      ),
    );
  }

  void minimizeApp() async {
    await windowManager.minimize();
  }

  void killProcess(BuildContext context) {
    DialogUtils.confirmDialog(
      context: context,
      title: "Close App",
      description: "Are you sure you want to close now?",
      positiveText: "Yes",
      positiveCallback: () async {
        Process.killPid(pid);
      },
      negativeText: "Cancel",
    );
  }

  void shutdownDevice(BuildContext context) async {
    DialogUtils.confirmDialog(
      context: context,
      title: "Shutdown",
      description: "Are you sure you want to shutdown now?",
      positiveText: "Yes",
      positiveCallback: () async {
        Process.run('sudo', ['shutdown', 'now']);
      },
      negativeText: "Cancel",
    );
  }

  void rebootDevice(BuildContext context) {
    DialogUtils.confirmDialog(
        context: context,
        title: "Reboot",
        description: "Are you sure you want to reboot now?",
        positiveText: "Yes",
        positiveCallback: () async {
          Process.run('sudo', ['reboot', 'now']);
        },
        negativeText: "Cancel");
  }

  void factoryReset(BuildContext context) async {
    DialogUtils.confirmDialog(
        context: context,
        title: "Factory Reset",
        description: "Are you sure you want to factory reset?",
        positiveText: "Yes",
        positiveCallback: () async {
          DbProvider.db.resetDb();
          final box = GetStorage();
          await box.erase();
          final AppController app = Get.find();
          app.resetFlags();
          NavController.toHome();
        },
        negativeText: "Cancel");
  }
}