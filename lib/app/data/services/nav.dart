import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController {
  //
  static void onTermsOfUseTapped() async {
    logger.d('terms of use');
  }

  static void onPrivacyPolicyTapped() async {
    logger.d('privacy policy');
  }

  static void toHome() async {
    Future.delayed(
      Duration.zero,
      () => Get.offAllNamed(Routes.home),
    );
  }

  static void toSettings() async {
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settings),
    );
  }

  static void toSettingsUserList() async {
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsUserList),
    );
  }

  static void toSettingsAddUser() async {
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsUserAdd),
    );
  }

  static void lock() {
    AppController appController = Get.find();
    appController.logoutUser();
    toHome();
  }

  static Future<bool> showFunctionsDialog(
      {required BuildContext context}) async {
    return false;
  }
}
