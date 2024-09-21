import 'dart:async';
import 'dart:typed_data';

import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/models/serial.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:central_heating_control/app/data/services/message_handler.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';
import 'package:rpi_spi/rpi_spi.dart';

class GpioController extends GetxController {
  Timer? timer;
  int startByte = 0x3A;
  List<int> stopBytes = [0x0D, 0x0A];
  SerialMessageHandler handler = SerialMessageHandler();
  late StreamController serialMessageStreamController;

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
      serialMessageStreamController =
          StreamController<SerialMessage>.broadcast();
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
    serialPort?.dispose();
    serialMessageStreamController.close();
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
      case BuzzerType.lock:
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 100));
        buzzerPin?.write(false);
        await Future.delayed(const Duration(milliseconds: 50));
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 100));
        buzzerPin?.write(false);
        await Future.delayed(const Duration(milliseconds: 50));
        buzzerPin?.write(true);
        await Future.delayed(const Duration(milliseconds: 100));
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
  final Rxn<SerialPort> _serialPort = Rxn();
  SerialPort? get serialPort => _serialPort.value;

  void initSerial() {
    try {
      final portName = SerialPort.availablePorts.first;
      _serialPort.value = SerialPort(portName);
      update();
      serialPort!.openReadWrite();
      serialPort!.config.baudRate = 9600;
      serialPort!.config.bits = 8;
      serialPort!.config.parity = SerialPortParity.none;
      serialPort!.config.stopBits = 1;
      serialPort!.config.xonXoff = 0;
      serialPort!.config.rts = 1;
      serialPort!.config.cts = 0;
      serialPort!.config.dsr = 0;
      serialPort!.config.dtr = 1;
      handler.onMessage.listen((Uint8List message) {
        List<int> data = CommonUtils.intListToUint8List(message);
        int crcInt =
            CommonUtils.serialUartCrc16(CommonUtils.intListToUint8List([
          data[1],
          data[2],
          data[3],
          data[4],
        ]));
        List<int> crcBytes = CommonUtils.getCrcBytes(crcInt);
        if (crcBytes[0] == data[5] && crcBytes[1] == data[6]) {
          onSerialMessageReceived(CommonUtils.uint8ListToIntList(message));
        }
      });
    } on Exception catch (e) {
      LogService.addLog(
          LogDefinition(message: e.toString(), type: LogType.error));
      Buzz.alarm();
    }
  }

  Future<void> txOpen() async {
    try {
      var serialPin = outGpios.firstWhere((e) => e.line == 4);
      serialPin.write(true);
      await Future.delayed(const Duration(milliseconds: 10));
    } on Exception catch (e) {
      LogService.addLog(
          LogDefinition(message: e.toString(), type: LogType.error));
    }
  }

  Future<void> txClose() async {
    try {
      var serialPin = outGpios.firstWhere((e) => e.line == 4);
      serialPin.write(false);
      await Future.delayed(const Duration(milliseconds: 10));
    } on Exception catch (e) {
      LogService.addLog(
          LogDefinition(message: e.toString(), type: LogType.error));
    }
  }

  void onSerialMessageReceived(List<int> message) {
    SerialMessage m = SerialMessage(
      deviceId: message[1],
      command: message[2],
      data1: message[3],
      data2: message[4],
    );
    int crcInt = CommonUtils.serialUartCrc16(
        CommonUtils.intListToUint8List(m.toBytes()));
    List<int> crcBytes = CommonUtils.getCrcBytes(crcInt);
    if (crcBytes[0] == message[5] && crcBytes[1] == message[6]) {
      serialMessageStreamController.add(m);
    }
  }

  List<int> buildSerialMessage({
    required int id,
    required SerialCommand command,
    int data1 = 0x00,
    int data2 = 0x00,
  }) {
    final cycByteData =
        CommonUtils.intListToUint8List([id, command.value, data1, data2]);
    final crcInt = CommonUtils.serialUartCrc16(cycByteData);
    final crcBytes = CommonUtils.getCrcBytes(crcInt);
    return [
      startByte,
      id,
      command.value,
      data1,
      data2,
      ...crcBytes,
      ...stopBytes,
    ];
  }

  void sendSerialMessage(List<int> message) async {
    Uint8List data = Uint8List.fromList(message);
    await txOpen();
    serialPort!.write(data);
    await Future.delayed(const Duration(milliseconds: 10));
    await txClose();
    LogService.addLog(LogDefinition(
        message: 'SerialSent: $message', type: LogType.sendSerialEvent));
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
