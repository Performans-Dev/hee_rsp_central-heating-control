import 'dart:convert';

import 'package:central_heating_control/app/core/constants/data.dart';
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
  int state;
  ZoneDefinition({
    required this.id,
    required this.name,
    required this.heaters,
    required this.sensors,
    required this.color,
    required this.users,
    required this.state,
  });

  Map<String, dynamic> toMap() => id > 0
      ? {
          'id': id,
          'name': name,
          'heaters': heaters.map((x) => x.toMap()).toList(),
          'sensors': sensors.map((x) => x.toMap()).toList(),
          'color': color,
          'users': users.map((x) => x.toMap()).toList(),
          'state': state,
        }
      : {
          'name': name,
          'heaters': heaters.map((x) => x.toMap()).toList(),
          'sensors': sensors.map((x) => x.toMap()).toList(),
          'color': color,
          'users': users.map((x) => x.toMap()).toList(),
          'state': state,
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
      state: map['state']?.toInt() ?? 0,
    );
  }

  factory ZoneDefinition.initial() => ZoneDefinition(
        id: -1,
        name: '',
        heaters: [],
        sensors: [],
        color: UiData.colorList.first,
        users: [],
        state: 0,
      );

  String toJson() => json.encode(toMap());

  factory ZoneDefinition.fromJson(String source) =>
      ZoneDefinition.fromMap(json.decode(source));
}
