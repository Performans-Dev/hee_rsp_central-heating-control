import 'dart:io';

import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/shell_command.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
  String stdOut = '';
  String stdErr = '';

  List<ShellCommand> updateCommands = [
    ShellCommand(
      command: 'git',
      arguments: ['checkout', '.'],
      workingDirectory:
          '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control',
    ),
    ShellCommand(
      command: 'git',
      arguments: [
        'clean',
        '-fd',
      ],
    ),
    ShellCommand(
      command: 'gh',
      arguments: [
        'repo',
        'sync',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        'rm',
        '-rf',
        '.dart_tool',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        'chown',
        '-R',
        '\$(whoami)',
        '/home/pi/Heethings/cc-source',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        '-u',
        'pi',
        'flutter',
        'doctor',
        '-v',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        '-u',
        'pi',
        'flutter',
        'clean',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        '-u',
        'pi',
        'flutter',
        'pub',
        'get',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        '-u',
        'pi',
        'flutter',
        'build',
        'linux',
        '--release',
      ],
    ),
    ShellCommand(
      command: 'cp',
      arguments: [
        '-r',
        '/home/pi/Heethings/cc-source/hee_rsp_central-heating-control/build/linux/arm64/release/bundle/*',
        '/home/pi/Heethings/cc-app',
      ],
    ),
    ShellCommand(
      command: 'sudo',
      arguments: [
        'reboot',
        'now',
      ],
    ),
  ];

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
              leading: const Icon(Icons.update),
              title: const Text('Update'),
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () {
                updateCC(context);
              },
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
      negativeText: "Cancel",
    );
  }

  void updateCC(BuildContext context) {
    DialogUtils.confirmDialog(
      context: context,
      title: "Update CC",
      description: "Are you sure you want to  apply update now?",
      positiveText: "Yes",
      positiveCallback: () async {
        SmartDialog.show(
          tag: 'update_indicator',
          backDismiss: false,
          clickMaskDismiss: false,
          builder: (context) => Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.surface),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 16),
                  Text(stdOut.isEmpty ? "Güncelleniyor..." : stdOut)
                ],
              ),
            ),
          ),
        );
        try {
          //sudo -u pi /home/pi/Heetings/ccupdate.sh
          String results = '';
          String errors = '';
          int counter = 0;
          for (final command in updateCommands) {
            final result = await Process.run(
              command.command,
              command.arguments ?? [],
              workingDirectory: command.workingDirectory,
            );
            counter += result.exitCode;
            setState(() {
              stdOut =
                  '\n${command.command} ${command.arguments?.join(' ')}\n${result.stdout.toString()}';
            });
            if (result.exitCode == 0) {
              results += result.stdout.toString();
            } else {
              errors += result.stderr.toString();
              break;
            }
            await Future.delayed(Duration(seconds: 1));
          }

          if (counter == 0) {
            Buzz.success();
          } else {
            Buzz.error();
          }

          // final result = await Process.run(
          //   './ccupdate.sh',
          //   [''],
          //   workingDirectory: '/home/pi/Heethings',
          // );

          // if (result.exitCode == 0) {
          //   Buzz.success();
          // } else {
          //   Buzz.error();
          // }

          SmartDialog.dismiss(tag: 'update_indicator');
          if (context.mounted) {
            DialogUtils.confirmDialog(
              context: context,
              title: "Result",
              description: '${results}\n'
                  '${errors}',
              positiveText: 'Retry',
              negativeText: 'Cancel',
              positiveCallback: () {
                updateCC(context);
              },
            );
          }
        } catch (e) {
          SmartDialog.dismiss(tag: 'update_indicator');
          if (context.mounted) {
            DialogUtils.confirmDialog(
              context: context,
              title: "Exception",
              description: e.toString(),
              positiveText: 'Retry',
              negativeText: 'Cancel',
              positiveCallback: () {
                updateCC(context);
              },
            );
          }
          Buzz.alarm();
        } finally {
          SmartDialog.dismiss(tag: 'update_indicator');
        }
      },
      negativeText: "Cancel",
    );
  }

  void factoryReset(BuildContext context) async {
    DialogUtils.confirmDialog(
      context: context,
      title: "Factory Reset",
      description: "Are you sure you want to factory reset?",
      positiveText: "Yes",
      positiveCallback: () async {
        final AppController app = Get.find();
        await app.performFactoryReset();
      },
      negativeText: "Cancel",
    );
  }
}
