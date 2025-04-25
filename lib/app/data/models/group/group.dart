import 'dart:convert';

import 'package:central_heating_control/app/data/models/app_user/app_user.dart';
import 'package:central_heating_control/app/data/models/group/group_inputs.dart';

class GroupDefinition {
  final int id;
  final String name;
  final String color;
  final List<GroupInput> inputs;
  final List<AppUser> users;
  final int? schedulePlan;
  final double thermostatTemperature;
  final int? intervalOn;
  final int? intervalOff;
  final int cooldownTime;
  final int adjustedLevel;

  GroupDefinition({
    required this.id,
    required this.name,
    required this.color,
    required this.inputs,
    required this.users,
    required this.adjustedLevel,
    this.schedulePlan,
    required this.thermostatTemperature,
    this.intervalOn,
    this.intervalOff,
    required this.cooldownTime,
  });

  GroupDefinition copyWith({
    int? id,
    String? name,
    String? color,
    List<GroupInput>? inputs,
    List<AppUser>? users,
    int? adjustedLevel,
    int? schedulePlan,
    double? thermostatTemperature,
    int? intervalOn,
    int? intervalOff,
    int? cooldownTime,
  }) {
    return GroupDefinition(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      inputs: inputs ?? this.inputs,
      users: users ?? this.users,
      adjustedLevel: adjustedLevel ?? this.adjustedLevel,
      schedulePlan: schedulePlan ?? this.schedulePlan,
      thermostatTemperature:
          thermostatTemperature ?? this.thermostatTemperature,
      intervalOn: intervalOn ?? this.intervalOn,
      intervalOff: intervalOff ?? this.intervalOff,
      cooldownTime: cooldownTime ?? this.cooldownTime,
    );
  }

  Map<String, dynamic> toMap() {
    return id > 0
        ? {
            'id': id,
            'name': name,
            'color': color,
            'inputs': inputs.map((x) => x.toMap()).toList(),
            'users': users.map((x) => x.toMap()).toList(),
            'adjustedLevel': adjustedLevel,
            'schedulePlan': schedulePlan,
            'thermostatTemperature': thermostatTemperature,
            'intervalOn': intervalOn,
            'intervalOff': intervalOff,
            'cooldownTime': cooldownTime,
          }
        : {
            'name': name,
            'color': color,
            'inputs': inputs.map((x) => x.toMap()).toList(),
            'users': users.map((x) => x.toMap()).toList(),
            'adjustedLevel': adjustedLevel,
            'schedulePlan': schedulePlan,
            'thermostatTemperature': thermostatTemperature,
            'intervalOn': intervalOn,
            'intervalOff': intervalOff,
            'cooldownTime': cooldownTime,
          };
  }

  factory GroupDefinition.fromMap(Map<String, dynamic> map) {
    return GroupDefinition(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      color: map['color'] ?? '',
      inputs: List<GroupInput>.from(
        map['inputs']?.map((x) => GroupInput.fromMap(x)) ?? [],
      ),
      users: List<AppUser>.from(
        map['users']?.map((x) => AppUser.fromMap(x)) ?? [],
      ),
      adjustedLevel: map['adjustedLevel']?.toInt() ?? 0,
      cooldownTime: map['cooldownTime']?.toInt() ?? 0,
      schedulePlan: map['schedulePlan']?.toInt(),
      thermostatTemperature: map['thermostatTemperature']?.toDouble() ?? 0,
      intervalOn: map['intervalOn']?.toInt(),
      intervalOff: map['intervalOff']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupDefinition.fromJson(String source) =>
      GroupDefinition.fromMap(json.decode(source));

  factory GroupDefinition.empty() => GroupDefinition(
        id: 0,
        name: 'Grup',
        color: '#FF5733',
        inputs: [],
        users: [],
        adjustedLevel: 0,
        schedulePlan: null,
        thermostatTemperature: 0.0,
        intervalOn: null,
        intervalOff: null,
        cooldownTime: 0,
      );

  @override
  String toString() =>
      'Zone(id: $id, name: $name, color: $color, inputs: $inputs, '
      'users: $users, adjustedLevel: $adjustedLevel, '
      'schedulePlan: $schedulePlan, '
      'thermostatTemperature: $thermostatTemperature, '
      'intervalOn: $intervalOn, intervalOff: $intervalOff, '
      'cooldownTime: $cooldownTime)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupDefinition &&
        other.id == id &&
        other.name == name &&
        other.color == color &&
        other.inputs == inputs &&
        other.users == users &&
        other.adjustedLevel == adjustedLevel &&
        other.schedulePlan == schedulePlan &&
        other.thermostatTemperature == thermostatTemperature &&
        other.intervalOn == intervalOn &&
        other.intervalOff == intervalOff &&
        other.cooldownTime == cooldownTime;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      color.hashCode ^
      inputs.hashCode ^
      users.hashCode ^
      adjustedLevel.hashCode ^
      schedulePlan.hashCode ^
      thermostatTemperature.hashCode ^
      intervalOn.hashCode ^
      intervalOff.hashCode ^
      cooldownTime.hashCode;
}
