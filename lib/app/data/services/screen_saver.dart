import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:get/get.dart';

class ScreenSaverController extends GetxController {
  final lastTouchTime = DateTime.now().obs; // Use Rx to trigger rebuilds

  void handleTouch() {
    lastTouchTime.value = DateTime.now();
  }

  void checkForInactivity() async {
    while (true) {
      await Future.delayed(const Duration(minutes: 1)); // Check every 5 minutes
      final inactivityDuration = DateTime.now().difference(Box.lastTouchTime);
      if (inactivityDuration.inMinutes >= 1) {
        // Show screen saver
        Get.offAllNamed(Routes.screenSaver);
        break;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    ever(lastTouchTime, (_) => checkForInactivity()); // Check on touch updates
  }
}
