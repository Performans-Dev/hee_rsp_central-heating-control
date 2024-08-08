import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionMiddleware extends GetMiddleware {
  final String returnRoute;
  ConnectionMiddleware({required this.returnRoute});

  @override
  int? get priority => 10;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();

    if (!appController.didConnected) {
      return RouteSettings(name: returnRoute);
    }

    return null;
  }
}
