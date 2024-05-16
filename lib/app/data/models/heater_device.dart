import 'dart:convert';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/com_port.dart';

class HeaterDevice {
  int id;
  String name;
  String color;
  String icon;
  HeaterDeviceType type;
  HeaterDeviceConnectionType connectionType;
  String? ipAddress;
  ComPort? level1Relay;
  double? level1ConsumptionAmount;
  String? level1ConsumptionUnit;
  ComPort? level2Relay;
  double? level2ConsumptionAmount;
  String? level2ConsumptionUnit;
  ComPort? errorChannel;
  ErrorChannelType? errorChannelType;
  int state;
  int? zoneId;
  HeaterDevice({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.type,
    required this.connectionType,
    this.ipAddress,
    this.level1Relay,
    this.level1ConsumptionAmount,
    this.level1ConsumptionUnit,
    this.level2Relay,
    this.level2ConsumptionAmount,
    this.level2ConsumptionUnit,
    this.errorChannel,
    this.errorChannelType,
    required this.state,
  });

  Map<String, dynamic> toMap() => id > 0
      ? {
          'id': id,
          'name': name,
          'color': color,
          'icon': icon,
          'type': type.index,
          'connectionType': connectionType.index,
          'ipAddress': ipAddress,
          'level1Relay': level1Relay?.toMap(),
          'level1ConsumptionAmount': level1ConsumptionAmount,
          'level1ConsumptionUnit': level1ConsumptionUnit,
          'level2Relay': level2Relay?.toMap(),
          'level2ConsumptionAmount': level2ConsumptionAmount,
          'level2ConsumptionUnit': level2ConsumptionUnit,
          'errorChannel': errorChannel?.toMap(),
          'errorChannelType': errorChannelType?.index,
          'state': state,
        }
      : {
          'name': name,
          'color': color,
          'icon': icon,
          'type': type.index,
          'connectionType': connectionType.index,
          'ipAddress': ipAddress,
          'level1Relay': level1Relay?.toMap(),
          'level1ConsumptionAmount': level1ConsumptionAmount,
          'level1ConsumptionUnit': level1ConsumptionUnit,
          'level2Relay': level2Relay?.toMap(),
          'level2ConsumptionAmount': level2ConsumptionAmount,
          'level2ConsumptionUnit': level2ConsumptionUnit,
          'errorChannel': errorChannel?.toMap(),
          'errorChannelType': errorChannelType?.index,
          'state': state,
        };

  factory HeaterDevice.fromMap(Map<String, dynamic> map) {
    return HeaterDevice(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      color: map['color'] ?? '',
      icon: map['icon'] ?? '',
      type: HeaterDeviceType.values[map['type']?.toInt() ?? 0],
      connectionType: HeaterDeviceConnectionType
          .values[map['connectionType']?.toInt() ?? 0],
      ipAddress: map['ipAddress'],
      level1Relay: map['level1Relay'] != null
          ? ComPort.fromMap(map['level1Relay'])
          : null,
      level1ConsumptionAmount: map['level1ConsumptionAmount']?.toDouble(),
      level1ConsumptionUnit: map['level1ConsumptionUnit'],
      level2Relay: map['level2Relay'] != null
          ? ComPort.fromMap(map['level2Relay'])
          : null,
      level2ConsumptionAmount: map['level2ConsumptionAmount']?.toDouble(),
      level2ConsumptionUnit: map['level2ConsumptionUnit'],
      errorChannel: map['errorChannel'] != null
          ? ComPort.fromMap(map['errorChannel'])
          : null,
      errorChannelType: map['errorChannelType'] != null
          ? ErrorChannelType.values[map['errorChannelType']?.toInt ?? 0]
          : null,
      state: map['state']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HeaterDevice.fromJson(String source) =>
      HeaterDevice.fromMap(json.decode(source));
}
