import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TechSupportLoggedInMiddleware extends GetMiddleware {
  @override
  int? get priority => 30;

  @override
  RouteSettings? redirect(String? route) {
    // final AppController appController = Get.find();

/*     if (appController.loggedInAppUser == null ||
        appController.loggedInAppUser!.level == AppUserLevel.user ||
        appController.loggedInAppUser!.level == AppUserLevel.admin) {
      return const RouteSettings(name: Routes.pin);
    } */

    return null;
  }
}
