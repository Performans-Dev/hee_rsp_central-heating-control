import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:central_heating_control/app/core/utils/byte.dart';
import 'package:central_heating_control/app/data/models/hardware_extension.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/models/serial.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:central_heating_control/app/data/services/message_handler.dart';
import 'package:central_heating_control/main.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:dio/dio.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';

int kMainBoardDigitalOutputPinCount = 8;
int kExtBoardDigitalOutputPinCount = 6;
int kMainBoardDigitalInputPinCount = 8;
int kExtBoardDigitalInputPinCount = 6;
int kMainBoardAnalogInputPinCount = 4;
int kExtBoardAnalogInputPinCount = 1;
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

class StateController extends GetxController {
  final SerialMessageHandler handler = SerialMessageHandler();
  late SerialPort serialPort;
  SerialPortConfig config = SerialPortConfig();
  late SerialPortReader serialPortReader;
  StreamSubscription<Uint8List>? messageSubscription;
  late StreamController<SerialQuery> serialQueryStreamController;
  late StreamController<String> logMessageController;
  int _lastSensorDataFetch = 0;

  //#region MARK: Super
  @override
  void onInit() {
    super.onInit();
    logMessageController = StreamController<String>.broadcast();
    runInitTasks();
  }

  @override
  void onReady() {
    //
    super.onReady();
  }

  @override
  void onClose() {
    disposeSerialPins();
    disposeGpioPins();
    serialQueryStreamController.close();
    logMessageController.close();
    messageSubscription?.cancel();
    super.onClose();
  }

  Future<void> runInitTasks() async {
    await activateHardwares();
    await wait(100);
    if (isPi) {
      initGpioPins();
    }
    await wait(100);

    await initSerialPins();

    await wait(100);
    populateChannels();

    await wait(100);
    serialQueryStreamController = StreamController<SerialQuery>.broadcast();
  }
  //#endregion

  //#region MARK: Device List

  final RxList<HardwareExtension> _hardwareList = <HardwareExtension>[].obs;
  List<HardwareExtension> get hardwareList => _hardwareList;

  // final RxList<int> _deviceIds = <int>[].obs;
  // List<int> get deviceIds => _deviceIds;

  Future<void> activateHardwares() async {
    final extList = await DbProvider.db.getHardwareExtensions();
    _hardwareList.assignAll(extList);

    // for (final ext in extList) {
    //   _deviceIds.add(0x00 + ext.id);
    // }
    update();
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
    } on Exception catch (e) {
      LogService.addLog(LogDefinition(
        message: e.toString(),
        type: LogType.error,
      ));
    }
  }
  //#endregion

  //#region MARK: Serial Pins
  Future<void> initSerialPins() async {
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

    await wait(100);

    _allowSerialLoop.value = hardwareList.length > 1;
    update();

    runSerialLoop();
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

  //#region MARK: Global States
  /// Onboard
  /// 8 digital input
  /// 8 digital output
  /// 4 analog input
  /// 4 button
  /// 1 buzzer
  ///
  /// serial extension (0-30)
  /// 6 digital input
  /// 6 digital output
  /// 1 analog ntc input
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

  updateChannelState(int id, bool value) {}
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
  }

  void disableSerialTransmit() {
    txEnablePin.write(false);
  }

  Future<void> sendSerialMessage(SerialMessage m) async {
    List<int> message = m.toBytesWithCrc();
    Uint8List bytes = Uint8List.fromList(message);
    _currentSerialMessage.value = m;
    update();
    logMessageController.add('--> Current Serial: \n${m.toLog()}');

    enableSerialTransmit();
    await wait(1);
    try {
      serialPort.write(bytes);
      logMessageController.add('--> Serial: $bytes');
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
    _allowSerialLoop.value = true;
    update();
    runSerialLoop();
  }

  void turnOffSerialLoop() {
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
    //
    _processingSerialLoop.value = true;
    update();

    final now = DateTime.now().millisecondsSinceEpoch;
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
    }

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
    logMessageController.add(
        'Stack: ${messageStack.length}, Current: ${currentSerialMessage != null}');
    if (currentSerialMessage == null) {
      // no message expected, no need to wait
      return;
    } else if (currentSerialMessage != null &&
        currentSerialMessage!.command == 0x65) {
      // restart device command cant send response
      await wait(kSerialAcknowledgementDelay);
      return;
    } else {
      if (currentSerialMessage != null) {
        logMessageController.add('Waiting for serial response');
      }
      int timeoutMillis = 0;
      const maxTimeout = 1000;
      do {
        timeoutMillis++;
        await wait(1);
        if (timeoutMillis >= maxTimeout) {
          _currentSerialMessage.value = null;
          update();
          logMessageController.add(
              'Timeout waiting for serial response, clear current serial message');
          return;
        }
      } while (currentSerialMessage != null &&
          timeoutMillis < kSerialAcknowledgementDelay);
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
  //#endregion
}

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
