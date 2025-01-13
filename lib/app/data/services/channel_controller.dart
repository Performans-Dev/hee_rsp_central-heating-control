// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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
  int _lastSensorDataFetch = 0;
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
    super.onClose();
  }

  void closeAllRelays() async {
    for (final pin in outputChannels) {
      await sendOutput(pin.pinIndex, false);
    }
  }

  Future<void> runInitTasks() async {
    // Load hardware devices from DB
    await activateHardwares();
    await wait(100);

    // Initialize GPIO pins
    if (isPi) {
      initGpioPins();
    }
    await wait(100);
    runGpioInputPolling();

    readObSensorData();

    // Initialize Serial pins
    await initSerialPins();

    await wait(100);
    populateChannels();

    await wait(100);
    serialQueryStreamController = StreamController<SerialQuery>.broadcast();

    runSerialLoop();
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
      in4 = GPIO(13, GPIOdirection.gpioDirIn);
      in5 = GPIO(19, GPIOdirection.gpioDirIn);
      in6 = GPIO(16, GPIOdirection.gpioDirIn);
      in7 = GPIO(26, GPIOdirection.gpioDirIn);
      in8 = GPIO(20, GPIOdirection.gpioDirIn);
      txEnablePin = GPIO(21, GPIOdirection.gpioDirOut);
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
    update();
  }

  updateChannelValue(int id, double value) {}

  updateChannelState(int id, bool value) {
    _outputChannels.firstWhere((e) => e.id == id).status = value;
    update();
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
    runSerialLoop();
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

  void runSerialLoop() async {
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
      runSerialLoop();
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
  void readObSensorData() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastSensorDataFetch >= 30000) {
      _lastSensorDataFetch = now;
      final data = await readSensorData();
      if (data != null) {
        try {
          final sensor1 =
              data.sensors.firstWhere((e) => e.sensor == 4).rawValue;
          _inputChannels
              .firstWhere((e) =>
                  e.type == PinType.onboardAnalogInput && e.pinIndex == 1)
              .analogValue = sensor1.toDouble();
          final sensor2 =
              data.sensors.firstWhere((e) => e.sensor == 5).rawValue;
          _inputChannels
              .firstWhere((e) =>
                  e.type == PinType.onboardAnalogInput && e.pinIndex == 2)
              .analogValue = sensor2.toDouble();
          final sensor3 =
              data.sensors.firstWhere((e) => e.sensor == 6).rawValue;
          _inputChannels
              .firstWhere((e) =>
                  e.type == PinType.onboardAnalogInput && e.pinIndex == 3)
              .analogValue = sensor3.toDouble();
          final sensor4 =
              data.sensors.firstWhere((e) => e.sensor == 7).rawValue;
          _inputChannels
              .firstWhere((e) =>
                  e.type == PinType.onboardAnalogInput && e.pinIndex == 4)
              .analogValue = sensor4.toDouble();
          update();
        } on Exception catch (e) {
          print(e);
        }
      }
    }
  }
  //#endregion

  //#region MARK: GPIO INPUT POLLING
  void runGpioInputPolling() {
    try {
      for (var c in inputChannels.where((e) => e.deviceId == 0x00).toList()) {
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

        _pinSerState.value = outPinSER.read();
        _pinSrclkState.value = outPinSRCLK.read();
        _pinRclkState.value = outPinRCLK.read();
        _pinTxEnableState.value = txEnablePin.read();
        _pinBuzzerState.value = buzzer.read();
        _fanPinState.value = fanPin.read();
        _pinUartModeTxState.value = uartModeTx.read();

        update();
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

  Future<void> turnOnRelay(int id) async {
    ChannelDefinition c = outputChannels.firstWhere((e) => e.id == id);
    await sendOutput(c.pinIndex, true);
    _outputChannels.firstWhere((e) => e.id == id).status = true;
    update();
  }

  Future<void> turnOffRelay(int id) async {
    ChannelDefinition c = outputChannels.firstWhere((e) => e.id == id);
    await sendOutput(c.pinIndex, false);
    _outputChannels.firstWhere((e) => e.id == id).status = false;
    update();
  }

  Future<void> sendOutput(int index, bool value) async {
    final DataController dc = Get.find();
    dc.addRunnerLog('sendOutput($index, $value)');
    writeOE(false);
    await wait(1);
    writeOE(false);
    await wait(1);
    for (int i = 1; i <= 8; i++) {
      writeSER(i == index
          ? value
          : outputChannels
              .firstWhere((e) => e.deviceId == 0x00 && e.pinIndex == i)
              .status);
      writeSRCLK(true);
      await wait(1);
      writeSRCLK(false);
      await wait(1);
    }
    await wait(1);
    writeRCLK(true);
    await wait(1);
    writeRCLK(false);
    await wait(1);
    writeOE(true);
  }

  void writeOE(bool value) {
    try {
      txEnablePin.write(value);
    } on Exception catch (e) {
      print('writeOE: $e');
    }
  }

  void writeSRCLK(bool value) {
    try {
      outPinSRCLK.write(value);
    } on Exception catch (e) {
      print('writeSRCLK: $e');
    }
  }

  void writeRCLK(bool value) {
    try {
      outPinRCLK.write(value);
    } on Exception catch (e) {
      print('writeRCLK: $e');
    }
  }

  void writeSER(bool value) {
    try {
      outPinSER.write(value);
    } on Exception catch (e) {
      print('writeSER: $e');
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
