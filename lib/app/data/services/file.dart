// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/main.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FileServices {
  // static Future<bool> createMissingFolders() async {
  //   // mock
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   //TODO: replace with real code

  //   final AppController appController = Get.find();
  //   appController.setDidCheckFoldersExists(true);

  //   return true;
  // }

  //#region MARK: Folders
  // static Future<void> checkFoldersExists() async {
  //   AppController app = Get.find();
  //   try {
  //     final result =
  //         await Process.run('sudo', ['/home/pi/Heethings/folder-check.sh']);
  //     print(
  //         'FOLDER CHECK RESULT: ${result.exitCode} ${result.stdout} ${result.stderr}');
  //     app.setDoesFoldersExists(result.exitCode == 0);
  //   } on Exception catch (e) {
  //     print("FOLDER CHECK RESULT: $e");
  //   } finally {
  //     app.setDidCheckFoldersExists(true);
  //   }
  // }

  static Future<void> checkProvisionStatusCompleted() async {
    AppController app = Get.find();
    if (enabledAccount) {
      try {
        File f = File("/home/pi/Heethings/CC/databases/production.json");
        final content = await f.readAsString();
        final map = jsonDecode(content);
        app.setDoesProvisionExists(map['success']);
      } on Exception catch (e) {
        print("PROVISION CHECK RESULT: $e");
      } finally {
        app.setDidCheckProvisionTestResults(true);
      }
    } else {
      app.setDoesProvisionExists(true);
      app.setDidCheckProvisionTestResults(true);
    }
  }
//#endregion

  static Future<void> performFactoryReset() async {
    if (enabledFactoryReset) {
      final box = GetStorage();
      await box.erase();
      await DbProvider.db.resetDb();
      final AppController appController = Get.find();
      appController.logoutUser();
      if (Platform.isLinux) {
        Process.run('sudo', ['reboot', 'now']);
      } else {
        exit(0);
      }
    }
  }
}
