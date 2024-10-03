import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/gpio.dart';
import 'package:get/get.dart';

class StateController extends GetxController {
  final RxList<StateModel> _stateList = <StateModel>[].obs;
  List<StateModel> get stateList => _stateList;
  List<StateModel> get extensionStateList =>
      stateList.where((e) => e.hwId > 0).toList();

  List<int> get stateDeviceIds => stateList.map((e) => e.hwId).toSet().toList();

  List<HardwareType> hardwareTypes({required int hwId}) => stateList
      .where((e) => e.hwId == hwId)
      .map((e) => e.hardwareType)
      .toSet()
      .toList();

  List<PinType> pinTypes({
    required int hwId,
    required HardwareType hardwareType,
  }) =>
      stateList
          .where((e) => e.hardwareType == hardwareType && e.hwId == hwId)
          .map((e) => e.pinType)
          .toSet()
          .toList();

  List<StateModel> getStateList({
    required int hwId,
    required HardwareType hardwareType,
    required PinType pinType,
  }) =>
      stateList
          .where((e) =>
              e.hardwareType == hardwareType &&
              e.pinType == pinType &&
              e.hwId == hwId)
          .toList();

  bool getPinValue({required int hwId, required int pinIndex}) {
    return stateList
            .firstWhereOrNull((e) => e.hwId == hwId && e.pinIndex == pinIndex)
            ?.pinValue ??
        false;
  }

  double getAnalogValue({required int hwId, required int pinIndex}) {
    return stateList
            .firstWhereOrNull((e) => e.hwId == hwId && e.pinIndex == pinIndex)
            ?.analogValue ??
        0.0;
  }

  void updatePinValue(
      {required int hwId, required int pinIndex, required bool value}) {
    final index =
        stateList.indexWhere((e) => e.hwId == hwId && e.pinIndex == pinIndex);
    if (index > -1) {
      stateList[index].pinValue = value;
    }
    update();
  }

  void updateAnalogValue(
      {required int hwId, required int pinIndex, required double value}) {
    final index =
        stateList.indexWhere((e) => e.hwId == hwId && e.pinIndex == pinIndex);
    if (index > -1) {
      stateList[index].analogValue = value;
    }
    update();
  }

  Future<void> populateList() async {
    final GpioController gpioController = Get.find();
    final DataController dataController = Get.find();
    _stateList.clear();
    for (final item in gpioController.inGpios) {
      StateModel model = StateModel(
        hwId: 0,
        pinIndex: item.line,
        pinType: PinType.digitalInput,
        hardwareType: HardwareType.onboardPin,
        pinValue: false,
        title: 'Pin ${item.line}',
      );
      _stateList.add(model);
    }

    for (final item in gpioController.btnGpios) {
      StateModel model = StateModel(
        hwId: 0,
        pinIndex: item.line,
        pinType: PinType.digitalInput,
        hardwareType: HardwareType.buttonPin,
        pinValue: false,
        title: 'Button ${item.line}',
      );
      _stateList.add(model);
    }

    for (var i = 1; i < 9; i++) {
      StateModel model = StateModel(
        hwId: 0,
        pinIndex: i,
        pinType: PinType.digitalOutput,
        hardwareType: HardwareType.onboardPin,
        pinValue: false,
        title: 'Pin $i',
      );
      _stateList.add(model);
    }

    for (final item in dataController.hardwareExtensionList) {
      for (var i = 0; i < item.diCount; i++) {
        StateModel model = StateModel(
          hwId: item.id,
          pinIndex: i,
          pinType: PinType.digitalInput,
          hardwareType: HardwareType.uartPin,
          pinValue: false,
          title: 'DI $i',
        );
        _stateList.add(model);
      }

      for (var i = 0; i < item.doCount; i++) {
        StateModel model = StateModel(
          hwId: item.id,
          pinIndex: i,
          pinType: PinType.digitalOutput,
          hardwareType: HardwareType.uartPin,
          pinValue: false,
          title: 'DO $i',
        );
        _stateList.add(model);
      }

      for (var i = 0; i < item.adcCount; i++) {
        StateModel model = StateModel(
          hwId: item.id,
          pinIndex: i,
          pinType: PinType.analogOutput,
          hardwareType: HardwareType.uartPin,
          pinValue: false,
          title: 'ADC $i',
        );
        _stateList.add(model);
      }

      for (var i = 0; i < item.dacCount; i++) {
        StateModel model = StateModel(
          hwId: item.id,
          pinIndex: i,
          pinType: PinType.analogInput,
          hardwareType: HardwareType.uartPin,
          pinValue: false,
          title: 'DAC $i',
        );
        _stateList.add(model);
      }
    }

    update();
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

enum PinType {
  none,
  digitalInput,
  digitalOutput,
  analogInput,
  analogOutput,
}

enum HardwareType {
  none,
  onboardPin,
  uartPin,
  buttonPin,
}
