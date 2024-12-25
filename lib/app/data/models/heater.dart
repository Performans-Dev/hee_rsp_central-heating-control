import 'dart:convert';

import 'package:central_heating_control/app/core/constants/enums.dart';

class Heater {
  final int id;
  final String name;
  final String color;
  final String icon;
  final HeaterDeviceConnectionType connectionType;
  final HeaterDeviceType type;
  final HeaterDeviceLevel levelType;
  final String? ipAddress;
  final int? outputChannel1;
  final int? outputChannel2;
  final int? outputChannel3;
  final int? errorChannel;
  final ErrorChannelType? errorChannelType;
  final double? level1ConsumptionAmount;
  final double? level1Carbon;
  final double? level2ConsumptionAmount;
  final double? level2Carbon;
  final double? level3ConsumptionAmount;
  final double? level3Carbon;
  final String? consumptionUnit;
  final int? zoneId;
  final ControlMode desiredMode;
  final ControlMode currentMode;
  final double? desiredTemperature;
  final double? currentTemperature;
  final bool? hasThermostat;
  Heater({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.connectionType,
    required this.type,
    required this.levelType,
    this.ipAddress,
    this.outputChannel1,
    this.outputChannel2,
    this.outputChannel3,
    this.errorChannel,
    this.errorChannelType,
    this.level1ConsumptionAmount,
    this.level1Carbon,
    this.level2ConsumptionAmount,
    this.level2Carbon,
    this.level3ConsumptionAmount,
    this.level3Carbon,
    this.consumptionUnit,
    this.zoneId,
    required this.desiredMode,
    required this.currentMode,
    this.desiredTemperature,
    this.currentTemperature,
    this.hasThermostat,
  });

  Heater copyWith({
    int? id,
    String? name,
    String? color,
    String? icon,
    HeaterDeviceConnectionType? connectionType,
    HeaterDeviceType? type,
    HeaterDeviceLevel? levelType,
    String? ipAddress,
    int? outputChannel1,
    int? outputChannel2,
    int? outputChannel3,
    int? errorChannel,
    ErrorChannelType? errorChannelType,
    double? level1ConsumptionAmount,
    double? level1Carbon,
    double? level2ConsumptionAmount,
    double? level2Carbon,
    double? level3ConsumptionAmount,
    double? level3Carbon,
    String? consumptionUnit,
    int? zoneId,
    ControlMode? desiredMode,
    ControlMode? currentMode,
    double? desiredTemperature,
    double? currentTemperature,
    bool? hasThermostat,
  }) {
    return Heater(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      connectionType: connectionType ?? this.connectionType,
      type: type ?? this.type,
      levelType: levelType ?? this.levelType,
      ipAddress: ipAddress ?? this.ipAddress,
      outputChannel1: outputChannel1 ?? this.outputChannel1,
      outputChannel2: outputChannel2 ?? this.outputChannel2,
      outputChannel3: outputChannel3 ?? this.outputChannel3,
      errorChannel: errorChannel ?? this.errorChannel,
      errorChannelType: errorChannelType ?? this.errorChannelType,
      level1ConsumptionAmount:
          level1ConsumptionAmount ?? this.level1ConsumptionAmount,
      level1Carbon: level1Carbon ?? this.level1Carbon,
      level2ConsumptionAmount:
          level2ConsumptionAmount ?? this.level2ConsumptionAmount,
      level2Carbon: level2Carbon ?? this.level2Carbon,
      level3ConsumptionAmount:
          level3ConsumptionAmount ?? this.level3ConsumptionAmount,
      level3Carbon: level3Carbon ?? this.level3Carbon,
      consumptionUnit: consumptionUnit ?? this.consumptionUnit,
      zoneId: zoneId ?? this.zoneId,
      desiredMode: desiredMode ?? this.desiredMode,
      currentMode: currentMode ?? this.currentMode,
      desiredTemperature: desiredTemperature ?? this.desiredTemperature,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      hasThermostat: hasThermostat ?? this.hasThermostat,
    );
  }

  Map<String, dynamic> toMap() {
    return id > 0
        ? {
            'id': id,
            'name': name,
            'color': color,
            'icon': icon,
            'connectionType': connectionType.index,
            'type': type.index,
            'levelType': levelType.index,
            'ipAddress': ipAddress,
            'outputChannel1': outputChannel1,
            'outputChannel2': outputChannel2,
            'outputChannel3': outputChannel3,
            'errorChannel': errorChannel,
            'errorChannelType': errorChannelType?.index,
            'level1ConsumptionAmount': level1ConsumptionAmount,
            'level1Carbon': level1Carbon,
            'level2ConsumptionAmount': level2ConsumptionAmount,
            'level2Carbon': level2Carbon,
            'level3ConsumptionAmount': level3ConsumptionAmount,
            'level3Carbon': level3Carbon,
            'consumptionUnit': consumptionUnit,
            'zoneId': zoneId,
            'desiredMode': desiredMode.index,
            'currentMode': currentMode.index,
            'desiredTemperature': desiredTemperature,
            'currentTemperature': currentTemperature,
            'hasThermostat': hasThermostat == true ? 1 : 0,
          }
        : {
            'name': name,
            'color': color,
            'icon': icon,
            'connectionType': connectionType.index,
            'type': type.index,
            'levelType': levelType.index,
            'ipAddress': ipAddress,
            'outputChannel1': outputChannel1,
            'outputChannel2': outputChannel2,
            'outputChannel3': outputChannel3,
            'errorChannel': errorChannel,
            'errorChannelType': errorChannelType?.index,
            'level1ConsumptionAmount': level1ConsumptionAmount,
            'level1Carbon': level1Carbon,
            'level2ConsumptionAmount': level2ConsumptionAmount,
            'level2Carbon': level2Carbon,
            'level3ConsumptionAmount': level3ConsumptionAmount,
            'level3Carbon': level3Carbon,
            'consumptionUnit': consumptionUnit,
            'zoneId': zoneId,
            'desiredMode': desiredMode.index,
            'currentMode': currentMode.index,
            'desiredTemperature': desiredTemperature,
            'currentTemperature': currentTemperature,
            'hasThermostat': hasThermostat == true ? 1 : 0,
          };
  }

