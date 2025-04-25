import 'dart:convert';

class AnalogInput {
  final int id;
  final int hwId;
  final int pinIndex;
  final int type;
  final String name;
  final double value;
  AnalogInput({
    required this.id,
    required this.hwId,
    required this.pinIndex,
    required this.type,
    required this.name,
    required this.value,
  });

  AnalogInput copyWith({
    int? id,
    int? hwId,
    int? pinIndex,
    int? type,
    String? name,
    double? value,
  }) {
    return AnalogInput(
      id: id ?? this.id,
      hwId: hwId ?? this.hwId,
      pinIndex: pinIndex ?? this.pinIndex,
      type: type ?? this.type,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hwId': hwId,
      'pinIndex': pinIndex,
      'type': type,
      'name': name,
      'value': value,
    };
  }

  factory AnalogInput.fromMap(Map<String, dynamic> map) {
    return AnalogInput(
      id: map['id']?.toInt() ?? 0,
      hwId: map['hwId']?.toInt() ?? 0,
      pinIndex: map['pinIndex']?.toInt() ?? 0,
      type: map['type']?.toInt() ?? 0,
      name: map['name'] ?? '',
      value: map['value']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnalogInput.fromJson(String source) =>
      AnalogInput.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AnalogInput(id: $id, hwId: $hwId, pinIndex: $pinIndex, type: $type, name: $name, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnalogInput &&
        other.id == id &&
        other.hwId == hwId &&
        other.pinIndex == pinIndex &&
        other.type == type &&
        other.name == name &&
        other.value == value;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        hwId.hashCode ^
        pinIndex.hashCode ^
        type.hashCode ^
        name.hashCode ^
        value.hashCode;
  }
}
