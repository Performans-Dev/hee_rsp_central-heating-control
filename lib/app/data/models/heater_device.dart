import 'dart:convert';

import 'package:central_heating_control/app/core/constants/enums.dart';

class HeaterDevice {
  int id;
  String name;
  String color;
  String icon;
  HeaterDeviceType type;
  HeaterDeviceConnectionType connectionType;
  String? ipAddress;
  HeaterDeviceLevel levelType;
  int? outputChannel1;
  int? outputChannel2;
  int? outputChannel3;
  int? errorChannel;
  ErrorChannelType? errorChannelType;
  double? level1ConsumptionAmount;
  double? level1Carbon;
  double? level2ConsumptionAmount;
  double? level2Carbon;
  double? level3ConsumptionAmount;
  double? level3Carbon;
  String? consumptionUnit;
  int desiredState;
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
    this.outputChannel1,
    this.level1ConsumptionAmount,
    this.level1Carbon,
    this.outputChannel2,
    this.level2ConsumptionAmount,
    this.level2Carbon,
    this.outputChannel3,
    this.level3ConsumptionAmount,
    this.level3Carbon,
    this.errorChannel,
    this.errorChannelType,
    required this.desiredState,
    this.consumptionUnit,
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
          'desiredState': desiredState,
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
          'desiredState': desiredState,
          'zoneId': zoneId,
        };

  factory HeaterDevice.initial() => HeaterDevice(
        id: -1,
        name: '',
        color: '',
        icon: '',
        type: HeaterDeviceType.none,
        connectionType: HeaterDeviceConnectionType.none,
        desiredState: HeaterState.off.index,
        levelType: HeaterDeviceLevel.none,
      );

  factory HeaterDevice.fromMap(Map<String, dynamic> map) => HeaterDevice(
        id: map['id'],
        name: map['name'],
        color: map['color'],
        icon: map['icon'],
        type: HeaterDeviceType.values.firstWhere((e) => e.index == map['type']),
        connectionType: HeaterDeviceConnectionType.values
            .firstWhere((e) => e.index == map['connectionType']),
        ipAddress: map['ipAddress'],
        levelType: HeaterDeviceLevel.values
            .firstWhere((e) => e.index == map['levelType']),
        outputChannel1: map['outputChannel1'],
        outputChannel2: map['outputChannel2'],
        outputChannel3: map['outputChannel3'],
        errorChannel: map['errorChannel'],
        errorChannelType: map['errorChannelType'] != null
            ? ErrorChannelType.values
                .firstWhere((e) => e.index == map['errorChannelType'])
            : null,
        level1ConsumptionAmount: map['level1ConsumptionAmount'],
        level1Carbon: map['level1Carbon'],
        level2ConsumptionAmount: map['level2ConsumptionAmount'],
        level2Carbon: map['level2Carbon'],
        level3ConsumptionAmount: map['level3ConsumptionAmount'],
        level3Carbon: map['level3Carbon'],
        consumptionUnit: map['consumptionUnit'],
        desiredState: map['desiredState'],
        zoneId: map['zoneId'],
      );

  String toJson() => json.encode(toMap());

  factory HeaterDevice.fromJson(String source) =>
      HeaterDevice.fromMap(json.decode(source));
}
