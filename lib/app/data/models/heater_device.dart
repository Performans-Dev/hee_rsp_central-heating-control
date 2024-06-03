import 'dart:convert';

import 'package:get/get.dart';

import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/channel.dart';

class HeaterDevice {
  int id;
  String name;
  String color;
  String icon;
  HeaterDeviceType type;
  HeaterDeviceConnectionType connectionType;
  String? ipAddress;
  HeaterDeviceLevel levelType;
  Channel? level1Relay;
  double? level1ConsumptionAmount;
  String? level1ConsumptionUnit;
  double? level1Carbon;
  Channel? level2Relay;
  double? level2ConsumptionAmount;
  String? level2ConsumptionUnit;
  double? level2Carbon;
  Channel? level3Relay;
  double? level3ConsumptionAmount;
  String? level3ConsumptionUnit;
  double? level3Carbon;
  Channel? errorChannel;
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
    required this.levelType,
    this.level1Relay,
    this.level1ConsumptionAmount,
    this.level1ConsumptionUnit,
    this.level1Carbon,
    this.level2Relay,
    this.level2ConsumptionAmount,
    this.level2ConsumptionUnit,
    this.level2Carbon,
    this.level3Relay,
    this.level3ConsumptionAmount,
    this.level3ConsumptionUnit,
    this.level3Carbon,
    this.errorChannel,
    this.errorChannelType,
    required this.state,
    this.zoneId,
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
          'levelType': levelType.index,
          'level1Relay': level1Relay?.id,
          'level1ConsumptionAmount': level1ConsumptionAmount,
          'level1ConsumptionUnit': level1ConsumptionUnit,
          'level1Carbon': level1Carbon,
          'level2Relay': level2Relay?.id,
          'level2ConsumptionAmount': level2ConsumptionAmount,
          'level2ConsumptionUnit': level2ConsumptionUnit,
          'level2Carbon': level2Carbon,
          'level3Relay': level3Relay?.id,
          'level3ConsumptionAmount': level3ConsumptionAmount,
          'level3ConsumptionUnit': level3ConsumptionUnit,
          'level3Carbon': level3Carbon,
          'errorChannel': errorChannel?.id,
          'errorChannelType': errorChannelType?.index,
          'state': state,
          'zoneId': zoneId,
        }
      : {
          'name': name,
          'color': color,
          'icon': icon,
          'type': type.index,
          'connectionType': connectionType.index,
          'ipAddress': ipAddress,
          'levelType': levelType.index,
          'level1Relay': level1Relay?.id,
          'level1ConsumptionAmount': level1ConsumptionAmount,
          'level1ConsumptionUnit': level1ConsumptionUnit,
          'level1Carbon': level1Carbon,
          'level2Relay': level2Relay?.id,
          'level2ConsumptionAmount': level2ConsumptionAmount,
          'level2ConsumptionUnit': level2ConsumptionUnit,
          'level2Carbon': level2Carbon,
          'level3Relay': level3Relay?.id,
          'level3ConsumptionAmount': level3ConsumptionAmount,
          'level3ConsumptionUnit': level3ConsumptionUnit,
          'level3Carbon': level3Carbon,
          'errorChannel': errorChannel?.id,
          'errorChannelType': errorChannelType?.index,
          'state': state,
          'zoneId': zoneId,
        };

  factory HeaterDevice.initial() => HeaterDevice(
        id: -1,
        name: '',
        color: '',
        icon: '',
        type: HeaterDeviceType.none,
        connectionType: HeaterDeviceConnectionType.none,
        state: HeaterState.off.index,
        levelType: HeaterDeviceLevel.none,
      );

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
      levelType: HeaterDeviceLevel.values[map['levelType']?.toInt() ?? 0],
      level1Relay: map['level1Relay'] != null
          ? UiData.channels
              .firstWhereOrNull((element) => element.id == map['level1Relay'])
          : null,
      level1ConsumptionAmount: map['level1ConsumptionAmount']?.toDouble(),
      level1ConsumptionUnit: map['level1ConsumptionUnit'],
      level1Carbon: map['level1Carbon']?.toDouble(),
      level2Relay: map['level2Relay'] != null
          ? UiData.channels
              .firstWhereOrNull((element) => element.id == map['level2Relay'])
          : null,
      level2ConsumptionAmount: map['level2ConsumptionAmount']?.toDouble(),
      level2ConsumptionUnit: map['level2ConsumptionUnit'],
      level2Carbon: map['level2Carbon']?.toDouble(),
      level3Relay: map['level3Relay'] != null
          ? UiData.channels
              .firstWhereOrNull((element) => element.id == map['level3Relay'])
          : null,
      level3ConsumptionAmount: map['level3ConsumptionAmount']?.toDouble(),
      level3ConsumptionUnit: map['level3ConsumptionUnit'],
      level3Carbon: map['level3Carbon']?.toDouble(),
      errorChannel: map['errorChannel'] != null
          ? UiData.channels.firstWhereOrNull((e) => e.id == map['errorChannel'])
          : null,
      errorChannelType: map['errorChannelType'] != null
          ? ErrorChannelType.values[map['errorChannelType']]
          : null,
      state: map['state']?.toInt() ?? 0,
      zoneId: map['zoneId']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory HeaterDevice.fromJson(String source) =>
      HeaterDevice.fromMap(json.decode(source));
}
