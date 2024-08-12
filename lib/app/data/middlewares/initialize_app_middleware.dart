import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitializeAppMiddleware extends GetMiddleware {
  @override
  int? get priority => 30;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();

    if (appController.appSettings == null) {
      return const RouteSettings(name: Routes.splashAppSettings);
    }

    if (appController.deviceInfo == null) {
      return const RouteSettings(name: Routes.splashDeviceInfo);
    }

    if (appController.appUserList.isEmpty) {
      return const RouteSettings(name: Routes.splashAppUserList);
    }

    return null;
  }
}
