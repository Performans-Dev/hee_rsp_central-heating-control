import 'dart:convert';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';

class HeaterProcess {
  HeaterDevice heater;
  HeaterState selectedState;
  bool hasThermostat;
  int desiredTemperature;
  int currentLevel;
  bool inputSignal;
  DateTime lastHeartbeat;
  HeaterProcess({
    required this.heater,
    required this.selectedState,
    required this.hasThermostat,
    required this.desiredTemperature,
    required this.currentLevel,
    required this.inputSignal,
    required this.lastHeartbeat,
  });

  Map<String, dynamic> toMap() {
    return {
      'heater': heater.toMap(),
      'selectedState': selectedState.index,
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
      selectedState: HeaterState.values[map['selectedState']?.toInt() ?? 0],
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
  HeaterState selectedState;
  bool hasThermostat;
  bool hasSensor;
  int desiredTemperature;
  int currentTemperature;
  DateTime lastHeartbeat;
  ZoneProcess({
    required this.zone,
    required this.selectedState,
    required this.hasThermostat,
    required this.hasSensor,
    required this.desiredTemperature,
    required this.currentTemperature,
    required this.lastHeartbeat,
  });

  Map<String, dynamic> toMap() {
    return {
      'zone': zone.toMap(),
      'selectedState': selectedState.index,
      'hasThermostat': hasThermostat,
      'hasSensor': hasSensor,
      'desiredTemperature': desiredTemperature,
      'currentTemperature': currentTemperature,
      'lastHeartbeat': lastHeartbeat.millisecondsSinceEpoch,
    };
  }

  factory ZoneProcess.fromMap(Map<String, dynamic> map) {
    return ZoneProcess(
      zone: ZoneDefinition.fromMap(map['zone']),
      selectedState: HeaterState.values[map['selectedState']?.toInt() ?? 0],
      hasThermostat: map['hasThermostat'] ?? false,
      hasSensor: map['hasSensor'] ?? false,
      desiredTemperature: map['desiredTemperature']?.toInt() ?? 0,
      currentTemperature: map['currentTemperature']?.toInt() ?? 0,
      lastHeartbeat: DateTime.fromMillisecondsSinceEpoch(map['lastHeartbeat']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ZoneProcess.fromJson(String source) =>
      ZoneProcess.fromMap(json.decode(source));
}
