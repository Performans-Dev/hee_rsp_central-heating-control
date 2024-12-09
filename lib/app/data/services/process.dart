import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/process.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:get/get.dart';

class ProcessController extends GetxController {
  final RxList<ZoneProcess> _zoneProcessList = <ZoneProcess>[].obs;
  List<ZoneProcess> get zoneProcessList => _zoneProcessList;

  final RxList<HeaterProcess> _heaterProcessList = <HeaterProcess>[].obs;
  List<HeaterProcess> get heaterProcessList => _heaterProcessList;

  initZone(ZoneDefinition z) async {
    final heaters = z.heaters;
    if (!zoneProcessList.map((e) => e.zone.id).contains(z.id)) {
      _zoneProcessList.add(ZoneProcess(
        zone: z,
        selectedState: HeaterState.off,
        hasThermostat: false,
        hasSensor: z.sensors.isNotEmpty,
        desiredTemperature: 200,
        currentTemperature: 0,
        lastHeartbeat: DateTime.now(),
      ));
    } else {
      _zoneProcessList.firstWhere((e) => e.zone.id == z.id).zone = z;
    }

    update();
    for (final heater in heaters) {
      initHeater(heater);
    }
  }

  sortZoneList() {
    _zoneProcessList.sort((a, b) => a.zone.name
        .toLowerCase()
        .withoutDiacriticalMarks
        .compareTo(b.zone.name.toLowerCase().withoutDiacriticalMarks));
    update();
  }

  initHeater(HeaterDevice h) {
    if (!heaterProcessList.map((e) => e.heater.id).contains(h.id)) {
      _heaterProcessList.add(HeaterProcess(
        heater: h,
        selectedState: HeaterState.off,
        hasThermostat: false,
        desiredTemperature: 200,
        currentLevel: 0,
        inputSignal: true,
        lastHeartbeat: DateTime.now(),
      ));
    } else {
      _heaterProcessList.firstWhere((e) => e.heater.id == h.id).heater = h;
    }
    update();
  }

  void onZoneStateCalled({required int zoneId, required HeaterState state}) {
    var z = zoneProcessList.firstWhere((e) => e.zone.id == zoneId);
    z.selectedState = state;
    _zoneProcessList.removeWhere((e) => e.zone.id == zoneId);
    _zoneProcessList.add(z);
    update();
    sortZoneList();
  }

  void onZoneThermostatOptionCalled(
      {required int zoneId, required bool value}) {
    var z = zoneProcessList.firstWhere((e) => e.zone.id == zoneId);
    z.hasThermostat = value;
    _zoneProcessList.removeWhere((e) => e.zone.id == zoneId);
    _zoneProcessList.add(z);
    update();
    sortZoneList();
  }

  void onZoneThermostatDecreased({required int zoneId}) async {
    var z = zoneProcessList.firstWhere((e) => e.zone.id == zoneId);
    z.desiredTemperature = z.desiredTemperature - 10;
    _zoneProcessList.removeWhere((e) => e.zone.id == zoneId);
    _zoneProcessList.add(z);
    update();
    sortZoneList();
  }

  void onZoneThermostatIncreased({required int zoneId}) async {
    var z = zoneProcessList.firstWhere((e) => e.zone.id == zoneId);
    z.desiredTemperature = z.desiredTemperature + 10;
    _zoneProcessList.removeWhere((e) => e.zone.id == zoneId);
    _zoneProcessList.add(z);
    update();
    sortZoneList();
  }
}
