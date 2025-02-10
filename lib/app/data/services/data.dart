// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/function.dart';
import 'package:central_heating_control/app/data/models/generic_response.dart';
import 'package:central_heating_control/app/data/models/hardware.dart';
import 'package:central_heating_control/app/data/models/heater.dart';
import 'package:central_heating_control/app/data/models/plan.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/temperature_value.dart';
import 'package:central_heating_control/app/data/models/zone.dart';
import 'package:central_heating_control/app/data/providers/app_provider.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  late StreamSubscription btnStreamSubscription;

  //#region MARK: SUPER
  @override
  void onReady() {
    _onReady();
    super.onReady();
  }

  @override
  void onClose() {
    btnStreamSubscription.cancel();
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
    await loadTemperatureValues();
    // registerBtnListener();
    Future.delayed(const Duration(seconds: 5), () {
      // runnerLoop();
    });
  }
  //#endregion

  //#region MARK: Btns
  final RxBool _btn1 = false.obs;
  bool get btn1 => _btn1.value;
  final RxBool _btn2 = false.obs;
  bool get btn2 => _btn2.value;
  final RxBool _btn3 = false.obs;
  bool get btn3 => _btn3.value;
  final RxBool _btn4 = false.obs;
  bool get btn4 => _btn4.value;
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

  String? getHeaterZoneInfo(int channelId) {
    Heater? h;
    int? outputIndex;

    for (var heater in heaterList) {
      if (heater.outputChannel1 == channelId) {
        h = heater;
        outputIndex = 1;
      } else if (heater.outputChannel2 == channelId) {
        h = heater;
        outputIndex = 2;
      } else if (heater.outputChannel3 == channelId) {
        h = heater;
        outputIndex = 3;
      } else if (heater.errorChannel == channelId) {
        h = heater;
        outputIndex = 1;
      }
    }

    Zone? zone;
    if (h != null) {
      zone = zoneList.firstWhereOrNull((e) => e.id == h!.zoneId);
    }

    return h == null
        ? 'Not Connected'
        : '${h.name} - Channel: $outputIndex\n${zone != null ? zone.name : '-'}';
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
    // final ChannelController cc = Get.find();
    List<SensorDeviceWithValues> result = [];
    for (var sensor in sensorList.where((e) => e.zone == zoneId)) {
      result.add(SensorDeviceWithValues(
        id: sensor.id,
        device: sensor.device,
        index: sensor.index,
        zone: sensor.zone,
        color: sensor.color,
        name: sensor.name,
        value: 0// cc.getSensorValue(sensor.id),
      ));
    }
    return result;
  }

  double getSensorAverageOfZone(int zoneId) {
    final List<SensorDeviceWithValues> sensors = sensorListWithValues(zoneId);
    if (sensors.isEmpty) {
      return 0.0;
    }

    double sum = 0;
    int count = 0;

    for (final s in sensorListWithValues(zoneId)) {
      if (s.value != null) {
        sum += s.value!;
        count++;
      }
    }

    return count > 0 ? sum / count : 0;
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

  //#region MARK: FUNCTIONS
  final RxList<int?> _buttonFunctionList = <int?>[].obs;
  List<int?> get buttonFunctionList => _buttonFunctionList;
  final RxList<FunctionDefinition> _functionList = <FunctionDefinition>[].obs;
  List<FunctionDefinition> get functionList => _functionList;
  Future<void> loadFunctionList() async {
    final data = await DbProvider.db.getFunctions();
    final staticFunctions = [
      FunctionDefinition(
        id: -1,
        name: 'Lock Screen',
      ),
      FunctionDefinition(
        id: -2,
        name: 'Emergency Shutdown',
      ),
    ];
    _functionList.assignAll([...staticFunctions, ...data]);
    update();
    loadButtonFunctionList();
  }

  Future<void> loadButtonFunctionList() async {
    final data = await DbProvider.db.getButtonFunctions();
    _buttonFunctionList.assignAll(data);
    update();
  }

  Future<GenericResponse> updateButtonFunction(
      int buttonIndex, int? functionId) async {
    final result =
        await DbProvider.db.updateButtonFunction(buttonIndex, functionId);
    await loadFunctionList();
    return result > 0
        ? GenericResponse(success: true)
        : GenericResponse(success: false, statusCode: result);
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

  //#region MARK: TemperatureVAlues
  final RxList<TemperatureValue> _temperatureValues = <TemperatureValue>[].obs;
  List<TemperatureValue> get temperatureValues => _temperatureValues;
  Future<void> loadTemperatureValues() async {
    final data = await DbProvider.db.getAllTemperatureValues();
    if (data.isEmpty) {
      final data = await AppProvider.downloadTemperatureValues();
      if (data.success) {
        loadTemperatureValues();
        return;
      }
    }

    _temperatureValues.assignAll(data);
    update();
  }
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

  //#region MARK: BtnListener
  // registerBtnListener() {
  //   final ChannelController cc = Get.find();
  //   btnStreamSubscription = cc.buttonStream.listen(onData);
  // }

  // void onData(ChannelDefinition data) {
  //   switch (data.pinIndex) {
  //     case 1:
  //       _btn1.value = !data.status;
  //       break;
  //     case 2:
  //       _btn2.value = !data.status;
  //       break;
  //     case 3:
  //       _btn3.value = !data.status;
  //       break;
  //     case 4:
  //       _btn4.value = !data.status;
  //       break;
  //   }
  //   update();
  //   if (!data.status) {
  //     Buzz.mini();
  //   }
  // }
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
        // _runnerLogList.insert(
        //     0, '${zone.name} state must be ${zoneStateToApply.name}');
        // update();

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

          // _runnerLogList.insert(0,
          //     'picking heater ${heater.name} for zone ${zone.name} should be ${heaterStateToApply.name}');
          // update();

          // final ChannelController channelController = Get.find();

          /* switch (heaterStateToApply) {
            case ControlMode.on:
              if (heater.outputChannel1 != null && heater.outputChannel1 != 0) {
                channelController.setOutput(heater.outputChannel1!, true);
              }
              if (heater.outputChannel2 != null && heater.outputChannel2 != 0) {
                channelController.setOutput(heater.outputChannel2!, false);
              }
              if (heater.outputChannel3 != null && heater.outputChannel3 != 0) {
                channelController.setOutput(heater.outputChannel3!, false);
              }

              // _runnerLogList.insert(0, '${heater.name} sending 1 0 0');
              // update();
              break;
            case ControlMode.high:
              if (heater.outputChannel1 != null && heater.outputChannel1 != 0) {
                channelController.setOutput(heater.outputChannel1!, true);
              }
              if (heater.outputChannel2 != null && heater.outputChannel2 != 0) {
                channelController.setOutput(heater.outputChannel2!, true);
              }
              if (heater.outputChannel3 != null && heater.outputChannel3 != 0) {
                channelController.setOutput(heater.outputChannel3!, false);
              }
              // _runnerLogList.insert(0, '${heater.name} sending 1 1 0');
              // update();
              break;
            case ControlMode.max:
              if (heater.outputChannel1 != null && heater.outputChannel1 != 0) {
                channelController.setOutput(heater.outputChannel1!, true);
              }
              if (heater.outputChannel2 != null && heater.outputChannel2 != 0) {
                channelController.setOutput(heater.outputChannel2!, true);
              }
              if (heater.outputChannel3 != null && heater.outputChannel3 != 0) {
                channelController.setOutput(heater.outputChannel3!, true);
              }
              // _runnerLogList.insert(0, '${heater.name} sending 1 1 1');
              // update();
              break;
            default:
              if (heater.outputChannel1 != null && heater.outputChannel1 != 0) {
                channelController.setOutput(heater.outputChannel1!, false);
              }
              if (heater.outputChannel2 != null && heater.outputChannel2 != 0) {
                channelController.setOutput(heater.outputChannel2!, false);
              }
              if (heater.outputChannel3 != null && heater.outputChannel3 != 0) {
                channelController.setOutput(heater.outputChannel3!, false);
              }
              // _runnerLogList.insert(0, '${heater.name} sending 0 0 0');
              // update();
              break;
          } */
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
    if (runnerLogList.length > 100) {
      _runnerLogList.removeLast();
    }
    _runnerLogList.insert(0, log);
    update();
  }
  //#endregion
}
