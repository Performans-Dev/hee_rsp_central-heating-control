import 'dart:convert';

import 'package:dart_periphery/dart_periphery.dart';
import 'package:get/get.dart';

import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/providers/log.dart';

import 'package:central_heating_control/main.dart';

int kMainBoardDigitalPinCount = 8;
int kExtBoardDigitalPinCount = 6;
int kMainBoardId = 0x00;
int startByte = 0x3A;
List<int> stopBytes = [0x0D, 0x0A];
String serialKey = '/dev/ttyS0';
int kSerialAcknowledgementDelay = 700;
int kSerialLoopDelay = 100;
String inputChannelName = 'CHI {n}';
String outputChannelName = 'CHO {n}';

enum StateValue {
  off, //false
  on, //true
  loading, //null
}

class StateController extends GetxController {
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
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> runInitTasks() async {
    await activateHardwares();
    await wait(100);
    if (isPi) {
      initGpioPins();
    }
    await wait(100);
    populateChannels();

    await wait(100);
  }
  //#endregion

  //#region MARK: Device List
  final RxList<int> _deviceIds = <int>[].obs;
  List<int> get deviceIds => _deviceIds;

  Future<void> activateHardwares() async {
    // TODO:
    // add 0x00
    // look up database
    // for each extension in db, add device id
    // will implement it later
    // for testing purposes just adding to 0x02
    _deviceIds.assignAll([0x00, 0x01, 0x02]);
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

    int indexCount = 0;
    for (final d in deviceIds) {
      int digitalCount = d == kMainBoardId
          ? kMainBoardDigitalPinCount
          : kExtBoardDigitalPinCount;
      for (int i = 1; i <= digitalCount; i++) {
        indexCount++;
        final cdo = ChannelDefinition(
          index: indexCount,
          name: inputChannelName.replaceAll(
              '{n}', indexCount.toString().padLeft(2, '0')),
          deviceId: d,
          pinIndex: i,
          type: PinType.digitalOutput,
        );
        _outputChannels.add(cdo);
        final cdi = ChannelDefinition(
          index: indexCount,
          name: outputChannelName.replaceAll(
              '{n}', indexCount.toString().padLeft(2, '0')),
          deviceId: d,
          pinIndex: i,
          type: PinType.digitalInput,
        );
        _inputChannels.add(cdi);
      }
    }
    update();
  }
  //#endregion

  //#region MARK: Helper Functions
  Future<void> wait(int ms) async {
    await Future.delayed(Duration(milliseconds: ms));
  }
  //#endregion
}

class StateDefinition {
  int deviceId; // 0x00 mainboard, 0x01 serial 1, 0x02 serial 2 ... (max 30)
  bool isDefined; // true if defined, false if not, ignore when false.
  StateValue value; // required for digital input
  double? analogValue; // required for analog input
  int pinIndex; // (starts with 1)
  StateDefinition({
    required this.deviceId,
    required this.isDefined,
    required this.value,
    this.analogValue,
    required this.pinIndex,
  });
}

class ChannelDefinition {
  int index; // starts with 1
  String name; // CH-O 1
  int deviceId; // 0x00
  int pinIndex; // 0x01
  PinType type; // digital input
  ChannelDefinition({
    required this.index,
    required this.name,
    required this.deviceId,
    required this.pinIndex,
    required this.type,
  });

  ChannelDefinition copyWith({
    int? index,
    String? name,
    int? deviceId,
    int? pinIndex,
    PinType? type,
  }) {
    return ChannelDefinition(
      index: index ?? this.index,
      name: name ?? this.name,
      deviceId: deviceId ?? this.deviceId,
      pinIndex: pinIndex ?? this.pinIndex,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return 'ChannelDefinition(index: $index, name: $name, deviceId: $deviceId, pinIndex: $pinIndex, type: $type)';
  }
}

class StateModel {
  int hwId;
  int pinIndex;
  PinType pinType;
  HardwareType hardwareType;
  bool pinValue;
  double? analogValue;
  String? title;
  StateModel({
    this.hwId = 0,
    this.pinIndex = 0,
    this.pinType = PinType.none,
    this.hardwareType = HardwareType.none,
    this.pinValue = false,
    this.analogValue = 0.0,
    this.title,
  });
}

/// MARK: PIN TYPE
enum PinType {
  none,
  digitalInput,
  digitalOutput,
  analogInput,
  analogOutput,
}

/// MARK: HARDWARE TYPE
enum HardwareType {
  none,
  onboardPin,
  uartPin,
  buttonPin,
}
