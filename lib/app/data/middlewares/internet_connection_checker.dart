import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetConnectionCheckerMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
   final  AppController appController = Get.find();
   if(!appController.didConnectionChecked){
    return const RouteSettings(name: Routes.splashInternetConnectionProgress);
   }
    return null;
  }
}
