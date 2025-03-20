// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:central_heating_control/app/core/constants/enums.dart';

class FunctionDefinition {
  final int id;
  final String name;
  final int? zoneId;
  final int? heaterId;
  final ControlMode? controlMode;
  final int? fromHour;
  final int? toHour;
  FunctionDefinition({
    required this.id,
    required this.name,
    this.zoneId,
    this.heaterId,
    this.controlMode,
    this.fromHour,
    this.toHour,
  });

  FunctionDefinition copyWith({
    int? id,
    String? name,
    int? zoneId,
    int? heaterId,
    ControlMode? controlMode,
    int? fromHour,
    int? toHour,
  }) {
    return FunctionDefinition(
      id: id ?? this.id,
      name: name ?? this.name,
      zoneId: zoneId ?? this.zoneId,
      heaterId: heaterId ?? this.heaterId,
      controlMode: controlMode ?? this.controlMode,
      fromHour: fromHour ?? this.fromHour,
      toHour: toHour ?? this.toHour,
    );
  }

  Map<String, dynamic> toMap() {
    return id > 0
        ? {
            'id': id,
            'name': name,
            'zoneId': zoneId,
            'heaterId': heaterId,
            'controlMode': controlMode?.index,
            'fromHour': fromHour,
            'toHour': toHour,
          }
        : {
            'name': name,
            'zoneId': zoneId,
            'heaterId': heaterId,
            'controlMode': controlMode?.index,
            'fromHour': fromHour,
            'toHour': toHour,
          };
  }

  factory FunctionDefinition.fromMap(Map<String, dynamic> map) {
    try {
      return FunctionDefinition(
        id: map['id']?.toInt() ?? 0,
        name: map['name'] ?? '',
        zoneId: map['zoneId']?.toInt(),
        heaterId: map['heaterId']?.toInt(),
        controlMode:
            map['controlMode'] != null ? ControlMode.values[map['mode']] : null,
        fromHour: map['fromHour']?.toInt(),
        toHour: map['toHour']?.toInt(),
      );
    } on Exception catch (e) {
      print(e);
      return FunctionDefinition(id: 0, name: 'error');
    }
  }

  String toJson() => json.encode(toMap());

  factory FunctionDefinition.fromJson(String source) =>
      FunctionDefinition.fromMap(json.decode(source));
}
