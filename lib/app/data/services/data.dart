import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/hardware.dart';
import 'package:central_heating_control/app/data/models/heater.dart';
import 'package:central_heating_control/app/data/models/plan.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  //#region MARK: SUPER
  @override
  void onReady() {
    _onReady();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> _onReady() async {
    update();
    await loadZoneList();
    await loadHeaterList();
    await loadSensorList();
    await loadPlanList();
    await loadPlanDetails();
    await loadHardwareDevices();
    Future.delayed(const Duration(seconds: 5), () {
      runnerLoop();
    });
  }
  //#endregion

  //#region MARK: ZONES
  final List<Zone> _zoneList = <Zone>[].obs;
  List<Zone> get zoneList => _zoneList;

  List<Zone> getZoneListForDropdown() => [Zone.initial(), ...zoneList];

  Future<void> loadZoneList() async {
    final data = await DbProvider.db.getZoneList();
    _zoneList.assignAll(data);
    update();
    // final ProcessController pc = Get.find();
    // for (final z in data) {
    //   pc.initZone(z);
    // }
  }

  Future<bool> addZone(Zone zone) async {
    final result = await DbProvider.db.addZone(zone);
    if (result > 0) {
      await loadZoneList();
      return true;
    }
    return false;
  }

  Future<bool> updateZone(Zone zone) async {
    final index = _zoneList.indexWhere((element) => element.id == zone.id);
    if (index > -1) {
      _zoneList[index] = zone;
      update();
    }
    final result = await DbProvider.db.updateZone(zone);
    if (result > 0) {
      // await loadZoneList();
      return true;
    }
    return false;
  }

  Future<bool> updateZonePlan({required int zoneId, int? planId}) async {
    var zone = zoneList.firstWhere((e) => e.id == zoneId).copyWith(
          selectedPlan: planId,
        );

    final result = await updateZone(zone);
    // ProcessController processController = Get.find();
    // processController.initZone(zone);
    return result;
  }
  //#endregion

  //#region MARK: HEATERS
  final List<Heater> _heaterList = <Heater>[].obs;
  List<Heater> get heaterList => _heaterList;
  List<Heater> getHeatersOfZone(int zoneId) =>
      heaterList.where((element) => element.zoneId == zoneId).toList();

  Future<void> loadHeaterList() async {
    final data = await DbProvider.db.getHeaters();
    _heaterList.assignAll(data);
    update();
    // final ProcessController pc = Get.find();
    // for (final h in data) {
    //   pc.initHeater(h);
    // }
  }

  Future<bool> addHeater(Heater heater) async {
    final result = await DbProvider.db.addHeater(heater);
    if (result > 0) {
      await loadHeaterList();
      return true;
    }
    return false;
  }

  Future<bool> updateHeater(Heater heater) async {
    final index = heaterList.indexWhere((element) => element.id == heater.id);
    if (index != -1) {
      _heaterList[index] = heater;
      update();
    }
    final result = await DbProvider.db.updateHeater(heater);
    if (result > 0) {
      // await loadHeaterList();
      return true;
    }
    return false;
  }

  Future<bool> deleteHeater(Heater heater) async {
    final result = await DbProvider.db.deleteHeater(heater);
    if (result > 0) {
      await loadHeaterList();
      return true;
    }
    return false;
  }
  //#endregion

  //#region MARK: SENSORS
  final List<SensorDevice> _sensorList = <SensorDevice>[].obs;
  List<SensorDevice> get sensorList => _sensorList;
  List<SensorDevice> getSensorsOfZone(int zoneId) =>
      sensorList.where((element) => element.zone == zoneId).toList();

  Future<void> loadSensorList() async {
    final data = await DbProvider.db.getSensors();
    _sensorList.assignAll(data);
    update();
  }

  void updateSensor(SensorDevice updatedSensor) {
    final index =
        sensorList.indexWhere((sensor) => sensor.id == updatedSensor.id);
    if (index != -1) {
      _sensorList[index] = updatedSensor;
      DbProvider.db
          .updateSensor(updatedSensor); // Veritabanına güncelleme işlemi
      update();
    }
  }

  List<SensorDeviceWithValues> sensorListWithValues(zoneId) {
    final ChannelController cc = Get.find();
    List<SensorDeviceWithValues> result = [];
    for (var sensor in sensorList.where((e) => e.zone == zoneId)) {
      result.add(SensorDeviceWithValues(
        id: sensor.id,
        device: sensor.device,
        index: sensor.index,
        zone: sensor.zone,
        color: sensor.color,
        name: sensor.name,
        value: cc.getSensorValue(sensor.id),
      ));
    }
    return result;
  }

  double getSensorAverageOfZone(int zoneId) {
    final List<SensorDeviceWithValues> sensors = sensorListWithValues(zoneId);
    if (sensors.isEmpty) {
      return 0.0;
    }

    // Use null safety and a non-nullable initial value
    double sum = sensors.fold<double>(0.0, (previousValue, sensor) {
      return previousValue + (sensor.value ?? 0.0); // Use null-aware operator
    });

    return sum / sensors.length;
  }
  //#endregion

  //#region MARK: PLANS
  final RxList<PlanDefinition> _planList = <PlanDefinition>[].obs;
  List<PlanDefinition> get planList => _planList;

  Future<void> loadPlanList() async {
    final data = await DbProvider.db.getPlanDefinitions();
    data.insert(0, PlanDefinition.none());
    _planList.assignAll(data);
    update();
  }

  final RxList<PlanDetail> _planDetails = <PlanDetail>[].obs;
  List<PlanDetail> get planDetails => _planDetails;

  Future<void> loadPlanDetails() async {
    final data = await DbProvider.db.getPlanDetails();
    _planDetails.assignAll(data);
    update();
  }

  Future<void> addPlanDetails(List<PlanDetail> pdetails) async {
    final _ = await DbProvider.db.addPlanDetails(planDetails: pdetails);
    await loadPlanList();
    await loadPlanDetails();
    update();
  }

  Future<int?> copyPlan({required int sourcePlanId, String? name}) async {
    final data = await DbProvider.db.getPlanDetails(planId: sourcePlanId);
    if (data.isEmpty) {
      if (kDebugMode) {
        print('Plan ID: $sourcePlanId ile herhangi bir veri bulunamadı.');
      }
    } else {
      if (kDebugMode) {
        print('Plan ID: $sourcePlanId için ${data.length} adet detay bulundu.');
      }
    }

    final target = await DbProvider.db.addPlanDefinition(
      plan: PlanDefinition(
        id: 0,
        name: name ?? 'New Plan{$sourcePlanId}',
        isDefault: 0,
        isActive: 0,
      ),
    );
    if (target != null) {
      for (int i = 0; i < data.length; i++) {
        data[i].planId = target.id;
        data[i].id = 0;
      }
      await addPlanDetails(data);
    }
    return target?.id;
  }

  Future<bool> deletePlan({required int planId}) async {
    final result = await DbProvider.db.deletePlanAndDetails(planId: planId);
    loadPlanList();
    return result;
  }

  Future<bool> updatePlanDetail({required PlanDefinition plan}) async {
    final result = await DbProvider.db.updatePlanDefinition(plan: plan);
    loadPlanList();
    return result != null;
  }
  //#endregion

  //#region MARK: HARDWARE

  final RxList<Hardware> _hardwareDeviceList = <Hardware>[].obs;
  List<Hardware> get hardwareDeviceList => _hardwareDeviceList;

  Future<void> loadHardwareDevices() async {
    final result = await DbProvider.db.getHardwareDevices();
    _hardwareDeviceList.assignAll(result);
    update();
  }

  Future<int> addNewHardware(Hardware data) async {
    final result = await DbProvider.db.addHardwareDevice(data);
    await loadHardwareDevices();
    return result;
  }

  Future<int> deleteHardware(Hardware data) async {
    final result = await DbProvider.db.deleteHardwareDevice(data);
    await loadHardwareDevices();
    return result;
  }

  // Future<int> changeDeviceId(Hardware data, int deviceId) async {
  //   data.deviceId = deviceId;
  //   final result = await DbProvider.db.updateHardwareDevice(data);
  //   await loadHardwareDevices();
  //   return result;
  // }

  // Future<int> changeDeviceSerial(Hardware data, String serialNumber) async {
  //   data.serialNumber = serialNumber;
  //   final result = await DbProvider.db.updateHardwareDevice(data);
  //   await loadHardwareDevices();
  //   return result;
  // }
  //#endregion

  //#region MARK: ACTIONS
  Future<void> onZoneModeCalled({
    required int zoneId,
    required ControlMode mode,
  }) async {
    final zone = zoneList.firstWhere((e) => e.id == zoneId).copyWith(
          desiredMode: mode,
        );
    await updateZone(zone);
  }

  Future<void> onHeaterModeCalled({
    required int heaterId,
    required ControlMode mode,
  }) async {
    final heater = heaterList.firstWhere((e) => e.id == heaterId).copyWith(
          desiredMode: mode,
        );
    await updateHeater(heater);
  }

  Future<void> onZonePlanCalled({
    required int zoneId,
    int? planId,
  }) async {
    final zone = zoneList
        .firstWhere((e) => e.id == zoneId)
        .copyWith(selectedPlan: planId);
    await updateZone(zone);
  }

  Future<void> onZoneThermostatCalled({
    required int zoneId,
    required bool hasThermostat,
  }) async {
    final zone = zoneList
        .firstWhere((e) => e.id == zoneId)
        .copyWith(hasThermostat: hasThermostat);
    await updateZone(zone);
  }

  Future<void> onZoneTemperatureCalled({
    required int zoneId,
    required double temperature,
  }) async {
    final zone = zoneList
        .firstWhere((e) => e.id == zoneId)
        .copyWith(desiredTemperature: temperature);
    await updateZone(zone);
  }
  //#endregion

  //#region MARK: LOOP
  final RxBool _isLooping = false.obs;
  bool get isLooping => _isLooping.value;

  Future<void> runnerLoop() async {
    if (isLooping) {
      _runnerLogList.insert(0, 'Loop is already running.');
      update();
      return;
    }
    _isLooping.value = true;
    update();

    for (final zone in zoneList) {
      ControlMode? zoneStateToApply;
      _runnerLogList.insert(0, 'Picking Zone: ${zone.name}');
      update();
      if (heaterList.where((e) => e.zoneId == zone.id).isEmpty) {
        // _runnerLogList.insert(0, 'No heater for ${zone.name}');
        // update();
      } else {
        if (zone.selectedPlan == null ||
            zone.selectedPlan == 0 ||
            zone.desiredMode != ControlMode.auto) {
          // no plan
          if (zone.hasThermostat && getSensorsOfZone(zone.id).isNotEmpty) {
            // check thermostat
            // _runnerLogList.insert(0, 'Checking thermo for ${zone.name}');
            // update();
            if (zone.isCurrentTemperatureHigherThanDesired) {
              // let it cool
              zoneStateToApply = ControlMode.off;
            } else if (zone.isCurrentTemperatureLowerThanDesired) {
              // heat up
              zoneStateToApply = ControlMode.max;
            } else {
              // wait for temperature change
              zoneStateToApply = zone.currentMode;
            }
          } else {
            // check control mode
            // _runnerLogList.insert(0, 'Checking control mode for ${zone.name}');
            // update();
            if (zone.currentMode == zone.desiredMode) {
              // do nothing
              zoneStateToApply = zone.currentMode;
            } else {
              // apply mode
              zoneStateToApply = zone.desiredMode;
            }
          }
        } else {
          // apply plan
          // _runnerLogList.insert(0, 'Applying plan for ${zone.name}');
          // update();
          final plan =
              await DbProvider.db.getPlanDetails(planId: zone.selectedPlan!);
          final plansOfCurrentTime = plan
              .where((e) =>
                  e.hour == DateTime.now().hour &&
                  e.day == DateTime.now().weekday)
              .toList();
          if (plan.isEmpty) {
            // let it cool
            zoneStateToApply = ControlMode.off;
          } else {
            final planDetail = plansOfCurrentTime.first;
            if (planDetail.hasThermostat == 1) {
              final desiredPlanDegree = planDetail.degree;
              if ((zone.currentTemperature ?? 20) >
                  desiredPlanDegree.toDouble()) {
                // let it cool
                zoneStateToApply = ControlMode.off;
              } else if ((zone.currentTemperature ?? 20) <
                  desiredPlanDegree.toDouble()) {
                // heat up
                zoneStateToApply = ControlMode.values[planDetail.level];
              } else {
                // wait for temperature change
                zoneStateToApply = zone.currentMode;
              }
            } else {
              if (zone.currentMode != ControlMode.values[planDetail.level]) {
                // apply mode
                zoneStateToApply = ControlMode.values[planDetail.level];
              } else {
                // do nothing
                zoneStateToApply = zone.currentMode;
              }
            }
          }
        }
        _runnerLogList.insert(
            0, '${zone.name} state must be ${zoneStateToApply.name}');
        update();

        for (final heater in heaterList.where((e) => e.zoneId == zone.id)) {
          ControlMode? heaterStateToApply;

          if (heater.desiredMode == ControlMode.auto) {
            // apply zone state
            heaterStateToApply = zoneStateToApply;
          } else if (heater.desiredMode == ControlMode.off) {
            // shutdown heater
            heaterStateToApply = ControlMode.off;
          } else {
            // apply heater state
            heaterStateToApply = heater.desiredMode;
          }

          _runnerLogList.insert(0,
              'picking heater ${heater.name} for zone ${zone.name} should be ${heaterStateToApply.name}');
          update();

          int? channel1;
          int? channel2;
          int? channel3;
          final ChannelController channelController = Get.find();
          switch (heater.levelType) {
            case HeaterDeviceLevel.none:
              //ignore
              break;
            case HeaterDeviceLevel.onOff:
              channel1 = channelController.outputChannels
                  .firstWhereOrNull((e) => e.id == heater.outputChannel1)
                  ?.pinIndex;

              break;
            case HeaterDeviceLevel.twoLevels:
              channel1 = channelController.outputChannels
                  .firstWhereOrNull((e) => e.id == heater.outputChannel1)
                  ?.pinIndex;
              channel2 = channelController.outputChannels
                  .firstWhereOrNull((e) => e.id == heater.outputChannel2)
                  ?.pinIndex;
              break;
            case HeaterDeviceLevel.threeLevels:
              channel1 = channelController.outputChannels
                  .firstWhereOrNull((e) => e.id == heater.outputChannel1)
                  ?.pinIndex;
              channel2 = channelController.outputChannels
                  .firstWhereOrNull((e) => e.id == heater.outputChannel2)
                  ?.pinIndex;
              channel3 = channelController.outputChannels
                  .firstWhereOrNull((e) => e.id == heater.outputChannel3)
                  ?.pinIndex;
              break;
          }

          switch (heaterStateToApply) {
            case ControlMode.on:
              if (channel1 != null) {
                await channelController.setOutput(channel1, true);
              }
              if (channel2 != null) {
                await channelController.setOutput(channel2, false);
              }
              if (channel3 != null) {
                await channelController.setOutput(channel3, false);
              }

              _runnerLogList.insert(0, '${heater.name} sending 1 0 0');
              update();
              break;
            case ControlMode.high:
              if (channel1 != null) {
                await channelController.setOutput(channel1, true);
              }
              if (channel2 != null) {
                await channelController.setOutput(channel2, true);
              }
              if (channel3 != null) {
                await channelController.setOutput(channel3, false);
              }
              _runnerLogList.insert(0, '${heater.name} sending 1 1 0');
              update();
              break;
            case ControlMode.max:
              if (channel1 != null) {
                await channelController.setOutput(channel1, true);
              }
              if (channel2 != null) {
                await channelController.setOutput(channel2, true);
              }
              if (channel3 != null) {
                await channelController.setOutput(channel3, true);
              }
              _runnerLogList.insert(0, '${heater.name} sending 1 1 1');
              update();
              break;
            default:
              if (channel1 != null) {
                await channelController.setOutput(channel1, false);
              }
              if (channel2 != null) {
                await channelController.setOutput(channel2, false);
              }
              if (channel3 != null) {
                await channelController.setOutput(channel3, false);
              }
              _runnerLogList.insert(0, '${heater.name} sending 0 0 0');
              update();
              break;
          }
        }
      }
    }

    _isLooping.value = false;
    update();
    _runnerLogList.insert(0, '-------------');
    update();
    Future.delayed(const Duration(milliseconds: 12000), () {
      runnerLoop();
    });
  }
  //#endregion

  //#region MARK: Runner Log
  final RxList<String> _runnerLogList = <String>[].obs;
  List<String> get runnerLogList => _runnerLogList;

  void addRunnerLog(String log) {
    _runnerLogList.insert(0, log);
    update();
  }
  //#endregion
}
