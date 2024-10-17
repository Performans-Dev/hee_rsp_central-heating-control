import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminLoggedInMiddleware extends GetMiddleware {
  @override
  int? get priority => 30;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();

/*     if (appController.loggedInAppUser == null ||
        appController.loggedInAppUser!.level == AppUserLevel.user) {
      return const RouteSettings(name: Routes.pin);
    } */

    return null;
  }
}
