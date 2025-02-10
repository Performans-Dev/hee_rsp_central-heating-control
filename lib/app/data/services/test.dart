import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:get/get.dart';

class TestController extends GetxController {
  late GPIO uartModeTx;
  late GPIO btn1;
  late GPIO btn2;
  late GPIO btn3;
  late GPIO btn4;
  late GPIO outPinSER;
  late GPIO outPinSRCLK;
  late GPIO outPinRCLK;
  late GPIO buzzer;
  late GPIO fanPin;
  late GPIO in1;
  late GPIO in2;
  late GPIO in3;
  late GPIO in4;
  late GPIO in5;
  late GPIO in6;
  late GPIO in7;
  late GPIO in8;
  late GPIO txEnablePin;

  int _lastSensorDataFetch = 0;

  @override
  void onInit() {
    super.onInit();
    init();
  }
  //

  init() async {
    _deviceIds.clear();
    _deviceIds.assignAll([0x00]);
    update();

    uartModeTx = GPIO(4, GPIOdirection.gpioDirOut);
    btn1 = GPIO(17, GPIOdirection.gpioDirIn);
    btn2 = GPIO(18, GPIOdirection.gpioDirIn);
    btn3 = GPIO(27, GPIOdirection.gpioDirIn);
    btn4 = GPIO(22, GPIOdirection.gpioDirIn);
    outPinSER = GPIO(23, GPIOdirection.gpioDirOut);
    outPinSRCLK = GPIO(24, GPIOdirection.gpioDirOut);
    outPinRCLK = GPIO(25, GPIOdirection.gpioDirOut);
    buzzer = GPIO(0, GPIOdirection.gpioDirOut);
    in1 = GPIO(5, GPIOdirection.gpioDirIn);
    in2 = GPIO(6, GPIOdirection.gpioDirIn);
    in3 = GPIO(12, GPIOdirection.gpioDirIn);
    in4 = GPIO(13, GPIOdirection.gpioDirIn);
    in5 = GPIO(19, GPIOdirection.gpioDirIn);
    in6 = GPIO(16, GPIOdirection.gpioDirIn);
    in7 = GPIO(26, GPIOdirection.gpioDirIn);
    in8 = GPIO(20, GPIOdirection.gpioDirIn);
    txEnablePin = GPIO(21, GPIOdirection.gpioDirOut);
    txEnablePin.write(true);

    await wait(100);

    _pinStates.clear();
    for (final i in [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]) {
      _pinStates.add(PinState(
        device: 0x00,
        number: i,
        status: false,
        type: PinType.onboardPinInput,
        pin: getInputPinByNumber(i),
      ));
      _pinStates.add(PinState(
        device: 0x00,
        number: i,
        status: false,
        type: PinType.onboardPinOutput,
      ));
    }

    for (final i in [0x01, 0x02, 0x03, 0x04]) {
      _pinStates.add(PinState(
        device: 0x00,
        number: i,
        type: PinType.onboardAnalogInput,
      ));
      _pinStates.add(PinState(
        device: 0x00,
        number: i,
        type: PinType.buttonPinInput,
        pin: getButtonPinByNumber(i),
      ));
    }
    update();

    await wait(100);
  }

  final RxList<int> _deviceIds = <int>[].obs;
  List<int> get deviceIds => _deviceIds;

  final RxList<PinState> _pinStates = <PinState>[].obs;
  List<PinState> get pinStates => _pinStates;
  List<PinState> getPinStates({
    int? device,
    int? number,
    PinType? type,
  }) =>
      pinStates
          .where((e) =>
              (device == null ? true : e.device == device) &&
              (number == null ? true : e.number == number) &&
              (type == null ? true : e.type == type))
          .toList();

  void updatePinState(PinState ps) {
    int index = pinStates.indexWhere((p) =>
        p.device == ps.device && p.number == ps.number && p.type == ps.type);
    if (index != -1) {
      _pinStates[index].status = ps.status;
      _pinStates[index].value = ps.value;
      update();
    }
  }

  bool getPinState(
      {required int device, required int number, required PinType type}) {
    return pinStates
        .firstWhere(
            (e) => e.device == device && e.number == number && e.type == type)
        .status;
  }

  double? getPinValue(
      {required int device, required int number, required PinType type}) {
    return pinStates
        .firstWhere(
            (e) => e.device == device && e.number == number && e.type == type)
        .value;
  }

  GPIO? getInputPinByNumber(int a) {
    switch (a) {
      case 0x01:
        return in1;
      case 0x02:
        return in2;
      case 0x03:
        return in3;
      case 0x04:
        return in4;
      case 0x05:
        return in5;
      case 0x06:
        return in6;
      case 0x07:
        return in7;
      case 0x08:
        return in8;
    }
    return null;
  }

  GPIO? getButtonPinByNumber(int a) {
    switch (a) {
      case 0x01:
        return btn1;
      case 0x02:
        return btn2;
      case 0x03:
        return btn3;
      case 0x04:
        return btn4;
    }
    return null;
  }

  Future<void> wait(int ms) async =>
      await Future.delayed(Duration(milliseconds: ms));
}

class PinState {
  int device;
  int number;
  PinType type;
  bool status;
  double value;
  String? description;
  GPIO? pin;
  PinState({
    required this.device,
    required this.number,
    required this.type,
    this.status = false,
    this.value = 0.0,
    this.description,
    this.pin,
  });
}
