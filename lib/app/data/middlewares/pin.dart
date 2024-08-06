import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPinAccountMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();

    if (appController.token == null || appController.token!.isEmpty) {
      return const RouteSettings(name: Routes.heetingsLogin);
    }
    return null;
  }
}
