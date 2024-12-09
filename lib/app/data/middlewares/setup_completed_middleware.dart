import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupCompletedMiddleware extends GetMiddleware {
  @override
  int? get priority => 20;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();
    if (!appController.doesFoldersExists) {
      return const RouteSettings(name: Routes.createFolders);
    }
    if (!appController.doesProvisionExists) {
      return const RouteSettings(name: Routes.initialTest);
    }

    if (!appController.preferencesDefinition.allSelected) {
      return const RouteSettings(name: Routes.setup);
    }
    if (appController.heethingsAccount?.isOkey != true) {
      return const RouteSettings(name: Routes.setup);
    }
    if (!appController.hasRequiredAppUserRoles) {
      return const RouteSettings(name: Routes.setup);
    }
    if (!appController.shouldUpdateApp) {
      return const RouteSettings(name: Routes.forceUpdate);
    }
    if (!appController.isSerialNumberValid) {
      return const RouteSettings(name: Routes.invalidSerial);
    }
    if (!appController.hasLoggedInUser) {
      return const RouteSettings(name: Routes.lockScreen);
    }
    return null;
  }
}
