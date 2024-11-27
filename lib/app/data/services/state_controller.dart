import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:central_heating_control/app/core/utils/byte.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/message_handler.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:dio/dio.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';

import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/providers/log.dart';

import 'package:central_heating_control/main.dart';

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
  int _lastSensorDataFetch = 0;

  //#region MARK: Super
  @override
  void onInit() {
    super.onInit();
    runInitTasks();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    disposeSerialPins();
    disposeGpioPins();
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
  }
  //#endregion

  //#region MARK: Device List
  final RxList<int> _deviceIds = <int>[].obs;
  List<int> get deviceIds => _deviceIds;

  Future<void> activateHardwares() async {
    final extList = await DbProvider.db.getHardwareExtensions();
    _deviceIds.add(0x00);
    for (final ext in extList) {
      _deviceIds.add(0x00 + ext.id);
    }
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
        handler.onDataReceived(data);
      },
      onError: (error) {
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
        List<int> dataForCrc = rawData.sublist(1, 5);
        List<int> expectedCrcBytes =
            ByteUtils.getCrcBytes(ByteUtils.intListToUint8List(dataForCrc));
        List<int> receivedCrcBytes = rawData.sublist(5, 7).toList();
        if (receivedCrcBytes.toString() == expectedCrcBytes.toString()) {
          // CRC match
          parseSerialMessage(rawData);
        }
      },
      cancelOnError: false,
    );

    await wait(100);

    if (deviceIds.length > 1) {
      runSerialLoop();
    }
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

    // OUTPUTS

    _outputChannels.add(ChannelDefinition(
      id: 1000,
      name: 'BUZZER',
      deviceId: 0x00,
      pinIndex: 1,
      type: PinType.buzzerOut,
      userSelectable: false,
    ));

    for (final d in deviceIds) {
      int digitalCount = d == kMainBoardId
          ? kMainBoardDigitalOutputPinCount
          : kExtBoardDigitalOutputPinCount;

      for (int i = 1; i <= digitalCount; i++) {
        id++;

        _outputChannels.add(ChannelDefinition(
          id: id,
          name: inputChannelName.replaceAll('{n}', id.toString()),
          deviceId: d,
          pinIndex: i,
          type: d == kMainBoardId
              ? PinType.onboardPinOutput
              : PinType.uartPinOutput,
          userSelectable: true,
        ));
      }
    }
    // INPUTS

    id = 2000;

    for (final d in deviceIds) {
      int digitalCount = d == kMainBoardId
          ? kMainBoardDigitalInputPinCount
          : kExtBoardDigitalInputPinCount;
      int analogCount = d == kMainBoardId
          ? kMainBoardAnalogInputPinCount
          : kExtBoardAnalogInputPinCount;
      int btnCount = d == kMainBoardId ? kMainBoardButtonPinCount : 0;

      for (int i = 1; i <= digitalCount; i++) {
        id++;
        _inputChannels.add(ChannelDefinition(
          id: id,
          name: outputChannelName.replaceAll('{n}', id.toString()),
          deviceId: d,
          pinIndex: i,
          type: d == kMainBoardId
              ? PinType.onboardPinInput
              : PinType.uartPinInput,
          userSelectable: true,
        ));
      }
      for (int i = 1; i <= btnCount; i++) {
        id++;
        _inputChannels.add(ChannelDefinition(
          id: id,
          name: buttonChannelName.replaceAll('{n}', id.toString()),
          deviceId: d,
          pinIndex: i,
          type: PinType.buttonPinInput,
          userSelectable: false,
        ));
      }
      for (int i = 1; i <= analogCount; i++) {
        id++;
        _inputChannels.add(ChannelDefinition(
          id: id,
          name: inputAnalogChannelName.replaceAll('{n}', id.toString()),
          deviceId: d,
          pinIndex: i,
          type: d == kMainBoardId
              ? PinType.onboardAnalogInput
              : PinType.uartAnalogInput,
          userSelectable: true,
        ));
      }
    }

    update();
  }

  updateChannelValue(int id, double value) {}

  updateChannelState(int id, bool value) {}
  //#endregion

  //#region MARK: SERIAL MESSAGES
  final RxBool _processingSerialLoop = false.obs;
  bool get processingSerialLoop => _processingSerialLoop.value;

  void parseSerialMessage(List<int> data) {
    //TODO: parse serial message
  }

  void runSerialLoop() async {
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
