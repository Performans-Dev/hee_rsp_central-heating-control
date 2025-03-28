// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/core/utils/byte.dart';
import 'package:central_heating_control/app/data/models/hardware.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/models/serial.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/message_handler.dart';
import 'package:central_heating_control/main.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:dio/dio.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';

//#region MARK: Constants
int temperatureRefreshDuration = 5000;
int temperatureCheckDuration = 1200;

int kMainBoardButtonPinCount = 4;
String inputChannelName = 'CHI {n}';
String outputChannelName = 'CHO {n}';
String inputAnalogChannelName = 'NTC {n}';
String buttonChannelName = 'BTN {n}';

int kMainBoardId = 0x00;
int startByte = 0x3A;
List<int> stopBytes = [0x0D, 0x0A];
String serialKey = '/dev/ttyS0';
int kSerialAcknowledgementDelay = 700;
int kSerialLoopDelay = 100;
//#endregion

class ChannelController extends GetxController {
  //#region MARK: Variables
  final SerialMessageHandler handler = SerialMessageHandler();
  late SerialPort serialPort;
  SerialPortConfig config = SerialPortConfig();
  late SerialPortReader serialPortReader;
  StreamSubscription<Uint8List>? messageSubscription;
  late StreamController<SerialQuery> serialQueryStreamController;
  late StreamController<String> logMessageController;
  // int _lastSensorDataFetch = 0;
  final StreamController<ChannelDefinition> _buttonStreamController =
      StreamController<ChannelDefinition>.broadcast();
  Stream<ChannelDefinition> get buttonStream => _buttonStreamController.stream;
  final Map<int, bool> _lastEmittedState = {};
  //#endregion

  //#region MARK: Lifecycle
  @override
  void onInit() {
    super.onInit();
    logMessageController = StreamController<String>.broadcast();
    registerSerialListener();
    runInitTasks();
  }

  @override
  void onReady() {
    //
    super.onReady();
  }

  @override
  void onClose() {
    closeAllRelays();
    disposeSerialPins();
    disposeGpioPins();
    serialQueryStreamController.close();
    logMessageController.close();
    messageSubscription?.cancel();
    _buttonStreamController.close();
    super.onClose();
  }

  Future<void> closeAllRelays() async {
    for (final pin in outputChannels) {
      setOutput(pin.pinIndex, false);
    }
    await sendOutputPackage();

    writeOE(true);
  }

  Future<void> runInitTasks() async {
    // Load hardware devices from DB
    await activateHardwares();
    await wait(100);

    // Initialize GPIO pins
    if (isPi) {
      initGpioPins();
    }

    await wait(10);
    // writeOE(false);
    // await wait(10);

    // Initialize Serial pins
    await initSerialPins();

    await wait(100);
    populateChannels();

    await wait(100);
    serialQueryStreamController = StreamController<SerialQuery>.broadcast();

    runGpioInputPolling();
    await wait(100);
    runSensorPolling();
    await wait(100);
    runSerialPolling();
  }
  //#endregion

  //#region MARK: Device List

  final RxList<Hardware> _hardwareList = <Hardware>[].obs;
  List<Hardware> get hardwareList => _hardwareList;

  Future<void> activateHardwares() async {
    final extList = await DbProvider.db.getHardwareDevices();
    _hardwareList.assignAll(extList);
    update();
    print("Hardware devices loaded {${_hardwareList.length}}");
  }

  //#endregion

  //#region ThermometerSensors
  final Rx<int> _ntcReadCount = 0.obs;
  int get ntcReadCount => _ntcReadCount.value;

  final Rx<double> _ntc1 = 0.0.obs;
  final Rx<double> _ntc2 = 0.0.obs;
  final Rx<double> _ntc3 = 0.0.obs;
  final Rx<double> _ntc4 = 0.0.obs;

  double get ntc1 => _ntc1.value;
  double get ntc2 => _ntc2.value;
  double get ntc3 => _ntc3.value;
  double get ntc4 => _ntc4.value;

  double get ntc1Value => adcReadNtc(ntc1);
  double get ntc2Value => adcReadNtc(ntc2);
  double get ntc3Value => adcReadNtc(ntc3);
  double get ntc4Value => adcReadNtc(ntc4);

  double adcReadNtc(double raw) {
    const double vcc = 5.0;
    const int rs = 10000;
    const double res = 0.0048828125; // 0.0009765625;
    double adcValue = 0;
    double vNtc = 0;
    double rNtc = 0;
    double tNtc = 0;
    const double a = 0.001129148;
    const double b = 0.000234125;
    const double c = 0.0000000876741;
    //
    adcValue = raw;
    vNtc = adcValue * res;
    rNtc = (rs * vNtc) / (vcc - vNtc);
    tNtc = log(rNtc);
    tNtc = 1 / (a + (b * tNtc) + (c * tNtc * tNtc * tNtc));
    tNtc = tNtc - 273.15;
    return tNtc;
  }
  //#endregion

