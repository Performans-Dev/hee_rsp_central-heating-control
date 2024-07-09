import 'dart:developer';

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

    log(
      'didSettingsFetched: ${appController.didSettingsFetched}',
      name: 'SetupMiddleware',
    );
    if (!appController.didSettingsFetched) {
      return const RouteSettings(name: Routes.splashFetchSettings);
    }

    log(
      'didLanguageSelected: ${appController.didLanguageSelected}',
      name: 'SetupMiddleware',
    );
    if (!appController.didLanguageSelected) {
      return const RouteSettings(name: Routes.setupLanguage);
    }

    log(
      'didTimezoneSelected: ${appController.didTimezoneSelected}',
      name: 'SetupMiddleware',
    );
    if (!appController.didTimezoneSelected) {
      return const RouteSettings(name: Routes.setupTimezone);
    }

    log(
      'didDateFormatSelected: ${appController.didDateFormatSelected}',
      name: 'SetupMiddleware',
    );
    if (!appController.didDateFormatSelected) {
      return const RouteSettings(name: Routes.setupDateFormat);
    }

    log(
      'didActivated: ${appController.didActivated}',
      name: 'SetupMiddleware',
    );
    if (!appController.didActivated) {
      return const RouteSettings(name: Routes.activation);
    }

    log(
      'hasAdminUser: ${appController.hasAdminUser}',
      name: 'SetupMiddleware',
    );
    if (!appController.hasAdminUser) {
      return const RouteSettings(name: Routes.setupAdminUser);
    }

    log(
      'didPickedTheme: ${appController.didPickedTheme}',
      name: 'SetupMiddleware',
    );
    if (!appController.didPickedTheme) {
      return const RouteSettings(name: Routes.setupTheme);
    }

    return null;
  }
}
