import 'dart:async';

import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rpi_spi/rpi_spi.dart';

class GpioController extends GetxController {
  Timer? timer;

  // String serialKey = '/dev/ttyUSB0';
  String serialKey = '/dev/ttyS0';
  // String serialKey = '/dev/serial0';

  @override
  void onInit() {
    if (GetPlatform.isLinux) {
      startTimer();
    }
    super.onInit();
  }

  @override
  void onReady() {
    if (GetPlatform.isLinux) {
      initOutPins();
      initInPins();
      initBtnPins();
      initBuzzer();
      initSerial();
      initSpi();
    }
    super.onReady();
  }

  @override
  void onClose() {
    timer?.cancel();
    for (final item in outGpios) {
      item.dispose();
    }
    spi?.dispose();
    serial?.dispose();
    super.onClose();
  }

  final RxBool _timerFlag = false.obs;
  bool get timerFlag => _timerFlag.value;

  // final Rx<GPIO> _gpio = GPIO.advanced(5, config).obs;
  // GPIO get gpio => _gpio.value;

  //MARK: GPIO in-out
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

  //MARK: BUZZER
  Future<void> buzz(BuzzerType t) async {
    if (buzzerPin == null) {
      return;
    }
    switch (t) {
      case BuzzerType.mini:
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 10));
        buzzerPin?.write(false);
        break;
      case BuzzerType.feedback:
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 20));
        buzzerPin?.write(false);
        break;
      case BuzzerType.success:
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 100));
        buzzerPin?.write(false);
        await Future.delayed(const Duration(milliseconds: 50));
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 100));
        buzzerPin?.write(false);
        break;
      case BuzzerType.error:
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 500));
        buzzerPin?.write(false);
        await Future.delayed(const Duration(milliseconds: 100));
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 500));
        buzzerPin?.write(false);
        break;
      case BuzzerType.alarm:
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 1000));
        buzzerPin?.write(false);
        await Future.delayed(const Duration(milliseconds: 100));
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 1000));
        buzzerPin?.write(false);
        await Future.delayed(const Duration(milliseconds: 100));
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 1000));
        buzzerPin?.write(false);
        break;
      default:
        break;
    }
  }

  //MARK: RELAY
  final Rx<bool> _oeState = false.obs;
  bool get oeState => _oeState.value;
  final Rx<bool> _srclkState = false.obs;
  bool get srclkState => _srclkState.value;
  final Rx<bool> _rclkState = false.obs;
  bool get rclkState => _rclkState.value;
  final Rx<bool> _serState = false.obs;
  bool get serState => _serState.value;

  final Rx<String> _log = ''.obs;
  String get log => _log.value;

  Future<void> openRelays(bool value) async {
    _log.value = 'function start';
    update();
    var oe = outGpios[3];
    var srclk = outGpios[1];
    var rclk = outGpios[2];
    var ser = outGpios[0];
    _log.value += '\ndefined';
    update();

    oe.write(true);
    _oeState.value = true;
    _log.value += '\noe: $oeState ';
    update();
    ser.write(value);
    _serState.value = value;
    _log.value += '\nser: $serState ';
    update();
    for (int i = 0; i < 8; i++) {
      srclk.write(true);
      _srclkState.value = true;
      _log.value += '\nsrclk: $srclkState ';
      update();
      await Future.delayed(const Duration(milliseconds: 1));
      srclk.write(false);
      _srclkState.value = false;
      _log.value += '\nsrclk: $srclkState ';
      update();
      await Future.delayed(const Duration(milliseconds: 1));
    }

    rclk.write(true);
    _rclkState.value = true;
    _log.value += '\nrclk: $rclkState ';
    update();
    await Future.delayed(const Duration(milliseconds: 1));
    rclk.write(false);
    _rclkState.value = false;
    _log.value += '\nrclk: $rclkState ';
    update();
    await Future.delayed(const Duration(milliseconds: 1));

    oe.write(false);
    _oeState.value = false;
    _log.value += '\noe: $oeState ';
    update();

    _log.value += '\nfunction end';
    update();

    buzz(BuzzerType.feedback);
  }

  //MARK: SERIAL UART
  final Rxn<Serial> _serial = Rxn();
  Serial? get serial => _serial.value;

  final Rx<String> _serialLog = ''.obs;
  String get serialLog => _serialLog.value;

  void initSerial() {
    try {
      Serial s = Serial(serialKey, Baudrate.b9600);
      s.setBaudrate(Baudrate.b9600);
      s.setParity(Parity.parityNone);
      s.setDataBits(DataBits.db8);

      _serial.value = s;
      update();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Buzz.alarm();
    }
  }

  Future<void> serialSend(String text, {String? message}) async {
    Buzz.mini();
    if (serial == null) {
      _serialLog.value = 'no-device';
      update();
      return;
    }

    if (message == null || message.isEmpty) {
      message = DateTime.now().toIso8601String();
    }

    var serialPin = outGpios.firstWhere((e) => e.line == 4);

    serialPin.write(true);
    await Future.delayed(const Duration(milliseconds: 100));
    serial?.writeString(message);
    await Future.delayed(const Duration(milliseconds: 100));
    serialPin.write(false);
    await Future.delayed(const Duration(milliseconds: 100));
    Buzz.mini();

    _serialLog.value = message;
    update();
  }

  Future<String?> serialReceive() async {
    Buzz.mini();
    String message = '';
    if (serial == null) return null;
    var bytes = 0;
    try {
      for (int i = 0; i < 50; i++) {
        bytes = serial!.getInputWaiting();
        if (bytes > 0) break;
        await (Future.delayed(const Duration(milliseconds: 100)));
      }

      if (bytes > 0) {
        SerialReadEvent event = serial!.read(bytes, 5000);
        message = event.toString();
      } else {
        message = 'no message received';
      }
    } on Exception catch (e) {
      message = e.toString();
    }
    Buzz.mini();
    _serialLog.value += message;
    update();

    return message;
  }

  //MARK: SPI
  final Rx<String> _spiLog = 'idle'.obs;
  String get spiLog => _spiLog.value;

  final Rxn<RpiSpi> _spi = Rxn();
  RpiSpi? get spi => _spi.value;

  void initSpi() {
    _spi.value = RpiSpi();
    _spiLog.value = 'SPI ready';
    update();
  }

  Future<void> readSpiSensor() async {
    /*  if (spi == null) return;
    buzz(BuzzerType.feedback);
    // final Mcp3008 mcp3008 = Mcp3008(spi!, 0, 24);
    String response = '';
    StringBuffer out;
    response += 'Read analog values from MCP3008 channels 0 - 7:';

    response += '      | Channel';
    out = StringBuffer('      ');
    for (var channel = 0; channel < 8; ++channel) {
      out.write('| ${channel.toString().padLeft(4)} ');
    }
    response += out.toString();
    response += '-' * 63;

    for (var count = 1; count <= 10; ++count) {
      await Future.delayed(const Duration(seconds: 1));
      out = StringBuffer(' ${count.toString().padLeft(4)} ');
      for (var channel = 0; channel < 8; ++channel) {
        var value = mcp3008.read(channel);
        out.write('| ${value.toString().padLeft(4)} ');
      }
      response += out.toString();
      await Future.delayed(Duration(milliseconds: 10));
    }
    _spiLog.value = response;
    update();
    buzz(BuzzerType.success); */
  }
}