  //#region MARK: GPIO Pins
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

  final RxBool _pinSerState = false.obs;
  final RxBool _pinSrclkState = false.obs;
  final RxBool _pinRclkState = false.obs;
  final RxBool _pinBuzzerState = false.obs;
  final RxBool _pinTxEnableState = false.obs;
  final RxBool _fanPinState = false.obs;
  final RxBool _pinUartModeTxState = false.obs;

  bool get pinSerState => _pinSerState.value;
  bool get pinSrclkState => _pinSrclkState.value;
  bool get pinRclkState => _pinRclkState.value;
  bool get pinBuzzerState => _pinBuzzerState.value;
  bool get pinTxEnableState => _pinTxEnableState.value;
  bool get fanPinState => _fanPinState.value;
  bool get pinUartModeTxState => _pinUartModeTxState.value;

  void initGpioPins() {
    try {
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
      print("GPIO pins initialized");
    } on Exception catch (e) {
      LogService.addLog(LogDefinition(
        message: e.toString(),
        type: LogType.error,
      ));
      print(e);
    }
  }
  //#endregion

  //#region MARK: Serial Pins
  Future<void> initSerialPins() async {
    print("Initializing serial pins");
    serialPort = SerialPort(serialKey);
    serialPort.openReadWrite();
    config.baudRate = 9600;
    config.bits = 8;
    config.parity = 0;
    config.stopBits = 1;
    config.setFlowControl(SerialPortFlowControl.none);
    serialPort.config = config;
    await wait(100);
    serialPortReader = SerialPortReader(serialPort);
    await wait(100);

    messageSubscription?.cancel();
    messageSubscription = serialPortReader.stream.listen(
      (Uint8List data) {
        logMessageController.add('<-- Serial: $data');
        handler.onDataReceived(data);
      },
      onError: (error) {
        logMessageController.add('<-- Serial error: $error');
        LogService.addLog(LogDefinition(
          message: 'Serial stream error: $error',
          type: LogType.error,
        ));
      },
      cancelOnError: false,
    );

    await wait(100);

    _allowSerialLoop.value = hardwareList.length > 1;
    update();
    print("Serial pins initialized");
  }

  void registerSerialListener() {
    print("Registering serial listener");
    handler.onMessage.listen(
      (Uint8List data) {
        List<int> rawData = ByteUtils.intListToUint8List(data);
        // Get the command byte
        int command = rawData[2];

        // Determine CRC data length based on command
        int crcDataLength;
        switch (command) {
          case 0xCA: // Serial number
            crcDataLength = 17; // deviceId + command + 14 bytes serial
            break;
          case 0xCB: // Hardware version
          case 0xCC: // Firmware version
            crcDataLength = 24; // deviceId + command + 21 bytes version
            break;
          default:
            crcDataLength = 5; // Normal command (deviceId + command + 2 args)
        }

        List<int> dataForCrc = rawData.sublist(1, crcDataLength);
        List<int> expectedCrcBytes =
            ByteUtils.getCrcBytes(ByteUtils.intListToUint8List(dataForCrc));
        List<int> receivedCrcBytes =
            rawData.sublist(crcDataLength, crcDataLength + 2).toList();
        if (receivedCrcBytes.toString() == expectedCrcBytes.toString()) {
          // CRC match
          parseSerialMessage(rawData);
        } else {
          // ignore invalid CRC
          logMessageController.add(
              '<-- Serial: CRC mismatch, expected: $expectedCrcBytes, received: $receivedCrcBytes');
        }
      },
      cancelOnError: false,
    );
  }
  //#endregion

  //#region MARK: Disposal
  void disposeSerialPins() {
    serialPortReader.close();
    serialPort.close();
    messageSubscription?.cancel();
  }

  void disposeGpioPins() {
    uartModeTx.write(false);
    outPinSER.write(false);
    outPinSRCLK.write(false);
    outPinRCLK.write(false);
    buzzer.write(false);
    fanPin.write(false);
    txEnablePin.write(false);
    //---
    uartModeTx.dispose();
    btn1.dispose();
    btn2.dispose();
    btn3.dispose();
    btn4.dispose();
    outPinSER.dispose();
    outPinSRCLK.dispose();
    outPinRCLK.dispose();
    buzzer.dispose();
    in1.dispose();
    in2.dispose();
    in4.dispose();
    in5.dispose();
    in6.dispose();
    in7.dispose();
    in8.dispose();
    txEnablePin.dispose();
  }
  //#endregion

