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

  SensorDevice copyWith({
    int? id,
    int? device,
    int? index,
    int? zone,
    String? color,
    String? name,
  }) {
    return SensorDevice(
      id: id ?? this.id,
      device: device ?? this.device,
      index: index ?? this.index,
      zone: zone ?? this.zone,
      color: color ?? this.color,
      name: name ?? this.name,
    );
  }
}

class SensorDeviceWithValues extends SensorDevice {
  double? value;
  SensorDeviceWithValues({
    required super.id,
    required super.device,
    required super.index,
    super.zone,
    super.color,
    super.name,
    this.value,
  });

  factory SensorDeviceWithValues.fromMap(Map<String, dynamic> map) {
    return SensorDeviceWithValues(
      id: map['id']?.toInt(),
      device: map['device']?.toInt(),
      index: map['sensorIndex']?.toInt(),
      zone: map['zoneId']?.toInt(),
      color: map['color'],
      name: map['name'],
      value: map['value']?.toDouble(),
    );
  }

  factory SensorDeviceWithValues.fromJson(String source) =>
      SensorDeviceWithValues.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SensorDeviceWithValues(id: $id, device: $device, index: $index, zone: $zone, color: $color, name: $name, value: $value)';
  }
}
