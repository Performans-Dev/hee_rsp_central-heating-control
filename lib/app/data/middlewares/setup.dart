import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();

    // if (!appController.didSettingsFetched) {
    //   return const RouteSettings(name: Routes.splash);
    // }

    // if (!appController.didLanguageSelected) {
    //   return const RouteSettings(name: Routes.setupLanguage);
    // }

    // if (!appController.didTimezoneSelected) {
    //   return const RouteSettings(name: Routes.setupTimezone);
    // }

    // if (!appController.didActivated) {
    //   return const RouteSettings(name: Routes.activation);
    // }

    // if (!appController.hasAdminUser) {
    //   return const RouteSettings(name: Routes.setupAdminUser);
    // }

    return null;
  }
}
