// ignore_for_file: avoid_print

import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:get/get.dart';

class GpioController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    populateDeviceIds();

    initGpioPins();
    await wait(100);

    populatePinStatuses();
    await wait(100);

    resetOutputs();
    await wait(100);

    //enable output
    print('enabling OE');
    writeOE(true);
    await wait(100);
    print('enabled OE');

    runGpioInputPolling();
  }

  //#region MARK: States

  final RxBool _buzzerState = false.obs;
  bool get buzzerState => _buzzerState.value;

  //

  final RxBool _pinUartModeTxState = false.obs;
  bool get pinUartModeTxState => _pinUartModeTxState.value;

  //

  final RxBool _spiMisoState = false.obs;
  bool get spiMisoState => _spiMisoState.value;

  //

  final RxBool _outOEState = false.obs;
  bool get outOEState => _outOEState.value;

  final RxBool _outSRCLKState = false.obs;
  bool get outSRCLKState => _outSRCLKState.value;

  final RxBool _outRCLKState = false.obs;
  bool get outRCLKState => _outRCLKState.value;

  final RxBool _outSERState = false.obs;
  bool get outSERState => _outSERState.value;

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
  //#endregion

  //#region MARK: Devices
  final RxList<int> _deviceIds = <int>[].obs;
  List<int> get deviceIds => _deviceIds;

  void populateDeviceIds() {
    final DataController dc = Get.find();
    _deviceIds.clear();
    _deviceIds.assignAll(dc.hardwareDeviceList.map((e) => e.deviceId));
    _deviceIds.toSet().toList().sort();
    update();
  }
  //#endregion

  //#region MARK: GPIO
  late GPIO uartModeTx;
  late GPIO btn1;
  late GPIO btn2;
  late GPIO btn3;
  late GPIO btn4;
  late GPIO outPinSER;
  late GPIO outPinSRCLK;
  // late GPIO outPinMOSI;
  // late GPIO inPinMISO;
  late GPIO outPinRCLK;
  // late GPIO outPinSCLK;
  late GPIO buzzer;
  // late GPIO outPinCS;
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

  void initGpioPins() {
    // (1) 3V3 power
    // (2) 5V power
    // (3) GPIO 2 - TOUCHSCREEN
    // (4) 5V power
    // (5) GPIO 3 - TOUCHSCREEN
    // (6) Ground
    // (7) GPIO 4 - UART TxEnable
    try {
      uartModeTx = GPIO(4, GPIOdirection.gpioDirOut);
    } on Exception catch (e) {
      print('init GPIO 4: $e');
    }
    // (8) GPIO 14 - UART TX
    // (9) Ground
    // (10) GPIO 15 - UART RX
    // (11) GPIO 17 - BTN 1
    try {
      btn1 = GPIO(17, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 17: $e');
    }
    // (12) GPIO 18 - BTN 2
    try {
      btn2 = GPIO(18, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 18: $e');
    }

    // (13) GPIO 27 - BTN 3
    try {
      btn3 = GPIO(27, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 27: $e');
    }
    // (14) Ground
    // (15) GPIO 22 - BTN 4
    try {
      btn4 = GPIO(22, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 22: $e');
    }
    // (16) GPIO 23 - SER out
    try {
      outPinSER = GPIO(23, GPIOdirection.gpioDirOut);
    } on Exception catch (e) {
      print('init GPIO 23: $e');
    }
    // (17) 3V3 power
    // (18) GPIO 24 - SRCLK out
    try {
      outPinSRCLK = GPIO(24, GPIOdirection.gpioDirOut);
    } on Exception catch (e) {
      print('init GPIO 24: $e');
    }
    // (19) GPIO 10 - MOSI spi
    // try {
    //   outPinMOSI = GPIO(10, GPIOdirection.gpioDirOut);
    // } on Exception catch (e) {
    //   addLog('init GPIO 10: $e');
    // }
    // (20) Ground
    // (21) GPIO 9 - MISO spi
    // try {
    //   inPinMISO = GPIO(9, GPIOdirection.gpioDirIn);
    // } on Exception catch (e) {
    //   addLog('init GPIO 9: $e');
    // }
    // (22) GPIO 25 - RCLK out
    try {
      outPinRCLK = GPIO(25, GPIOdirection.gpioDirOut);
    } on Exception catch (e) {
      print('init GPIO 25: $e');
    }
    // (23) GPIO 11 - SCLK spi
    // try {
    //   outPinSCLK = GPIO(11, GPIOdirection.gpioDirOut);
    // } on Exception catch (e) {
    //   addLog('init GPIO 11: $e');
    // }
    // (24) GPIO 8 - CS spi
    // try {
    //   outPinCS = GPIO(8, GPIOdirection.gpioDirOut);
    // } on Exception catch (e) {
    //   addLog('init GPIO 8: $e');
    // }
    // (25) Ground
    // (26) GPIO 7 - FAN
    // try {
    //   GPIOconfig config = GPIOconfig.defaultValues();
    //   config.direction = GPIOdirection.gpioDirOut;
    //   fanPin = GPIO.advanced(7, config);
    // } on Exception catch (e) {
    //   addLog('init GPIO 7: $e');
    // }
    // (27) GPIO 0 - BUZZER
    try {
      buzzer = GPIO(0, GPIOdirection.gpioDirOut);
    } on Exception catch (e) {
      print('init GPIO 0: $e');
    }
    // (28) GPIO 1 ??
    // (29) GPIO 5 - DI-1
    try {
      in1 = GPIO(5, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 5: $e');
    }
    // (30) Ground
    // (31) GPIO 6 - DI-2
    try {
      in2 = GPIO(6, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 6: $e');
    }
    // (32) GPIO 12 - DI-3
    try {
      in3 = GPIO(12, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 12: $e');
    }
    // (33) GPIO 13 - DI-4
    try {
      in4 = GPIO(13, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 13: $e');
    }
    // (34) Ground
    // (35) GPIO 19 - DI-5
    try {
      in5 = GPIO(19, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 19: $e');
    }
    // (36) GPIO 16 - DI-6
    try {
      in6 = GPIO(16, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 16: $e');
    }
    // (37) GPIO 26 - DI-7
    try {
      in7 = GPIO(26, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 26: $e');
    }
    // (38) GPIO 20 - DI-8
    try {
      in8 = GPIO(20, GPIOdirection.gpioDirIn);
    } on Exception catch (e) {
      print('init GPIO 20: $e');
    }
    // (39) Ground
    // (40) GPIO 21 - OE out
    try {
      txEnablePin = GPIO(21, GPIOdirection.gpioDirOut);
      writeOE(false);
    } on Exception catch (e) {
      print('init GPIO 21: $e');
    }
  }

  void writeOE(bool value) {
    try {
      txEnablePin.write(value);
      _outOEState.value = value;
      update();
    } on Exception catch (e) {
      print('writeOE: $e');
    }
  }

  void writeSRCLK(bool value) {
    try {
      outPinSRCLK.write(value);
      _outSRCLKState.value = value;
      update();
    } on Exception catch (e) {
      print('writeSRCLK: $e');
    }
  }

  void writeRCLK(bool value) {
    try {
      outPinRCLK.write(value);
      _outRCLKState.value = value;
      update();
    } on Exception catch (e) {
      print('writeRCLK: $e');
    }
  }

  void writeSER(bool value) {
    try {
      outPinSER.write(value);
      _outSERState.value = value;
      update();
    } on Exception catch (e) {
      print('writeSER: $e');
    }
  }
  //#endregion

  //#region MARK: PinStatuses
  Future<void> populatePinStatuses() async {
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
    // for (final de in deviceIds) {
    //   for (final i in [0x01, 0x02, 0x03, 0x04, 0x05, 0x06]) {
    //     _pinStates.add(PinState(
    //       device: de,
    //       number: i,
    //       type: PinType.digitalInput,
    //     ));
    //     _pinStates.add(PinState(
    //       device: de,
    //       number: i,
    //       type: PinType.digitalOutput,
    //     ));
    //   }
    //   _pinStates.add(PinState(
    //     device: de,
    //     number: 0x01,
    //     type: PinType.analogInput,
    //   ));
    // }
    update();
    await wait(100);
  }

  Future<void> resetOutputs() async {
    await wait(1);
    for (int i = 1; i <= 8; i++) {
      writeSER(false);
      await wait(1);
      writeSRCLK(true);
      await wait(1);
      writeSRCLK(false);
      await wait(1);
    }
    writeRCLK(true);
    await wait(1);
    writeRCLK(false);
    await wait(1);
    print('Reset GPIO outputs completed');
  }
  //#endregion

  //#region MARK: Input Polling
  void runGpioInputPolling() {
    try {
      for (PinState item in pinStates.where((e) => e.pin != null)) {
        item.status = !item.pin!.read();
        updatePinState(item);
      }
    } on Exception catch (e) {
      print(e.toString());
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      runGpioInputPolling();
    });
  }

  //#endregion

  //#region MARK: onOutTap
  void onOutTap(int outPinNumber) {
    print('onOutTapped($outPinNumber)');
    // var ps = getPinStates(
    //         device: 0x00, type: PinType.onboardPinOutput, number: outPinNumber)
    //     .first;
    // ps.status = !ps.status;

    bool newValue = !(_pinStates
        .firstWhere((e) =>
            e.number == outPinNumber &&
            e.device == 0x00 &&
            e.type == PinType.onboardPinOutput)
        .status);

    _pinStates
        .firstWhere((e) =>
            e.number == outPinNumber &&
            e.device == 0x00 &&
            e.type == PinType.onboardPinOutput)
        .status = newValue;
    update();
    print('updated outPinState as pin: $outPinNumber,  value: $newValue');
    sendOutput2();
  }

  Future<void> sendOutput2() async {
    var data = pinStates
        .where((e) => e.device == 0x00 && e.type == PinType.onboardPinOutput)
        .toList()
        .toSet()
        .toList();
    data.sort((a, b) => a.number - b.number);
    String dataString = '';

    for (final item in data) {
      writeSER(item.status);
      dataString += item.status ? '1' : '0';
      await wait(1);
      writeSRCLK(true);
      await wait(1);
      writeSRCLK(false);
      await wait(1);
    }
    writeRCLK(true);
    await wait(1);
    writeRCLK(false);
    await wait(1);

    print('wrote data $dataString');
    // writeOE(true);
  }

  Future<void> sendOutput(int index, bool value) async {
    for (int i = 1; i <= 8; i++) {
      writeSER(i == index
          ? value
          : getPinState(
              device: 0x00,
              number: (0x00 + i),
              type: PinType.onboardPinOutput));
      await wait(1);
      writeSRCLK(true);
      await wait(1);
      writeSRCLK(false);
      await wait(1);
    }
    writeRCLK(true);
    await wait(1);
    writeRCLK(false);
    await wait(1);
  }
  //#endregion

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
