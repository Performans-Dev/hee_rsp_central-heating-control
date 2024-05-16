import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/data/models/com_port.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  //#region SUPER
  @override
  void onInit() {
    super.onInit();
  }

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
  }
  //#endregion

  //#region COMMUNICATION PORTS
  final List<ComPort> _comportList = <ComPort>[].obs;
  List<ComPort> get comportList => _comportList;

  //#endregion

  //#region ZONES
  final List<ZoneDefinition> _zoneList = <ZoneDefinition>[].obs;
  List<ZoneDefinition> get zoneList => _zoneList;
  Future<void> getZoneListFromDb() async {
    final data = await DbProvider.db.getZoneList();
    _zoneList.assignAll(data);
    update();
  }
  //#endregion

  //#region HEATERS
  final List<HeaterDevice> _heaterList = <HeaterDevice>[].obs;
  List<HeaterDevice> get heaterList => _heaterList;
  Future<void> getHeaterListFromDb() async {
    final data = await DbProvider.db.getHeaters();
    _heaterList.assignAll(data);
    update();
  }
  //#endregion

  //#region SENSORS
  final List<SensorDevice> _sensorList = <SensorDevice>[].obs;
  List<SensorDevice> get sensorList => _sensorList;
  Future<void> getSensorListFromDb() async {
    final data = await DbProvider.db.getSensors();
    _sensorList.assignAll(data);
    update();
  }
  //#endregion

  //available port list
  // UiData.ports al
  // db deki kullanilanlari bul, listeden cikar

  //seensor list
  //populate()
  //updateSensor()
  //deleteSensor()
  //addSensor()

  //devices list

  //zone list
}
