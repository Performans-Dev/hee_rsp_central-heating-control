// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class SensorDevice {
  int id;
  int device;
  int index;
  int? zone;
  String? color;
  String? name;
  SensorDevice({
    required this.id,
    required this.device,
    required this.index,
    this.zone,
    this.color,
    this.name,
  });

  Map<String, dynamic> toMap() => id > 0
      ? {
          'id': id,
          'device': device,
          'sensorIndex': index,
          'zoneId': zone,
          'color': color,
          'name': name,
        }
      : {
          'device': device,
          'sensorIndex': index,
          'zoneId': zone,
          'color': color,
          'name': name,
        };

  factory SensorDevice.fromMap(Map<String, dynamic> map) {
    return SensorDevice(
      id: map['id']?.toInt(),
      device: map['device']?.toInt(),
      index: map['sensorIndex']?.toInt(),
      zone: map['zoneId']?.toInt(),
      color: map['color'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SensorDevice.fromJson(String source) =>
      SensorDevice.fromMap(json.decode(source) as Map<String, dynamic>);
}
