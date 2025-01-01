/* import 'dart:convert';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';

class HeaterProcess {
  HeaterDevice heater;
  HeaterState currentState;
  bool hasThermostat;
  int desiredTemperature;
  int currentLevel;
  bool inputSignal;
  DateTime lastHeartbeat;
  HeaterProcess({
    required this.heater,
    required this.currentState,
    required this.hasThermostat,
    required this.desiredTemperature,
    required this.currentLevel,
    required this.inputSignal,
    required this.lastHeartbeat,
  });

  Map<String, dynamic> toMap() {
    return {
      'heater': heater.toMap(),
      'currentState': currentState.index,
      'hasThermostat': hasThermostat,
      'desiredTemperature': desiredTemperature,
      'currentLevel': currentLevel,
      'inputSignal': inputSignal,
      'lastHeartbeat': lastHeartbeat.millisecondsSinceEpoch,
    };
  }

  factory HeaterProcess.fromMap(Map<String, dynamic> map) {
    return HeaterProcess(
      heater: HeaterDevice.fromMap(map['heater']),
      currentState: HeaterState.values[map['currentState']?.toInt() ?? 0],
      hasThermostat: map['hasThermostat'] ?? false,
      desiredTemperature: map['desiredTemperature']?.toInt() ?? 0,
      currentLevel: map['currentLevel']?.toInt() ?? 0,
      inputSignal: map['inputSignal'] ?? false,
      lastHeartbeat: DateTime.fromMillisecondsSinceEpoch(map['lastHeartbeat']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HeaterProcess.fromJson(String source) =>
      HeaterProcess.fromMap(json.decode(source));
}

class ZoneProcess {
  ZoneDefinition zone;
  HeaterState currentState;
  bool hasThermostat;
  bool hasSensor;
  int desiredTemperature;
  int currentTemperature;
  DateTime lastHeartbeat;
  List<SensorDeviceWithValues> sensors;
  ZoneProcess({
    required this.zone,
    required this.currentState,
    required this.hasThermostat,
    required this.hasSensor,
    required this.desiredTemperature,
    required this.currentTemperature,
    required this.lastHeartbeat,
    required this.sensors,
  });

  bool get hasWeeklyPlan => zone.selectedPlan != null;
  bool get hasThermostatAndSensor => hasThermostat && hasSensor;
  bool get currentTemperatureIsHigh => desiredTemperature > currentTemperature;
  bool get currentTemperatureIsLow => desiredTemperature < currentTemperature;

  Map<String, dynamic> toMap() {
    return {
      'zone': zone.toMap(),
      'currentState': currentState.index,
      'hasThermostat': hasThermostat,
      'hasSensor': hasSensor,
      'desiredTemperature': desiredTemperature,
      'currentTemperature': currentTemperature,
      'lastHeartbeat': lastHeartbeat.millisecondsSinceEpoch,
      'sensors': sensors.map((e) => e.toMap()).toList(),
    };
  }

  factory ZoneProcess.fromMap(Map<String, dynamic> map) {
    return ZoneProcess(
      zone: ZoneDefinition.fromMap(map['zone']),
      currentState: HeaterState.values[map['currentState']?.toInt() ?? 0],
      hasThermostat: map['hasThermostat'] ?? false,
      hasSensor: map['hasSensor'] ?? false,
      desiredTemperature: map['desiredTemperature']?.toInt() ?? 0,
      currentTemperature: map['currentTemperature']?.toInt() ?? 0,
      lastHeartbeat: DateTime.fromMillisecondsSinceEpoch(map['lastHeartbeat']),
      sensors: List<SensorDeviceWithValues>.from(
          map['sensors']?.map((x) => SensorDeviceWithValues.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ZoneProcess.fromJson(String source) =>
      ZoneProcess.fromMap(json.decode(source));
}
 */
