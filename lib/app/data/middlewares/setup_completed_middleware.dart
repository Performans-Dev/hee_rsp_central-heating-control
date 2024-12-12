// ignore_for_file: avoid_print

import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupCompletedMiddleware extends GetMiddleware {
  @override
  int? get priority => 10;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();

    if (enabledSecurity) {
      if (!appController.doesFoldersExists) {
        print('MIDDLEWARE: Should open create folders screen');
        return const RouteSettings(name: Routes.createFolders);
      }
    }

    if (enabledSecurity) {
      if (!appController.doesProvisionExists) {
        print('MIDDLEWARE: Should open initial test screen');
        return const RouteSettings(name: Routes.initialTest);
      }
    }

    if (!appController.preferencesDefinition.allSelected) {
      print('MIDDLEWARE: Should open setup screen for preferences');
      return const RouteSettings(name: Routes.setup);
    }

    if (enabledAccount) {
      if (appController.heethingsAccount?.isOkey != true) {
        print('MIDDLEWARE: Should open setup screen for account');
        return const RouteSettings(name: Routes.setup);
      }
    }

    if (!appController.hasRequiredAppUserRoles) {
      print('MIDDLEWARE: Should open setup screen for app users');
      return const RouteSettings(name: Routes.setup);
    }

    if (appController.shouldUpdateApp) {
      print('MIDDLEWARE: Should open force update screen');
      return const RouteSettings(name: Routes.forceUpdate);
    }

    if (!appController.isSerialNumberValid) {
      print('MIDDLEWARE: Should open invalid serial screen');
      return const RouteSettings(name: Routes.invalidSerial);
    }

    if (enabledLocalUsers) {
      if (!appController.hasLoggedInUser) {
        print('MIDDLEWARE: Should open lock screen');
        return const RouteSettings(name: Routes.lockScreen);
      }
    }

    print('MIDDLEWARE: Should open home screen');
    return null;
  }
}
