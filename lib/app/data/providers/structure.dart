import 'dart:convert';
import 'dart:io';

import 'package:central_heating_control/app/data/services/app.dart';
import 'package:get/get.dart';

class StructureProvider {
  //#region MARK: Folders
  AppController app = Get.find();
  Future<void> checkFoldersExists() async {
    final List<bool> results = [];
    final List<String> paths = [
      '/home/pi/Heethings/CC/application',
      '/home/pi/Heethings/CC/diagnose/app',
      '/home/pi/Heethings/CC/databases',
      '/home/pi/Heethings/CC/logs',
      '/home/pi/Heethings/CC/elevator/app',
    ];

    for (final path in paths) {
      final result =
          await Process.run('bash', ['-c', 'test -d "$path" && echo "exists"']);
      results.add(result.exitCode == 0);
    }

    app.setDoesFoldersExists(results.every((r) => r));
    app.setDidCheckFoldersExists(true);
  }

  Future<void> checkProductionTestsCompleted() async {
    File f = File("/db/path/production.json");
    final content = await f.readAsString();
    final map = jsonDecode(content);
    app.setDoesProvisionExists(map['success']);
    app.setDidCheckProvisionTestResults(true);
  }
//#endregion
//TODO: factory reset buraya koy performfactory
//TODO: getstorage ve db de silinecekleri sil
// appcontrollerdaki preferences ,account değişkenlerini copywith ile güncelle.
//reboot
}
