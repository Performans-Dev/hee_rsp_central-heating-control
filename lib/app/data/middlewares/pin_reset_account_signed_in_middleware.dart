import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PinResetAccountSignedInMiddleware extends GetMiddleware {
  @override
  int? get priority => 30;

  @override
  RouteSettings? redirect(String? route) {
    final AppController appController = Get.find();

    if (appController.pinResetAccount == null) {
      return const RouteSettings(name: Routes.signinForPinReset);
    }

    return null;
  }
}
