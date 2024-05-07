import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/main.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  //
  void onTermsOfUseTapped() async {
    logger.d('terms of use');
  }

  void onPrivacyPolicyTapped() async {
    logger.d('privacy policy');
  }

  void toHome() async {
    Future.delayed(
      Duration.zero,
      () => Get.offAllNamed(Routes.home),
    );
  }
}