  //#region MARK: Channels
  final RxList<ChannelDefinition> _inputChannels = <ChannelDefinition>[].obs;
  List<ChannelDefinition> get inputChannels => _inputChannels;

  final RxList<ChannelDefinition> _outputChannels = <ChannelDefinition>[].obs;
  List<ChannelDefinition> get outputChannels => _outputChannels;

  void populateChannels() {
    _inputChannels.clear();
    _outputChannels.clear();

    int id = 1000;

    int inputIndex = 0;
    int outputIndex = 0;
    int ntcIndex = 0;
    int btnIndex = 0;

    // OUTPUTS

    _outputChannels.add(ChannelDefinition(
      id: id,
      name: 'BUZZER',
      deviceId: 0x00,
      pinIndex: 1,
      type: PinType.buzzerOut,
      userSelectable: false,
    ));

    for (final d in hardwareList) {
      int digitalCount = d.doCount;

      for (int i = 1; i <= digitalCount; i++) {
        id++;
        outputIndex++;

        _outputChannels.add(ChannelDefinition(
          id: id,
          name: outputChannelName.replaceAll(
              '{n}', outputIndex.toString().padLeft(2, '0')),
          deviceId: d.deviceId,
          pinIndex: i,
          type: d.deviceId == kMainBoardId
              ? PinType.onboardPinOutput
              : PinType.uartPinOutput,
          userSelectable: true,
        ));
      }
    }
    // INPUTS

    id = 2000;

    for (final d in hardwareList) {
      int digitalCount = d.diCount;
      int analogCount = d.adcCount;
      int btnCount = d.deviceId == kMainBoardId ? kMainBoardButtonPinCount : 0;

      for (int i = 1; i <= digitalCount; i++) {
        id++;
        inputIndex++;
        _inputChannels.add(ChannelDefinition(
          id: id,
          name: inputChannelName.replaceAll(
              '{n}', inputIndex.toString().padLeft(2, '0')),
          deviceId: d.deviceId,
          pinIndex: i,
          type: d.deviceId == kMainBoardId
              ? PinType.onboardPinInput
              : PinType.uartPinInput,
          userSelectable: true,
        ));
      }
      for (int i = 1; i <= btnCount; i++) {
        id++;
        btnIndex++;
        _inputChannels.add(ChannelDefinition(
          id: id,
          name: buttonChannelName.replaceAll(
              '{n}', btnIndex.toString().padLeft(2, '0')),
          deviceId: d.deviceId,
          pinIndex: i,
          type: PinType.buttonPinInput,
          userSelectable: false,
        ));
        _lastEmittedState[id] = false;
      }
      for (int i = 1; i <= analogCount; i++) {
        id++;
        ntcIndex++;
        _inputChannels.add(ChannelDefinition(
          id: id,
          name: inputAnalogChannelName.replaceAll(
              '{n}', ntcIndex.toString().padLeft(2, '0')),
          deviceId: d.deviceId,
          pinIndex: i,
          type: d.deviceId == kMainBoardId
              ? PinType.onboardAnalogInput
              : PinType.uartAnalogInput,
          userSelectable: true,
        ));
      }
    }
    _inputChannels.sort((a, b) => a.name.compareTo(b.name));

    print(
        '------- channels initialized input: ${inputChannels.length} output: ${outputChannels.length}');
    update();

    for (final b in inputChannels
        .where((e) => e.deviceId == 0x00 && e.type == PinType.buttonPinInput)) {
      ever(_inputChannels, (_) {
        if (!b.status) {
          // button is pressed
          onBtnPressed(b.pinIndex);
        } else {
          // button is released
        }
      });
    }
  }

  // updateChannelValue(int id, double value) {}

  updateChannelState(int id, bool value) {
    try {
      _outputChannels.firstWhereOrNull((e) => e.id == id)?.status = value;
      update();
    } on Exception catch (e) {
      print('unable to find output channel id: $id');
      print(e);

      final DataController dc = Get.find();
      dc.addRunnerLog('unable to find output channel id: $id');
    }
  }

  bool getOutputChannelState({required int hwId, required int pinIndex}) {
    return outputChannels
            .firstWhereOrNull(
                (e) => e.deviceId == hwId && e.pinIndex == pinIndex)
            ?.status ??
        false;
  }
  //#endregion

  //#region MARK: SERIAL MESSAGES

  final RxBool _allowSerialLoop = true.obs;
  bool get allowSerialLoop => _allowSerialLoop.value;

  final RxBool _processingSerialLoop = false.obs;
  bool get processingSerialLoop => _processingSerialLoop.value;

  final Rxn<SerialMessage> _currentSerialMessage = Rxn<SerialMessage>();
  SerialMessage? get currentSerialMessage => _currentSerialMessage.value;

