/* import 'dart:convert';

import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';

class ZoneDefinition {
  int id;
  String name;
  List<HeaterDevice> heaters;
  List<SensorDevice> sensors;
  String color;
  List<AppUser> users;
  HeaterState desiredState;
  int? setValue;
  int? selectedPlan;
  ZoneDefinition({
    required this.id,
    required this.name,
    required this.heaters,
    required this.sensors,
    required this.color,
    required this.users,
    required this.desiredState,
    this.setValue,
    this.selectedPlan,
  });

  Map<String, dynamic> toMap() => id > 0
      ? {
          'id': id,
          'name': name,
          'heaters': heaters.map((x) => x.toMap()).toList(),
          'sensors': sensors.map((x) => x.toMap()).toList(),
          'color': color,
          'users': users.map((x) => x.toMap()).toList(),
          'desiredState': desiredState.index,
          'setValue': setValue,
          'selectedPlan': selectedPlan,
        }
      : {
          'name': name,
          'heaters': heaters.map((x) => x.toMap()).toList(),
          'sensors': sensors.map((x) => x.toMap()).toList(),
          'color': color,
          'users': users.map((x) => x.toMap()).toList(),
          'desiredState': desiredState.index,
          'setValue': setValue,
          'selectedPlan': selectedPlan,
        };

  factory ZoneDefinition.fromMap(Map<String, dynamic> map) {
    return ZoneDefinition(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      heaters: map['heaters'] == null
          ? []
          : List<HeaterDevice>.from(
              map['heaters']?.map((x) => HeaterDevice.fromMap(x))),
      sensors: map['sensors'] == null
          ? []
          : List<SensorDevice>.from(
              map['sensors']?.map((x) => SensorDevice.fromMap(x))),
      color: map['color'] ?? '',
      users: map['users'] == null
          ? []
          : List<AppUser>.from(map['users']?.map((x) => AppUser.fromMap(x))),
      desiredState: HeaterState.values[map['desiredState']?.toInt() ?? 0],
      setValue: map['setValue'],
      selectedPlan: map['selectedPlan']?.toInt(),
    );
  }

  factory ZoneDefinition.initial() => ZoneDefinition(
        id: -1,
        name: '',
        heaters: [],
        sensors: [],
        color: UiData.colorList.first,
        users: [],
        desiredState: HeaterState.off,
        setValue: null,
      );

  String toJson() => json.encode(toMap());

  factory ZoneDefinition.fromJson(String source) =>
      ZoneDefinition.fromMap(json.decode(source));

  ZoneDefinition copyWith({
    int? id,
    String? name,
    List<HeaterDevice>? heaters,
    List<SensorDevice>? sensors,
    String? color,
    List<AppUser>? users,
    HeaterState? desiredState,
    int? setValue,
    int? selectedPlan,
  }) {
    return ZoneDefinition(
      id: id ?? this.id,
      name: name ?? this.name,
      heaters: heaters ?? this.heaters,
      sensors: sensors ?? this.sensors,
      color: color ?? this.color,
      users: users ?? this.users,
      desiredState: desiredState ?? this.desiredState,
      setValue: setValue ?? this.setValue,
      selectedPlan: selectedPlan ?? this.selectedPlan,
    );
  }
}
 */
