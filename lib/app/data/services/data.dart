import 'package:central_heating_control/app/data/models/hardware.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/plan.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/process.dart';
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
  }
  //#endregion

  //#region MARK: ZONES
  final List<ZoneDefinition> _zoneList = <ZoneDefinition>[].obs;
  List<ZoneDefinition> get zoneList => _zoneList;

  List<ZoneDefinition> getZoneListForDropdown() =>
      [ZoneDefinition.initial(), ...zoneList];

  Future<void> loadZoneList() async {
    final data = await DbProvider.db.getZoneList();
    _zoneList.assignAll(data);
    update();
    final ProcessController pc = Get.find();
    for (final z in data) {
      pc.initZone(z);
    }
  }

  Future<bool> addZone(ZoneDefinition zone) async {
    final result = await DbProvider.db.addZone(zone);
    if (result > 0) {
      await loadZoneList();
      return true;
    }
    return false;
  }

  Future<bool> updateZone(ZoneDefinition zone) async {
    final result = await DbProvider.db.updateZone(zone);
    if (result > 0) {
      await loadZoneList();
      return true;
    }
    return false;
  }

  Future<bool> updateZonePlan({required int zoneId, int? planId}) async {
    var zone = zoneList.firstWhere((e) => e.id == zoneId);
    zone.selectedPlan = planId;
    final result = await updateZone(zone);

    ProcessController processController = Get.find();
    processController.initZone(zone);

    return result;
  }
  //#endregion

  //#region MARK: HEATERS
  final List<HeaterDevice> _heaterList = <HeaterDevice>[].obs;
  List<HeaterDevice> get heaterList => _heaterList;
  Future<void> loadHeaterList() async {
    final data = await DbProvider.db.getHeaters();
    _heaterList.assignAll(data);
    update();
    final ProcessController pc = Get.find();
    for (final h in data) {
      pc.initHeater(h);
    }
  }

  Future<bool> addHeater(HeaterDevice heater) async {
    final result = await DbProvider.db.addHeater(heater);
    if (result > 0) {
      await loadHeaterList();
      return true;
    }
    return false;
  }

  Future<bool> updateHeater(HeaterDevice heater) async {
    final result = await DbProvider.db.updateHeater(heater);
    if (result > 0) {
      await loadHeaterList();
      return true;
    }
    return false;
  }

  Future<bool> deleteHeater(HeaterDevice heater) async {
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
  Future<void> loadSensorList() async {
    final data = await DbProvider.db.getSensors();
    _sensorList.assignAll(data);
    update();
  }

  void updateSensor(SensorDevice updatedSensor) {
    final index =
        sensorList.indexWhere((sensor) => sensor.id == updatedSensor.id);
    if (index != -1) {
      sensorList[index] = updatedSensor;
      DbProvider.db
          .updateSensor(updatedSensor); // Veritabanına güncelleme işlemi
      update();
    }
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
}
