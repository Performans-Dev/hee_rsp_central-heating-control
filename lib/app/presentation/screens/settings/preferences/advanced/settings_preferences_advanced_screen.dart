// ignore_for_file: avoid_print

import 'dart:io';

import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/file.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class SettingsPreferencesAdvancedScreen extends StatefulWidget {
  const SettingsPreferencesAdvancedScreen({super.key});

  @override
  State<SettingsPreferencesAdvancedScreen> createState() =>
      _SettingsPreferencesAdvancedScreenState();
}

class _SettingsPreferencesAdvancedScreenState
    extends State<SettingsPreferencesAdvancedScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 3,
      title: "Advanced",
      body: PiScrollView(
        child: Column(
          spacing: 12,
          children: [
            const SizedBox(height: 12),
            if (enabledUpdates) ...[
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Check Updates'),
                trailing: const Icon(Icons.chevron_right),
                tileColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () async {
                  await switchApp('heethings-cc-elevator');
                  // final app = Get.find<AppController>();
                  // if (app.deviceInfo == null) return;
                  // try {
                  //   final ChannelController channelController = Get.find();
                  //   await channelController.closeAllRelays();
                  // } on Exception catch (e) {
                  //   print('-------- closeAllRelays exception: $e');
                  //   print(e);
                  // }

                  // Future.delayed(const Duration(seconds: 1), () {
                  //   Process.killPid(pid);
                  // });
                  // Process.run('sudo', ['heethings-cc-elevator']);
                },
              ),
            ],
            if (enabledHardwareExtensions) ...[
              ListTile(
                leading: const Icon(Icons.hardware),
                title: const Text('Hardware Config'),
                trailing: const Icon(Icons.chevron_right),
                tileColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () {
                  Get.toNamed(Routes.settingsPreferencesAdvancedHardwareConfig);
                },
              ),
            ],
            if (enabledDiagnostics) ...[
              ListTile(
                leading: const Icon(Icons.bug_report),
                title: const Text('Diagnostics App'),
                trailing: const Icon(Icons.chevron_right),
                tileColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () async {
                  await switchApp('heethings-cc-diagnose');
                  // List<Hardware> extList = <Hardware>[];
                  // try {
                  //   extList = await DbProvider.db.getHardwareDevices();
                  // } on Exception catch (e) {
                  //   print('getting hardware devices exception: $e');
                  //   print(e);
                  // }

                  // try {
                  //   final directory =
                  //       Directory('/home/pi/Heethings/CC/databases');
                  //   if (!await directory.exists()) {
                  //     await directory.create(recursive: true);
                  //   }

                  //   final file = File('${directory.path}/external-devices.txt');
                  //   final content = extList.map((e) => e.id).join(',');
                  //   await file.writeAsString(content);
                  // } catch (e) {
                  //   // Handle error silently
                  // }

                  // final ChannelController channelController = Get.find();
                  // await channelController.closeAllRelays();

                  // Process.run('sudo', ['heethings-cc-diagnose']);

                  // Future.delayed(const Duration(seconds: 1), () {
                  //   Process.killPid(pid);
                  // });
                },
              ),
            ],
            if (enabledFactoryReset) ...[
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
            if (enabledOsControls) ...[
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.minimize),
                      title: const Text('Minimize App'),
                      tileColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: minimizeApp,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('Close App'),
                      tileColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () => killProcess(context),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.power_settings_new_rounded),
                      title: const Text('Shutdown'),
                      tileColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () => shutdownDevice(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.refresh),
                      title: const Text('Reboot'),
                      tileColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () => rebootDevice(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
            ],
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
      negativeText: "Cancel",
    );
  }

  void factoryReset(BuildContext context) async {
    if (enabledFactoryReset) {
      DialogUtils.confirmDialog(
        context: context,
        title: "Factory Reset",
        description: "Are you sure you want to factory reset?",
        positiveText: "Yes",
        positiveCallback: () async {
          await FileServices.performFactoryReset();
        },
        negativeText: "Cancel",
      );
    } else {
      DialogUtils.alertDialog(
        context: context,
        title: "Factory Reset",
        description: "Factory reset is disabled",
        positiveText: "Ok",
        positiveCallback: () {},
      );
    }
  }

  Future<void> switchApp(String otherAppCommand) async {
    final pidFile = File('/tmp/app_pid');

    // Write the current PID to the file for the other app to read
    await pidFile.writeAsString('$pid');

    // Launch the other app
    try {
      print('Launching other app: $otherAppCommand');
      await Process.run('sudo', otherAppCommand.split(' '));
    } catch (e) {
      print('Error launching other app: $e');
      return; // If launching fails, don't exit
    }

    // Exit the current app after launching the other
    print('Exiting current app with PID: $pid');
    exit(0);
  }
}