  final RxList<SerialMessage> _messageStack = <SerialMessage>[].obs;
  List<SerialMessage> get messageStack => _messageStack;

  void enableSerialTransmit() {
    txEnablePin.write(true);
    // logMessageController.add('enabling serial transmit');
  }

  void disableSerialTransmit() {
    txEnablePin.write(false);
    // logMessageController.add('disabling serial transmit');
  }

  Future<void> sendSerialMessage(SerialMessage m) async {
    List<int> message = m.toBytesWithCrc();
    Uint8List bytes = Uint8List.fromList(message);
    _currentSerialMessage.value = m;
    update();

    enableSerialTransmit();
    await wait(1);
    try {
      serialPort.write(bytes);
      logMessageController.add('--> ${ByteUtils.bytesToHex(bytes)}');
    } on Exception catch (e) {
      logMessageController.add('--> Serial: $e');
      LogService.addLog(
          LogDefinition(message: e.toString(), type: LogType.error));
    }
    await wait(1);
    disableSerialTransmit();
  }

  Future<void> sendSerialMessageFromStack() async {
    if (messageStack.isNotEmpty) {
      SerialMessage m = messageStack.removeAt(0);
      logMessageController
          .add('processing stack to Send Serial: \n${m.toLog()}');
      await sendSerialMessage(m);
    }
  }

  void addToSerialMessageStack(SerialMessage m) {
    _messageStack.add(m);
    update();
  }

  void turnOnSerialLoop() {
    logMessageController.add('turning on serial loop');
    _allowSerialLoop.value = true;
    update();
    runSerialPolling();
  }

  void turnOffSerialLoop() {
    logMessageController.add('turning off serial loop');
    _allowSerialLoop.value = false;
    _processingSerialLoop.value = false;
    update();
  }

  void parseSerialMessage(List<int> data) {
    final deviceId = data[1];
    final command = data[2];
    final number = data[3];
    final args = data[4];

    final m = SerialMessage(
      command: command,
      device: deviceId,
      index: number,
      arg: args,
    );

    if (currentSerialMessage != null &&
        currentSerialMessage!.command == m.command &&
        currentSerialMessage!.device == m.device &&
        currentSerialMessage!.index == m.index) {
      _currentSerialMessage.value = null;
      update();
      logMessageController.add('<-- Current Serial: clear }');
    }
    logMessageController.add('<-- Serial: \n${m.toLog()}');
    switch (command) {
      // update pin states

      case 0xCA: // Serial number query response
        serialNumberResponseReceived(Uint8List.fromList(data));
        break;

      case 0xCB: // Hardware version query response
        hardwareVersionResponseReceived(Uint8List.fromList(data));
        break;

      case 0xCC: // Firmware version query response
        firmwareVersionResponseReceived(Uint8List.fromList(data));
        break;
      default:
        break;
    }
  }

  void serialNumberResponseReceived(Uint8List message) {
    final int deviceId = message[1];
    // Extract serial number bytes (14 bytes after command byte)
    final List<int> serialNumberBytes = message.sublist(3, 17);
    final String asciiValue = _bytesToAscii(serialNumberBytes);
    serialQueryStreamController.add(SerialQuery(
        deviceId: deviceId,
        command: 0xCA,
        success: true,
        response: asciiValue));
  }

  void hardwareVersionResponseReceived(Uint8List message) {
    final int deviceId = message[1];
    // Extract hardware version bytes (21 bytes after command byte)
    final List<int> versionBytes = message.sublist(3, 24);
    final String asciiValue = _bytesToAscii(versionBytes);
    serialQueryStreamController.add(SerialQuery(
        deviceId: deviceId,
        command: 0xCB,
        success: true,
        response: asciiValue));
  }

  void firmwareVersionResponseReceived(Uint8List message) {
    final int deviceId = message[1];
    // Extract firmware version bytes (21 bytes after command byte)
    final List<int> versionBytes = message.sublist(3, 24);
    final String asciiValue = _bytesToAscii(versionBytes);
    serialQueryStreamController.add(SerialQuery(
        deviceId: deviceId,
        command: 0xCC,
        success: true,
        response: asciiValue));
  }

  Future<void> queryReboot(int id) async {
    logMessageController.add('Querying reboot');
    turnOnSerialLoop();

    addToSerialMessageStack(SerialMessage(device: id, command: 0x65));
  }

  Future<void> queryTest(int id) async {
    logMessageController.add('Querying test');
    turnOnSerialLoop();

    addToSerialMessageStack(
        SerialMessage(device: id, command: 0x64, index: 0xCC, arg: 0xBB));
    await waitForSerialResponse();
  }

