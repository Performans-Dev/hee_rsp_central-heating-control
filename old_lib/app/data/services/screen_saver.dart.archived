import 'dart:async';

import 'package:get/get.dart';

class ScreenSaverController extends GetxController {
  final RxBool _isSavingScreen = false.obs;
  bool get isSavingScreen => _isSavingScreen.value;

  Timer? timer;

  void checkForInactivity() async {
    // if (isSavingScreen) {
    //   log('already saving');
    //   return;
    // }
    // final lastTouchTime = Box.lastTouchTime;
    // log('$lastTouchTime');
    // if (DateTime.now().add(const Duration(minutes: 1)).isAfter(lastTouchTime)) {
    //   log('saving screen');
    //   _isSavingScreen.value = true;
    //   update();
    //   Get.offAllNamed(Routes.screenSaver);
    // }
  }

  startTimer() {
    // timer = Timer.periodic(const Duration(minutes: 1), (t) {
    //   checkForInactivity();
    // });
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
