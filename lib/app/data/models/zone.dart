import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';

class Zone {
  final int id;
  final String name;
  final String color;
  final List<AppUser> users;
  final int? selectedPlan;
  final ControlMode desiredMode;
  final ControlMode currentMode;
  final double? desiredTemperature;
  final double? currentTemperature;
  final bool hasThermostat;
  Zone({
    required this.id,
    required this.name,
    required this.color,
    required this.users,
    this.selectedPlan,
    required this.desiredMode,
    required this.currentMode,
    this.desiredTemperature,
    this.currentTemperature,
    required this.hasThermostat,
  });

  bool get isCurrentTemperatureLowerThanDesired =>
      currentTemperature != null && desiredTemperature != null
          ? currentTemperature! < desiredTemperature!
          : false;

  bool get isCurrentTemperatureHigherThanDesired =>
      currentTemperature != null && desiredTemperature != null
          ? currentTemperature! > desiredTemperature!
          : false;

  Zone copyWith({
    int? id,
    String? name,
    String? color,
    List<AppUser>? users,
    int? selectedPlan,
    ControlMode? desiredMode,
    ControlMode? currentMode,
    double? desiredTemperature,
    double? currentTemperature,
    bool? hasThermostat,
  }) {
    return Zone(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      users: users ?? this.users,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      desiredMode: desiredMode ?? this.desiredMode,
      currentMode: currentMode ?? this.currentMode,
      desiredTemperature: desiredTemperature ?? this.desiredTemperature,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      hasThermostat: hasThermostat ?? this.hasThermostat,
    );
  }

  Map<String, dynamic> toDb() {
    return id > 0
        ? {
            'id': id,
            'name': name,
            'color': color,
            // 'users': users.map((x) => x.toMap()).toList(),
            'selectedPlan': selectedPlan,
            'desiredMode': desiredMode.index,
            'currentMode': currentMode.index,
            'desiredTemperature': desiredTemperature,
            'currentTemperature': currentTemperature,
            'hasThermostat': hasThermostat == true ? 1 : 0,
          }
        : {
            'name': name,
            'color': color,
            // 'users': users.map((x) => x.toMap()).toList(),
            'selectedPlan': selectedPlan,
            'desiredMode': desiredMode.index,
            'currentMode': currentMode.index,
            'desiredTemperature': desiredTemperature,
            'currentTemperature': currentTemperature,
            'hasThermostat': hasThermostat == true ? 1 : 0,
          };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'users': users.map((x) => x.toMap()).toList(),
      'selectedPlan': selectedPlan,
      'desiredMode': desiredMode.index,
      'currentMode': currentMode.index,
      'desiredTemperature': desiredTemperature,
      'currentTemperature': currentTemperature,
      'hasThermostat': hasThermostat,
    };
  }

  factory Zone.fromMap(Map<String, dynamic> map) {
    return Zone(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      color: map['color'] ?? '',
      users: List<AppUser>.from(map['users']?.map((x) => AppUser.fromMap(x))),
      selectedPlan: map['selectedPlan']?.toInt(),
      desiredMode: ControlMode.values[map['desiredMode']],
      currentMode: ControlMode.values[map['currentMode']],
      desiredTemperature: map['desiredTemperature']?.toDouble(),
      currentTemperature: map['currentTemperature']?.toDouble(),
      hasThermostat: map['hasThermostat'] == 1 ? true : false,
    );
  }

  factory Zone.fromDb(Map<String, dynamic> map, List<AppUser> users) {
    return Zone(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      color: map['color'] ?? '',
      users: users,
      selectedPlan: map['selectedPlan']?.toInt(),
      desiredMode: ControlMode.values[map['desiredMode']],
      currentMode: ControlMode.values[map['currentMode']],
      desiredTemperature: map['desiredTemperature']?.toDouble(),
      currentTemperature: map['currentTemperature']?.toDouble(),
      hasThermostat: map['hasThermostat'] == 1 ? true : false,
    );
  }

  factory Zone.initial() => Zone(
        id: -1,
        name: '',
        color: '',
        users: [],
        selectedPlan: null,
        desiredMode: ControlMode.off,
        currentMode: ControlMode.off,
        desiredTemperature: null,
        currentTemperature: null,
        hasThermostat: false,
      );

  String toJson() => json.encode(toMap());

  factory Zone.fromJson(String source) => Zone.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Zone(id: $id, name: $name, color: $color, users: $users, selectedPlan: $selectedPlan, desiredMode: $desiredMode, currentMode: $currentMode, desiredTemperature: $desiredTemperature, currentTemperature: $currentTemperature, hasThermostat: $hasThermostat)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Zone &&
        other.id == id &&
        other.name == name &&
        other.color == color &&
        listEquals(other.users, users) &&
        other.selectedPlan == selectedPlan &&
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
        users.hashCode ^
        selectedPlan.hashCode ^
        desiredMode.hashCode ^
        currentMode.hashCode ^
        desiredTemperature.hashCode ^
        currentTemperature.hashCode ^
        hasThermostat.hashCode;
  }
}