  Future<void> querySerialNumber(int id) async {
    logMessageController.add('Querying serial number');
    turnOnSerialLoop();
    addToSerialMessageStack(
        SerialMessage(device: id, command: 0x64, index: 0xCC, arg: 0xBB));
    await waitForSerialResponse();
  }

  Future<void> queryModel(int id) async {
    logMessageController.add('Querying model');
    //
  }

  void runSerialPolling() async {
    if (processingSerialLoop) {
      // exit if already processing
      return;
    }
    _processingSerialLoop.value = true;
    update();

    /* final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastSensorDataFetch >= 30000) {
      _lastSensorDataFetch = now;
      final data = await getSensorData();
      if (data != null) {
        try {
          final s1 = data.sensors.firstWhere((e) => e.sensor == 4).rawValue;
          final s2 = data.sensors.firstWhere((e) => e.sensor == 5).rawValue;
          final s3 = data.sensors.firstWhere((e) => e.sensor == 6).rawValue;
          final s4 = data.sensors.firstWhere((e) => e.sensor == 7).rawValue;

          final id1 = inputChannels
              .firstWhere((e) =>
                  e.type == PinType.onboardAnalogInput && e.pinIndex == 1)
              .id;
          final id2 = inputChannels
              .firstWhere((e) =>
                  e.type == PinType.onboardAnalogInput && e.pinIndex == 2)
              .id;
          final id3 = inputChannels
              .firstWhere((e) =>
                  e.type == PinType.onboardAnalogInput && e.pinIndex == 3)
              .id;
          final id4 = inputChannels
              .firstWhere((e) =>
                  e.type == PinType.onboardAnalogInput && e.pinIndex == 4)
              .id;

          // Update pin states with sensor values
          updateChannelValue(id1, s1.toDouble());
          updateChannelValue(id2, s2.toDouble());
          updateChannelValue(id3, s3.toDouble());
          updateChannelValue(id4, s4.toDouble());
        } catch (e) {
          LogService.addLog(
              LogDefinition(message: e.toString(), type: LogType.error));
        }
      }
    } */

    for (final d in hardwareList) {
      if (d.deviceId != 0x00) {
        await sendSerialMessage(
            SerialMessage(device: d.deviceId, command: 0x69));
        await waitForSerialResponse();
        await sendSerialMessage(
            SerialMessage(device: d.deviceId, command: 0x67));
        await waitForSerialResponse();
        await sendSerialMessage(
            SerialMessage(device: d.deviceId, command: 0x70));
        await waitForSerialResponse();
      }
    }

    do {
      await sendSerialMessageFromStack();
      await waitForSerialResponse();
    } while (messageStack.isNotEmpty);

    _processingSerialLoop.value = false;
    update();

    await wait(kSerialLoopDelay);
    if (allowSerialLoop) {
      runSerialPolling();
    }
  }

  Future<void> waitForSerialResponse() async {
    if (messageStack.isNotEmpty && currentSerialMessage != null) {
      logMessageController.add(
          'Stack: ${messageStack.length}, Current: ${currentSerialMessage != null}');
    }
    if (currentSerialMessage == null) {
      // no message expected, no need to wait
      return;
    } else if (currentSerialMessage != null &&
        currentSerialMessage!.command == 0x65) {
      // restart device command cant send response
      await wait(kSerialAcknowledgementDelay);
      return;
    } else {
      // if (currentSerialMessage != null) {
      //   logMessageController.add('Waiting for serial response');
      // }
      int timeoutMillis = 0;
      final maxTimeout = currentSerialMessage!.command == 0x64 ? 10000 : 1000;
      do {
        timeoutMillis++;
        await wait(1);
        if (timeoutMillis >= maxTimeout) {
          _currentSerialMessage.value = null;
          update();
          logMessageController.add('... timeout');
          return;
        }
      } while (currentSerialMessage != null && timeoutMillis < maxTimeout);
    }
  }
  //#endregion

