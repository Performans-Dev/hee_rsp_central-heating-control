import 'dart:convert';

import 'package:central_heating_control/app/data/models/com_port.dart';

class SensorDevice {
  int id;
  String name;
  double minValue;
  double maxValue;
  int? comportId;
  int? zoneId;
  SensorDevice({
    required this.id,
    required this.name,
    required this.minValue,
    required this.maxValue,
    this.comportId,
    this.zoneId,
  });

  Map<String, dynamic> toMap() => id > 0
      ? {
          'id': id,
          'name': name,
          'minValue': minValue,
          'maxValue': maxValue,
          'comportId': comportId,
          'zoneId': zoneId,
        }
      : {
          'name': name,
          'minValue': minValue,
          'maxValue': maxValue,
          'comportId': comportId,
          'zoneId': zoneId,
        };

  factory SensorDevice.fromMap(Map<String, dynamic> map) {
    return SensorDevice(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      minValue: map['minValue']?.toDouble() ?? 0.0,
      maxValue: map['maxValue']?.toDouble() ?? 0.0,
      comportId: map['comportId']?.toInt(),
      zoneId: map['zoneId']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SensorDevice.fromJson(String source) =>
      SensorDevice.fromMap(json.decode(source));
}
