import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/data/models/com_port.dart';
import 'package:central_heating_control/app/data/models/hardware_extension.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/plan.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/process.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  //#region SUPER

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
    _comportList.assignAll(UiData.ports);
    update();
    await getZoneListFromDb();
    await getHeaterListFromDb();
    await getSensorListFromDb();
    await getPlanListFromDb();
    await getPlanDetailsFromDb();
  }
  //#endregion

  //MARK: PORTS

  //#region COMMUNICATION PORTS
  final List<ComPort> _comportList = <ComPort>[].obs;
  List<ComPort> get comportList => _comportList;
  List<ComPort> get availableComportList {
    var list = comportList;
    return list;
  }

  //#endregion

  //MARK: ZONES

  //#region ZONE LIST
  final List<ZoneDefinition> _zoneList = <ZoneDefinition>[].obs;
  List<ZoneDefinition> get zoneList => _zoneList;
  List<ZoneDefinition> getZoneListForDropdown() =>
      [ZoneDefinition.initial(), ...zoneList];

  Future<void> getZoneListFromDb() async {
    final data = await DbProvider.db.getZoneList();
    _zoneList.assignAll(data);
    update();
    final ProcessController pc = Get.find();
    for (final z in data) {
      pc.initZone(z);
    }
  }
  //#endregion

  //#region ZONE ADD
  Future<bool> addZone(ZoneDefinition zone) async {
    final result = await DbProvider.db.addZone(zone);
    if (result > 0) {
      await getZoneListFromDb();
      return true;
    }
    return false;
  }
  //#endregion

  //#region ZONE UPDATE
  Future<bool> updateZone(ZoneDefinition zone) async {
    final result = await DbProvider.db.updateZone(zone);
    if (result > 0) {
      await getZoneListFromDb();
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

  //MARK: HEATERS

  //#region HEATERS LIST
  final List<HeaterDevice> _heaterList = <HeaterDevice>[].obs;
  List<HeaterDevice> get heaterList => _heaterList;
  Future<void> getHeaterListFromDb() async {
    final data = await DbProvider.db.getHeaters();
    _heaterList.assignAll(data);
    update();
    final ProcessController pc = Get.find();
    for (final h in data) {
      pc.initHeater(h);
    }
  }
  //#endregion

  //#region HEATER ADD
  Future<bool> addHeater(HeaterDevice heater) async {
    final result = await DbProvider.db.addHeater(heater);
    if (result > 0) {
      await getHeaterListFromDb();
      return true;
    }
    return false;
  }
  //#endregion

  //#region HEATER UPDATE
  Future<bool> updateHeater(HeaterDevice heater) async {
    final result = await DbProvider.db.updateHeater(heater);
    if (result > 0) {
      await getHeaterListFromDb();
      return true;
    }
    return false;
  }
  //#endregion

  //MARK: SENSORS

  //#region SENSORS LIST
  final List<SensorDevice> _sensorList = <SensorDevice>[].obs;
  List<SensorDevice> get sensorList => _sensorList;
  Future<void> getSensorListFromDb() async {
    final data = await DbProvider.db.getSensors();
    _sensorList.assignAll(data);
    update();
  }
  //#endregion

  //#region SENSORS ADD
  Future<void> addSensor(SensorDevice sensor) async {
    final result = await DbProvider.db.addSensor(sensor);
    if (result > 0) {
      await getSensorListFromDb();
    }
  }
  //#endregion

  //MARK: PLANS

  //#region PLANS LIST
  final RxList<PlanDefinition> _planList = <PlanDefinition>[].obs;
  List<PlanDefinition> get planList => _planList;

  Future<void> getPlanListFromDb() async {
    final data = await DbProvider.db.getPlanDefinitions();
    data.insert(0, PlanDefinition.none());
    _planList.assignAll(data);
    update();
  }
  //#endregion

  //#region PLAN DETAILS
  final RxList<PlanDetail> _planDetails = <PlanDetail>[].obs;
  List<PlanDetail> get planDetails => _planDetails;

  Future<void> getPlanDetailsFromDb() async {
    final data = await DbProvider.db.getPlanDetails();
    _planDetails.assignAll(data);
    update();
  }

  Future<void> addPlanDetailsToDb(List<PlanDetail> pdetails) async {
    final _ = await DbProvider.db.addPlanDetails(planDetails: pdetails);
    await getPlanListFromDb();
    await getPlanDetailsFromDb();
    update();
  }
  //#endregion

  //#region PLAN COPY
  Future<int?> copyPlan({required int sourcePlanId}) async {
    final data = await DbProvider.db.getPlanDetails(planId: sourcePlanId);
    if (data.isEmpty) {
      if (kDebugMode) {
        print('No details to copy for planId: $sourcePlanId');
      }
      return null;
    }
    final target = await DbProvider.db.addPlanDefinition(
      plan: PlanDefinition(
        id: 0,
        name: 'New Plan',
        isDefault: 0,
        isActive: 0,
      ),
    );
    if (target != null) {
      for (int i = 0; i < data.length; i++) {
        data[i].planId = target.id;
        data[i].id = 0;
      }
      await addPlanDetailsToDb(data);
    }
    return target?.id;
  }
  //#endregion

  //#region PLAN DELETE
  Future<bool> deletePlan({required int planId}) async {
    final result = await DbProvider.db.deletePlanAndDetails(planId: planId);
    getPlanListFromDb();
    return result;
  }
  //#endregion

  //#region PLAN UPDATE DEFINITION
  Future<bool> updatePlanDefinition({required PlanDefinition plan}) async {
    final result = await DbProvider.db.updatePlanDefinition(plan: plan);
    getPlanListFromDb();
    return result != null;
  }
  //#endregion

  //MARK: HARDWARE CONFIG

  final RxList<HardwareExtension> _hardwareExtensionList =
      <HardwareExtension>[].obs;
  List<HardwareExtension> get hardwareExtensionList => _hardwareExtensionList;

  Future<void> loadHardwareExtensions() async {
    final result = await DbProvider.db.getHardwareExtensions();
    _hardwareExtensionList.assignAll(result);
    update();
  }

  Future<int> addNewHardware(HardwareExtension data) async {
    final result = await DbProvider.db.addHardwareExtension(data);
    await loadHardwareExtensions();
    return result;
  }
}
