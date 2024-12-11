// ignore_for_file: avoid_print

import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupCompletedMiddleware extends GetMiddleware {
  @override
  int? get priority => 10;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();
    // if (!appController.doesFoldersExists) {
    //   return const RouteSettings(name: Routes.createFolders);
    // }
    // if (!appController.doesProvisionExists) {
    //   return const RouteSettings(name: Routes.initialTest);
    // }

    if (!appController.preferencesDefinition.allSelected) {
      print("SETUP MIDDLEWARE: preferencesDefinition.allSelected");
      return const RouteSettings(name: Routes.setup);
    }
    // if (appController.heethingsAccount?.isOkey != true) {
    //   print("SETUP MIDDLEWARE: heethingsAccount.isOkey");
    //   return const RouteSettings(name: Routes.setup);
    // }
    if (!appController.hasRequiredAppUserRoles) {
      print("SETUP MIDDLEWARE: hasRequiredAppUserRoles");
      return const RouteSettings(name: Routes.setup);
    }
    if (appController.shouldUpdateApp) {
      print("SETUP MIDDLEWARE: shouldUpdateApp");
      return const RouteSettings(name: Routes.forceUpdate);
    }
    if (!appController.isSerialNumberValid) {
      print("SETUP MIDDLEWARE: isSerialNumberValid");
      return const RouteSettings(name: Routes.invalidSerial);
    }
    if (!appController.hasLoggedInUser) {
      print("SETUP MIDDLEWARE: hasLoggedInUser");
      return const RouteSettings(name: Routes.lockScreen);
    }
    return null;
  }
}