  factory Heater.fromMap(Map<String, dynamic> map) {
    return Heater(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      color: map['color'] ?? '',
      icon: map['icon'] ?? '',
      connectionType: HeaterDeviceConnectionType.values[map['connectionType']],
      type: HeaterDeviceType.values[map['type']],
      levelType: HeaterDeviceLevel.values[map['levelType']],
      ipAddress: map['ipAddress'],
      outputChannel1: map['outputChannel1']?.toInt(),
      outputChannel2: map['outputChannel2']?.toInt(),
      outputChannel3: map['outputChannel3']?.toInt(),
      errorChannel: map['errorChannel']?.toInt(),
      errorChannelType: map['errorChannelType'] != null
          ? ErrorChannelType.values[map['errorChannelType']]
          : null,
      level1ConsumptionAmount: map['level1ConsumptionAmount']?.toDouble(),
      level1Carbon: map['level1Carbon']?.toDouble(),
      level2ConsumptionAmount: map['level2ConsumptionAmount']?.toDouble(),
      level2Carbon: map['level2Carbon']?.toDouble(),
      level3ConsumptionAmount: map['level3ConsumptionAmount']?.toDouble(),
      level3Carbon: map['level3Carbon']?.toDouble(),
      consumptionUnit: map['consumptionUnit'],
      zoneId: map['zoneId']?.toInt(),
      desiredMode: ControlMode.values[map['desiredMode']],
      currentMode: ControlMode.values[map['currentMode']],
      desiredTemperature: map['desiredTemperature']?.toDouble(),
      currentTemperature: map['currentTemperature']?.toDouble(),
      hasThermostat: map['hasThermostat'] == 1 ? true : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Heater.fromJson(String source) => Heater.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Heater(id: $id, name: $name, color: $color, icon: $icon, connectionType: $connectionType, type: $type, levelType: $levelType, ipAddress: $ipAddress, outputChannel1: $outputChannel1, outputChannel2: $outputChannel2, outputChannel3: $outputChannel3, errorChannel: $errorChannel, errorChannelType: $errorChannelType, level1ConsumptionAmount: $level1ConsumptionAmount, level1Carbon: $level1Carbon, level2ConsumptionAmount: $level2ConsumptionAmount, level2Carbon: $level2Carbon, level3ConsumptionAmount: $level3ConsumptionAmount, level3Carbon: $level3Carbon, consumptionUnit: $consumptionUnit, zoneId: $zoneId, desiredMode: $desiredMode, currentMode: $currentMode, desiredTemperature: $desiredTemperature, currentTemperature: $currentTemperature, hasThermostat: $hasThermostat)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Heater &&
        other.id == id &&
        other.name == name &&
        other.color == color &&
        other.icon == icon &&
        other.connectionType == connectionType &&
        other.type == type &&
        other.levelType == levelType &&
        other.ipAddress == ipAddress &&
        other.outputChannel1 == outputChannel1 &&
        other.outputChannel2 == outputChannel2 &&
        other.outputChannel3 == outputChannel3 &&
        other.errorChannel == errorChannel &&
        other.errorChannelType == errorChannelType &&
        other.level1ConsumptionAmount == level1ConsumptionAmount &&
        other.level1Carbon == level1Carbon &&
        other.level2ConsumptionAmount == level2ConsumptionAmount &&
        other.level2Carbon == level2Carbon &&
        other.level3ConsumptionAmount == level3ConsumptionAmount &&
        other.level3Carbon == level3Carbon &&
        other.consumptionUnit == consumptionUnit &&
        other.zoneId == zoneId &&
        other.desiredMode == desiredMode &&
        other.currentMode == currentMode &&
        other.desiredTemperature == desiredTemperature &&
        other.currentTemperature == currentTemperature &&
        other.hasThermostat == hasThermostat;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        color.hashCode ^
        icon.hashCode ^
        connectionType.hashCode ^
        type.hashCode ^
        levelType.hashCode ^
        ipAddress.hashCode ^
        outputChannel1.hashCode ^
        outputChannel2.hashCode ^
        outputChannel3.hashCode ^
        errorChannel.hashCode ^
        errorChannelType.hashCode ^
        level1ConsumptionAmount.hashCode ^
        level1Carbon.hashCode ^
        level2ConsumptionAmount.hashCode ^
        level2Carbon.hashCode ^
        level3ConsumptionAmount.hashCode ^
        level3Carbon.hashCode ^
        consumptionUnit.hashCode ^
        zoneId.hashCode ^
        desiredMode.hashCode ^
        currentMode.hashCode ^
        desiredTemperature.hashCode ^
        currentTemperature.hashCode ^
        hasThermostat.hashCode;
  }
}
