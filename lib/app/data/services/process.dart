import 'dart:math' as math;

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/process.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:get/get.dart';

class ProcessController extends GetxController {
  final RxList<ZoneProcess> _zoneProcessList = <ZoneProcess>[].obs;
  List<ZoneProcess> get zoneProcessList => _zoneProcessList;

  final RxList<HeaterProcess> _heaterProcessList = <HeaterProcess>[].obs;
  List<HeaterProcess> get heaterProcessList => _heaterProcessList;

  void initZone(ZoneDefinition z) async {
    final heaters = z.heaters;
    if (!zoneProcessList.map((e) => e.zone.id).contains(z.id)) {
      _zoneProcessList.add(ZoneProcess(
        zone: z,
        currentState: HeaterState.off,
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
        currentState: HeaterState.off,
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
    z.currentState = state;
    _zoneProcessList.removeWhere((e) => e.zone.id == zoneId);
    _zoneProcessList.add(z);
    update();
    sortZoneList();
  }

  void onHeaterStateCalled(
      {required int heaterId, required HeaterState state}) {
    var h = heaterProcessList.firstWhere((e) => e.heater.id == heaterId);
    h.currentState = state;
    _heaterProcessList.removeWhere((e) => e.heater.id == heaterId);
    _heaterProcessList.add(h);
    update();
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

  //MARK: POLLING

  final RxBool _isPolling = false.obs;
  bool get isPolling => _isPolling.value;

  Future<void> queryZoneStates() async {
    if (isPolling) {
      return;
    }
    _isPolling.value = true;
    update();

    for (final zone in zoneProcessList) {
      await queryZoneState(zone);
    }

    _isPolling.value = false;
    update();
  }

  Future<void> queryZoneState(ZoneProcess zone) async {
    HeaterState? stateToApply;
    if (zone.hasWeeklyPlan) {
      final planDetailList =
          await DbProvider.db.getPlanDetails(planId: zone.zone.selectedPlan);
      final planDetail = planDetailList.firstWhereOrNull((e) =>
          e.day == DateTime.now().weekday && e.hour == DateTime.now().hour);
      if (planDetail != null) {
        stateToApply = HeaterState.off;
      } else {
        if (planDetail!.hasThermostat == 1) {
          stateToApply = HeaterState.values[planDetail.level];
        } else {
          if (zone.currentTemperature < planDetail.degree) {
            stateToApply = HeaterState.values[planDetail.level];
          } else if (zone.currentTemperature > planDetail.degree) {
            stateToApply = HeaterState.off;
          } else {
            stateToApply = null;
          }
        }
      }
    } else {
      if (zone.hasThermostatAndSensor) {
        //
      } else {
        if (zone.currentTemperatureIsHigh) {
          stateToApply = HeaterState.level3;
        } else if (zone.currentTemperatureIsLow) {
          stateToApply = HeaterState.off;
        } else {
          stateToApply = null;
        }
      }
    }

    for (final heater in zone.zone.heaters) {
      await queryHeaterState(heater, stateToApply);
    }
  }

  Future<void> queryHeaterState(
      HeaterDevice heater, HeaterState? stateToApply) async {
    if (heater.desiredState == HeaterState.auto.index) {
      await applyState(heater, stateToApply);
    } else {
      if (heater.desiredState == HeaterState.off.index) {
        await applyState(heater, HeaterState.off);
      } else {
        //math.min
        final capableLevel =
            math.min(heater.desiredState, heater.levelType.index);
        await applyState(heater, HeaterState.values[capableLevel]);
      }
    }
  }

  Future<void> applyState(
      HeaterDevice heater, HeaterState? stateToApply) async {
    // get output channels
    final ChannelController channelController = Get.find();

    ChannelDefinition? ch1 = channelController.outputChannels
        .firstWhereOrNull((e) => e.pinIndex == heater.outputChannel1);
    ChannelDefinition? ch2 = channelController.outputChannels
        .firstWhereOrNull((e) => e.pinIndex == heater.outputChannel2);
    ChannelDefinition? ch3 = channelController.outputChannels
        .firstWhereOrNull((e) => e.pinIndex == heater.outputChannel3);
    bool out1 = false;
    bool out2 = false;
    bool out3 = false;
    switch (stateToApply) {
      case HeaterState.level1:
        out1 = true;
        out2 = false;
        out3 = false;
        break;
      case HeaterState.level2:
        out1 = true;
        out2 = true;
        out3 = false;
        break;
      case HeaterState.level3:
        out1 = true;
        out2 = true;
        out3 = true;
        break;
      default:
        out1 = false;
        out2 = false;
        out3 = false;
        break;
    }
    if (ch1 != null) {
      if (ch1.status != out1) {
        if (out1) {
          channelController.turnOnOutput(ch1.deviceId, ch1.pinIndex);
        } else {
          channelController.turnOffOutput(ch1.deviceId, ch1.pinIndex);
        }
      } else {
        if (!out1) {
          channelController.turnOffOutput(ch1.deviceId, ch1.pinIndex);
        }
      }
    }

    // if channel state != desired state
    // then send command
    // else ignore
  }
}