  //#region MARK: SENSOR POLLING
  Future<void> runSensorPolling() async {
    // final now = DateTime.now().millisecondsSinceEpoch;
    // if (now - _lastSensorDataFetch >= temperatureRefreshDuration) {
    //   _lastSensorDataFetch = now;
    //   update();

    final data = await readSensorData();
    if (data != null) {
      try {
        final sensor4 = data.sensors.firstWhere((e) => e.sensor == 4).rawValue;
        _inputChannels
            .firstWhere(
                (e) => e.type == PinType.onboardAnalogInput && e.pinIndex == 1)
            .analogValue = sensor4.toDouble();
        final sensor3 = data.sensors.firstWhere((e) => e.sensor == 5).rawValue;
        _inputChannels
            .firstWhere(
                (e) => e.type == PinType.onboardAnalogInput && e.pinIndex == 2)
            .analogValue = sensor3.toDouble();
        final sensor2 = data.sensors.firstWhere((e) => e.sensor == 6).rawValue;
        _inputChannels
            .firstWhere(
                (e) => e.type == PinType.onboardAnalogInput && e.pinIndex == 3)
            .analogValue = sensor2.toDouble();
        final sensor1 = data.sensors.firstWhere((e) => e.sensor == 7).rawValue;
        _inputChannels
            .firstWhere(
                (e) => e.type == PinType.onboardAnalogInput && e.pinIndex == 4)
            .analogValue = sensor1.toDouble();

        _ntc1.value = sensor1.toDouble();
        _ntc2.value = sensor2.toDouble();
        _ntc3.value = sensor3.toDouble();
        _ntc4.value = sensor4.toDouble();
        _ntcReadCount.value++;
        update();
      } on Exception catch (e) {
        print(e);
        Buzz.error();
      }
      // }

      Future.delayed(Duration(milliseconds: temperatureRefreshDuration), () {
        runSensorPolling();
      });
    }
  }
  //#endregion

  //#region MARK: GPIO INPUT POLLING
  void runGpioInputPolling() async {
    try {
      await sendOutputPackage();
    } on Exception catch (e) {
      final DataController dc = Get.find();
      dc.addRunnerLog('sendOutputPackage: $e');
    }

    try {
      for (var c in inputChannels
          .where((e) => e.deviceId == 0x00 && e.type == PinType.onboardPinInput)
          .toList()) {
        switch (c.pinIndex) {
          case 1:
            _inputChannels.firstWhere((e) => e.id == c.id).status = in1.read();
            break;
          case 2:
            _inputChannels.firstWhere((e) => e.id == c.id).status = in2.read();
            break;
          case 3:
            _inputChannels.firstWhere((e) => e.id == c.id).status = in3.read();
            break;
          case 4:
            _inputChannels.firstWhere((e) => e.id == c.id).status = in4.read();
            break;
          case 5:
            _inputChannels.firstWhere((e) => e.id == c.id).status = in5.read();
            break;
          case 6:
            _inputChannels.firstWhere((e) => e.id == c.id).status = in6.read();
            break;
          case 7:
            _inputChannels.firstWhere((e) => e.id == c.id).status = in7.read();
            break;
          case 8:
            _inputChannels.firstWhere((e) => e.id == c.id).status = in8.read();
            break;
        }
      }
      for (var c in inputChannels
          .where((e) => e.deviceId == 0x00 && e.type == PinType.buttonPinInput)
          .toList()) {
        switch (c.pinIndex) {
          case 1:
            _inputChannels.firstWhere((e) => e.id == c.id).status = btn1.read();
            break;
          case 2:
            _inputChannels.firstWhere((e) => e.id == c.id).status = btn2.read();
            break;
          case 3:
            _inputChannels.firstWhere((e) => e.id == c.id).status = btn3.read();
            break;
          case 4:
            _inputChannels.firstWhere((e) => e.id == c.id).status = btn4.read();
            break;
        }
      }
      update();
      for (var b in inputChannels
          .where((e) => e.deviceId == 0x00 && e.type == PinType.buttonPinInput)
          .toList()) {
        if (_lastEmittedState[b.id] != b.status) {
          _buttonStreamController.add(b);
          _lastEmittedState[b.id] = b.status;
        }
      }
    } on Exception catch (e) {
      print(e);
    }
    Future.delayed(
        const Duration(milliseconds: 100), () => runGpioInputPolling());
  }
  //#endregion

  //#region MARK: TOGGLE OUTPUT
  void toggleOutput(int device, int index) {
    if (device == 0x00) {
      toggleRelay(index);
    } else {
      // extension board
    }
  }

  void turnOffOutput(int device, int index) {
    if (device == 0x00) {
      turnOffRelay(index);
    } else {
      // extension board
    }
  }

  void turnOnOutput(int device, int index) {
    if (device == 0x00) {
      turnOnRelay(index);
    } else {
      // extension board
    }
  }

  void toggleRelay(int index) {
    ChannelDefinition c =
        outputChannels.firstWhere((e) => e.id == index && e.deviceId == 0x00);
    if (c.status) {
      turnOffRelay(c.id);
    } else {
      turnOnRelay(c.id);
    }
  }

  void turnOnRelay(int id) {
    ChannelDefinition c = outputChannels.firstWhere((e) => e.id == id);
    setOutput(c.pinIndex, true);
    _outputChannels.firstWhere((e) => e.id == id).status = true;
    update();
  }

