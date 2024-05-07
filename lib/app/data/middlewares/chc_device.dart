import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChcDeviceMiddleware extends GetMiddleware {
  @override
  int? get priority => 4;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();
    if (appController.chcDeviceId == null) {
      return const RouteSettings(name: Routes.registerDevice);
    }

    return null;
  }
}
