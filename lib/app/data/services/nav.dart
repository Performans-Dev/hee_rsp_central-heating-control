import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_saver/screen_saver_screen.dart';

class NavController {
  //
  static void onTermsOfUseTapped() async {
    Buzz.feedback();
    logger.d('terms of use');
  }

  static void onPrivacyPolicyTapped() async {
    Buzz.feedback();
    logger.d('privacy policy');
  }

  static void toHome() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.offAllNamed(Routes.home),
    );
  }

  static void toSettings() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settings),
    );
  }

  static void toSettingsManagement() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsManagement),
    );
  }

  static void toSettingsZoneList() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsZoneList),
    );
  }

  static void toSettingsZoneAdd() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsZoneAdd),
    );
  }

  static void toSettingsDeviceList() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsDeviceList),
    );
  }

  static void toSettingsSensorList() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsSensorList),
    );
  }

  // static void toZoneDeviceSensorManagement() async {
  //   Buzz.feedback();
  //   Future.delayed(
  //     Duration.zero,
  //     () => Get.toNamed(Routes.settingstZoneDeviceSensorManagement),
  //   );
  // }

  static void toSettingsUserList() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsUserList),
    );
  }

  static void toSettingsAddUser() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsUserAdd),
    );
  }

  static void toSettingsPreferences() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsPreferences),
    );
  }

  static void toLogs() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.logs),
    );
  }

  static void lock() async {
    Buzz.success();
    AppController appController = Get.find();
    final user = appController.loggedInAppUser;
    appController.logoutUser();
    await LogService.addLog(LogDefinition(
      message: 'Lock Screen ${user != null ? '(user:${user.username})' : ''}',
      type: LogType.lockScreenEvent,
    ));
    Future.delayed(Duration.zero, () {
      Get.toNamed(Routes.lockScreen);
    });
  }

  static Future<bool> showFunctionsDialog(
      {required BuildContext context}) async {
    return false;
  }
}