  void turnOffRelay(int id) {
    ChannelDefinition c = outputChannels.firstWhere((e) => e.id == id);
    setOutput(c.pinIndex, false);
    _outputChannels.firstWhere((e) => e.id == id).status = false;
    update();
  }

  Future<void> sendOutputPackage() async {
    await wait(1);
    String temp = '';
    final list = outputChannels
        .where((e) =>
            e.deviceId == 0x00 &&
            e.type == PinType.onboardPinOutput &&
            e.userSelectable == true)
        .toList()
      ..sort((a, b) => b.pinIndex.compareTo(a.pinIndex));
    for (final c in list) {
      writeSER(c.status);
      await wait(1);
      writeSRCLK(true);
      await wait(1);
      writeSRCLK(false);
      await wait(1);
      temp += c.status ? '1' : '0';
    }
    await wait(1);
    writeRCLK(true);

    await wait(1);
    writeRCLK(false);

    await wait(1);
    writeOE(false);
    final DataController dc = Get.find();
    dc.addRunnerLog('sendOutputPackage: $temp');
  }

  void setOutput(int id, bool value) {
    final DataController dc = Get.find();
    dc.addRunnerLog('sendOutput($id, $value)');

    updateChannelState(id, value);
  }

  Future<void> sendOutput2(int index, bool value) async {
    for (int i = 8; i >= 1; i--) {
      writeSER(i == index
          ? value
          : getPinState(
              device: 0x00,
              number: (0x00 + i),
              type: PinType.onboardPinOutput,
            ));
      writeSRCLK(true);
      await wait(1);
      writeSRCLK(false);
      await wait(1);
    }
    await wait(1);
    writeRCLK(true);
    await wait(1);
    writeRCLK(false);
  }

  bool getPinState(
      {required int device, required int number, required PinType type}) {
    return outputChannels
        .firstWhere((e) =>
            e.deviceId == device && e.pinIndex == number && e.type == type)
        .status;
  }

  void writeOE(bool value) {
    try {
      txEnablePin.write(value);
    } on Exception catch (e) {
      print('writeOE: $e');
    }
  }

  String? writeSRCLK(bool value) {
    try {
      outPinSRCLK.write(value);
      return null;
    } on Exception catch (e) {
      return 'writeSRCLK: $e';
    }
  }

  String? writeRCLK(bool value) {
    try {
      outPinRCLK.write(value);
      return null;
    } on Exception catch (e) {
      return 'writeRCLK: $e';
    }
  }

  String? writeSER(bool value) {
    try {
      outPinSER.write(value);
      return null;
    } on Exception catch (e) {
      return 'writeSER: $e';
    }
  }
  //#endregion

