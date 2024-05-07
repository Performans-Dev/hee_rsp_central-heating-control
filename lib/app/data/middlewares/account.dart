import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountMiddleware extends GetMiddleware {
  @override
  int? get priority => 3;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();
    if (appController.account == null) {
      return const RouteSettings(name: Routes.signin);
    }

    return null;
  }
}
