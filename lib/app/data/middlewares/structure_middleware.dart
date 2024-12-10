// ignore_for_file: avoid_print

import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StructureMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;
  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();
    if (!appController.didCheckFolders &&
        !appController.didCheckedProvisionResults &&
        !appController.didReadDeviceInfoCompleted) {
      print('didCheckFolders: ${appController.didCheckFolders}');
      print(
          'didCheckedProvisionResults: ${appController.didCheckedProvisionResults}');
      print(
          'didReadDeviceInfoCompleted: ${appController.didReadDeviceInfoCompleted}');
      return const RouteSettings(name: Routes.splashStructureProgress);
    }
    return null;
  }
}
