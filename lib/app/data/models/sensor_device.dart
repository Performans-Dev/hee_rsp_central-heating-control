import 'dart:convert';

import 'package:central_heating_control/app/data/models/com_port.dart';

class SensorDevice {
  int id;
  String name;
  double minValue;
  double maxValue;
  ComPort? comPort;
  SensorDevice({
    required this.id,
    required this.name,
    required this.minValue,
    required this.maxValue,
    this.comPort,
  });

  Map<String, dynamic> toMap() => id > 0
      ? {
          'id': id,
          'name': name,
          'minValue': minValue,
          'maxValue': maxValue,
          'comPort': comPort?.toMap(),
        }
      : {
          'name': name,
          'minValue': minValue,
          'maxValue': maxValue,
          'comPort': comPort?.toMap(),
        };

  factory SensorDevice.fromMap(Map<String, dynamic> map) {
    return SensorDevice(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      minValue: map['minValue']?.toDouble() ?? 0.0,
      maxValue: map['maxValue']?.toDouble() ?? 0.0,
      comPort: map['comPort'] != null ? ComPort.fromMap(map['comPort']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SensorDevice.fromJson(String source) =>
      SensorDevice.fromMap(json.decode(source));
}