  //#region MARK: Buzzer
  Future<void> buzz(BuzzerType t) async {
    try {
      switch (t) {
        case BuzzerType.mini:
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 10));
          buzzer.write(false);
          break;
        case BuzzerType.feedback:
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 20));
          buzzer.write(false);
          break;
        case BuzzerType.success:
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 100));
          buzzer.write(false);
          await Future.delayed(const Duration(milliseconds: 50));
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 100));
          buzzer.write(false);
          break;
        case BuzzerType.error:
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 500));
          buzzer.write(false);
          await Future.delayed(const Duration(milliseconds: 100));
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 500));
          buzzer.write(false);
          break;
        case BuzzerType.alarm:
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 1000));
          buzzer.write(false);
          await Future.delayed(const Duration(milliseconds: 100));
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 1000));
          buzzer.write(false);
          await Future.delayed(const Duration(milliseconds: 100));
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 1000));
          buzzer.write(false);
          break;
        case BuzzerType.lock:
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 100));
          buzzer.write(false);
          await Future.delayed(const Duration(milliseconds: 50));
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 100));
          buzzer.write(false);
          await Future.delayed(const Duration(milliseconds: 50));
          buzzer.write(true);
          await Future.delayed(const Duration(milliseconds: 100));
          buzzer.write(false);
          break;
        default:
          break;
      }
    } on Exception catch (e) {
      print(e);
    }
  }
  //#endregion

  //#region MARK: OnBtnPress
  void onBtnPressed(int index) {
    switch (index) {
      case 1:
        Buzz.mini();
        break;
      case 2:
        Buzz.success();
        break;
      case 3:
        Buzz.error();
        break;
      case 4:
        Buzz.alarm();
        break;
    }
  }
  //#endregion

  //#region MARK: Helper Functions
  Future<void> wait(int ms) async {
    await Future.delayed(Duration(milliseconds: ms));
  }

  Future<SensorData?> getSensorData() async {
    try {
      Dio dio = Dio();
      final response = await dio.get('http://localhost:5000/sensors');
      if (response.statusCode == 200) {
        return SensorData.fromMap(response.data);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  String _bytesToAscii(List<int> bytes) {
    return String.fromCharCodes(bytes).replaceAll(RegExp(r'[^\x20-\x7E]'), '?');
  }

  Future<SensorData?> readSensorData() async {
    try {
      Dio dio = Dio();
      final response = await dio.get('http://localhost:5000/sensors');
      if (response.statusCode == 200) {
        return SensorData.fromMap(response.data);
      } else {
        return null;
      }
    } on Exception catch (e) {
      print('Error getting sensor data: $e');
      return null;
    }
  }

  double getSensorValue(int id) {
    return inputChannels
            .firstWhereOrNull((e) =>
                (e.type == PinType.onboardAnalogInput ||
                    e.type == PinType.uartAnalogInput) &&
                e.pinIndex == id)
            ?.analogValue ??
        0.0;
  }
  //#endregion
}

// MARK: CHANNEL DEFINITION
class ChannelDefinition {
  int id; // starts with 1
  String name; // CH-O 1
  int deviceId; // 0x00
  int pinIndex; // 0x01
  PinType type; // digital input
  bool status;
  double? analogValue;
  bool userSelectable;
  ChannelDefinition({
    required this.id,
    required this.name,
    required this.deviceId,
    required this.pinIndex,
    required this.type,
    this.status = false,
    this.analogValue,
    this.userSelectable = false,
  });

  ChannelDefinition copyWith({
    int? id,
    String? name,
    int? deviceId,
    int? pinIndex,
    PinType? type,
    bool? status,
    double? analogValue,
    bool? userSelectable,
  }) {
    return ChannelDefinition(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceId: deviceId ?? this.deviceId,
      pinIndex: pinIndex ?? this.pinIndex,
      type: type ?? this.type,
      status: status ?? this.status,
      analogValue: analogValue ?? this.analogValue,
      userSelectable: userSelectable ?? this.userSelectable,
    );
  }

  @override
  String toString() {
    return 'ChannelDefinition(id: $id, name: $name, deviceId: $deviceId, pinIndex: $pinIndex, type: $type, status: $status, analogValue: $analogValue, userSelectable: $userSelectable)';
  }
}

// MARK: STATEValue
enum StateValue {
  off, //false
  on, //true
  loading, //null
}

/// MARK: PIN TYPE
enum PinType {
  none,
  onboardPinInput,
  uartPinInput,
  buttonPinInput,
  onboardPinOutput,
  uartPinOutput,
  buzzerOut,
  onboardAnalogInput,
  uartAnalogInput,
}

/// MARK: Sensor Data
class SensorData {
  int timestamp;
  List<Sensor> sensors;
  SensorData({
    required this.timestamp,
    required this.sensors,
  });

  SensorData copyWith({
    int? timestamp,
    List<Sensor>? sensors,
  }) {
    return SensorData(
      timestamp: timestamp ?? this.timestamp,
      sensors: sensors ?? this.sensors,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'sensors': sensors.map((x) => x.toMap()).toList(),
    };
  }

  factory SensorData.fromMap(Map<String, dynamic> map) {
    return SensorData(
      timestamp: map['timestamp']?.toInt() ?? 0,
      sensors: List<Sensor>.from(map['sensors']?.map((x) => Sensor.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SensorData.fromJson(String source) =>
      SensorData.fromMap(json.decode(source));

  @override
  String toString() => 'SensorData(timestamp: $timestamp, sensors: $sensors)';
}

// MARK: SENSOR
class Sensor {
  int sensor;
  int rawValue;
  Sensor({
    required this.sensor,
    required this.rawValue,
  });

  Sensor copyWith({
    int? sensor,
    int? rawValue,
  }) {
    return Sensor(
      sensor: sensor ?? this.sensor,
      rawValue: rawValue ?? this.rawValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sensor': sensor,
      'raw_value': rawValue,
    };
  }

  factory Sensor.fromMap(Map<String, dynamic> map) {
    return Sensor(
      sensor: map['sensor']?.toInt() ?? 0,
      rawValue: map['raw_value']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sensor.fromJson(String source) => Sensor.fromMap(json.decode(source));

  @override
  String toString() => 'Sensor(sensor: $sensor, raw_value: $rawValue)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Sensor &&
        other.sensor == sensor &&
        other.rawValue == rawValue;
  }

  @override
  int get hashCode => sensor.hashCode ^ rawValue.hashCode;
}

// MARK: SERIAL QUERY
class SerialQuery {
  int deviceId;
  int command; // limited to TestSignal, GetSerialNumber, GetModelNumber,
  bool? success;
  String? response;
  SerialQuery({
    required this.deviceId,
    required this.command,
    this.success,
    this.response,
  });
}
