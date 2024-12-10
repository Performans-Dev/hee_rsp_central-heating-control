import 'dart:convert';
import 'dart:io';

import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/main.dart';
import 'package:get/get.dart';

class FileServices {
  static Future<bool> createMissingFolders() async {
    // mock
    await Future.delayed(const Duration(milliseconds: 500));
    //TODO: replace with real code

    final AppController appController = Get.find();
    appController.setDidCheckFoldersExists(true);

    return true;
  }

  //#region MARK: Folders
  static Future<void> checkFoldersExists() async {
    AppController app = Get.find();
    if (!isPi) {
      app.setDidCheckFoldersExists(true);
      app.setDoesFoldersExists(true);
    }
    try {
      final List<bool> results = [];
      final List<String> paths = [
        '/home/pi/Heethings/CC/application',
        '/home/pi/Heethings/CC/diagnose/app',
        '/home/pi/Heethings/CC/databases',
        '/home/pi/Heethings/CC/logs',
        '/home/pi/Heethings/CC/elevator/app',
      ];

      for (final path in paths) {
        final result = await Process.run(
            'bash', ['-c', 'test -d "$path" && echo "exists"']);
        results.add(result.exitCode == 0);
      }

      app.setDoesFoldersExists(results.every((r) => r));
    } on Exception catch (e) {
      // ignore: avoid_print
      print(e);
    } finally {
      app.setDidCheckFoldersExists(true);
    }
  }

  static Future<void> checkProductionTestsCompleted() async {
    AppController app = Get.find();
    try {
      File f = File("/db/path/production.json");
      final content = await f.readAsString();
      final map = jsonDecode(content);
      app.setDoesProvisionExists(map['success']);
    } on Exception catch (_) {}
    app.setDidCheckProvisionTestResults(true);
  }
//#endregion
//TODO: factory reset buraya koy performfactory
//TODO: getstorage ve db de silinecekleri sil
// appcontrollerdaki preferences ,account değişkenlerini copywith ile güncelle.
//reboot
}
