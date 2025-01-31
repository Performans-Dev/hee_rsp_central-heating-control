import 'dart:convert';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:get/get.dart';

class Zone {
  final int id;
  final String name;
  final String color;
  final List<AppUser> users;
  final int? selectedPlan;
  final ControlMode desiredMode;
  final ControlMode currentMode;
  final double? desiredTemperature;
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
    required this.hasThermostat,
  });

  double? get currentTemperature {
    double? result = 0;
    int count = 0;
    final DataController dc = Get.find();
    for (final s in dc.sensorListWithValues(id)) {
      if (s.value != null) {
        count++;
        result = (result ?? 0) + s.value!;
      }
    }

    return count > 0 ? (result ?? 0) / count : 0;
  }

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
        hasThermostat: false,
      );

  String toJson() => json.encode(toMap());

  factory Zone.fromJson(String source) => Zone.fromMap(json.decode(source));
}
