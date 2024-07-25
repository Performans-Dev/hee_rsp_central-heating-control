import 'dart:developer';

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
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

    if (!appController.connectivityResultReceived) {
      return const RouteSettings(name: Routes.splashConnection);
    }

    if (!appController.didConnected ) {
      return const RouteSettings(name: Routes.setupConnection);
    }
    if (!appController.didSettingsFetched) {
      return const RouteSettings(name: Routes.splashFetchSettings);
    }
    if (!Box.getBool(key: Keys.didLanguageSelected)) {
      return const RouteSettings(name: Routes.setupLanguage);
    }
    if (!Box.getBool(key: Keys.didTimezoneSelected)) {
      return const RouteSettings(name: Routes.setupTimezone);
    }

    if (!Box.getBool(key: Keys.didDateFormatSelected)) {
      return const RouteSettings(name: Routes.setupDateFormat);
    }
    if (!Box.getBool(key: Keys.didPickedTheme)) {
      return const RouteSettings(name: Routes.setupTheme);
    }
    if (!Box.getBool(key: Keys.didRegisteredDevice)) {
      return const RouteSettings(name: Routes.registerDevice);
    }
    if (!Box.getBool(key: Keys.didSignedIn)) {
      return const RouteSettings(name: Routes.signin);
    }

    if (!Box.getBool(key: Keys.didCheckedSubscription)) {
      return const RouteSettings(name: Routes.checkSubscription);
    }

    if (!Box.getBool(key: Keys.didActivated)) {
      return const RouteSettings(name: Routes.activation);
    }
    if (!appController.hasAdminUser) {
      return const RouteSettings(name: Routes.setupAdminUser);
    }

    return null;
  }
}
