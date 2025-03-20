import 'package:central_heating_control/app/app.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/screens/lock/pin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_saver/screen_saver_screen.dart';

class NavController {
  //
  static void onTermsOfUseTapped() async {
    Buzz.feedback();
  }

  static void onPrivacyPolicyTapped() async {
    Buzz.feedback();
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

  static void toSettingsFunctionList() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsFunctionList),
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

  static void toSettingsWeeklySchedule() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.settingsPlanList),
    );
  }

  static void toLogs() async {
    Buzz.feedback();
    Future.delayed(
      Duration.zero,
      () => Get.toNamed(Routes.logs),
    );
  }

  static void lock(BuildContext context) async {
    Buzz.success();
    AppController appController = Get.find();
    final user = appController.loggedInAppUser;
    appController.logoutUser();
    await LogService.addLog(LogDefinition(
      message: 'Lock Screen ${user != null ? '(user:${user.username})' : ''}',
      type: LogType.lockScreenEvent,
    ));
    Future.delayed(Duration.zero, () {
      Get.to(ScreenSaverScreen(
        definition: screenSaverDefinition,
      ));
    });
  }

  static Future<bool> showFunctionsDialog(
      {required BuildContext context}) async {
    return false;
  }

  static Future<String?> toPin({
    required BuildContext context,
    required String username,
    bool isNewUser = false,
    bool isNewPin = false,
  }) async {
    if (context.mounted) {
      final result = await Navigator.of(context).push(
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
          barrierColor: Colors.black.withValues(alpha: 0.3),
          barrierDismissible: true,
          opaque: false,
          pageBuilder: (_, __, ___) => PinScreen(
            isNewUser: isNewUser,
            username: username,
            isNewPin: isNewPin,
          ),
        ),
      );
      return result;
    }
    return null;
  }

  static void toInfo(BuildContext context) {
    // if (context.mounted) {
    //   Navigator.of(context).push(
    //     PageRouteBuilder(
    //       pageBuilder: (_, __, ___) => const PiInfoScreen(),
    //     ),
    //   );
    // }
    Get.toNamed(Routes.piInfo);
  }
}
