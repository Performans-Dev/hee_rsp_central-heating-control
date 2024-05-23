import 'dart:async';

import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:get/get.dart';

class GpioController extends GetxController {
  Timer? timer;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  @override
  void onReady() {
    initOutPins();
    initInPins();
    initBtnPins();
    initBuzzer();
    super.onReady();
  }

  @override
  void onClose() {
    timer?.cancel();
    for (final item in outGpios) {
      item.dispose();
    }
    super.onClose();
  }

  final RxBool _timerFlag = false.obs;
  bool get timerFlag => _timerFlag.value;

  // final Rx<GPIO> _gpio = GPIO.advanced(5, config).obs;
  // GPIO get gpio => _gpio.value;

  final RxList<GPIO> _outGpios = <GPIO>[].obs;
  List<GPIO> get outGpios => _outGpios;

  final RxList<bool> _outStates = <bool>[].obs;
  List<bool> get outStates => _outStates;

  final RxList<GPIO> _inGpios = <GPIO>[].obs;
  List<GPIO> get inGpios => _inGpios;

  final RxList<bool> _inStates = <bool>[].obs;
  List<bool> get inStates => _inStates;

  final RxList<GPIO> _btnGpios = <GPIO>[].obs;
  List<GPIO> get btnGpios => _btnGpios;

  final RxList<bool> _btnStates = <bool>[].obs;
  List<bool> get btnStates => _btnStates;

  final Rxn<GPIO> _buzzerPin = Rxn();
  GPIO? get buzzerPin => _buzzerPin.value;

  void initOutPins() {
    _outGpios.assignAll(
        UiData.outPins.map((e) => GPIO(e, GPIOdirection.gpioDirOut)));
    _outStates.assignAll(UiData.outPins.map((e) => false).toList());
    update();
  }

  void initInPins() {
    _inGpios
        .assignAll(UiData.inPins.map((e) => GPIO(e, GPIOdirection.gpioDirIn)));
    _inStates.assignAll(UiData.inPins.map((e) => false).toList());
    update();
  }

  void initBtnPins() {
    _btnGpios
        .assignAll(UiData.btnPins.map((e) => GPIO(e, GPIOdirection.gpioDirIn)));
    _btnStates.assignAll(UiData.btnPins.map((e) => false).toList());
    update();
  }

  void initBuzzer() {
    _buzzerPin.value = GPIO(
        UiData.ports
            .firstWhere((element) => element.group == GpioGroup.buzzer)
            .pinNumber
            .index,
        GPIOdirection.gpioDirOut);
    update();
  }

  void onOutTap(int index) {
    _outStates[index] = !outStates[index];
    outGpios[index].write(_outStates[index]);
    update();
  }

  void readInputs() {
    for (int i = 0; i < inStates.length; i++) {
      final result = inGpios[i].read();
      _inStates[i] = result;
    }
    for (int i = 0; i < btnStates.length; i++) {
      final result = btnGpios[i].read();
      _btnStates[i] = result;
    }
    _timerFlag.value = !timerFlag;
    update();
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) => readInputs(),
    );
  }

  Future<void> buzz(BuzzerType t) async {
    if (buzzerPin == null) {
      return;
    }
    switch (t) {
      case BuzzerType.feedback:
        buzzerPin?.write(true);
        await Future.delayed(Duration(milliseconds: 20));
        buzzerPin?.write(false);
        break;
      case BuzzerType.success:
        buzzerPin?.write(true);
        await Future.delayed(Duration(milliseconds: 100));
        buzzerPin?.write(false);
        await Future.delayed(Duration(milliseconds: 50));
        buzzerPin?.write(true);
        await Future.delayed(Duration(milliseconds: 100));
        buzzerPin?.write(false);
        break;
      case BuzzerType.error:
        buzzerPin?.write(true);
        await Future.delayed(Duration(milliseconds: 500));
        buzzerPin?.write(false);
        await Future.delayed(Duration(milliseconds: 100));
        buzzerPin?.write(true);
        await Future.delayed(Duration(milliseconds: 500));
        buzzerPin?.write(false);
        break;
      default:
        break;
    }
  }
}
