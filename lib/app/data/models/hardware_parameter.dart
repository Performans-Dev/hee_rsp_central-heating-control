import 'dart:convert';

class HardwareParameter {
  int id;
  String name;
  int inputCount;
  int outputCount;
  int analogCount;
  String version;
  String type;
  bool isExtension;
  HardwareParameter({
    required this.id,
    required this.name,
    required this.inputCount,
    required this.outputCount,
    required this.analogCount,
    required this.version,
    required this.type,
    required this.isExtension,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'inputCount': inputCount,
      'outputCount': outputCount,
      'analogCount': analogCount,
      'version': version,
      'type': type,
      'isExtension': isExtension,
    };
  }

  factory HardwareParameter.fromMap(Map<String, dynamic> map) {
    return HardwareParameter(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      inputCount: map['inputCount']?.toInt() ?? 0,
      outputCount: map['outputCount']?.toInt() ?? 0,
      analogCount: map['analogCount']?.toInt() ?? 0,
      version: map['version'] ?? '',
      type: map['type'] ?? '',
      isExtension: map['isExtension'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory HardwareParameter.fromJson(String source) =>
      HardwareParameter.fromMap(json.decode(source));
}
