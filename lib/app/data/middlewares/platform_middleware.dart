import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlatformMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();

    if (!appController.didReadPlatformInfoCompleted) {
      return const RouteSettings(name: Routes.splashReadPlatformInfo);
    }

    return null;
  }
}
