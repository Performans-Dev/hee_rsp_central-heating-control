import 'dart:convert';

class DigitalOutput {
  final int id;
  final int hwId;
  final int pinIndex;
  final String name;
  final bool value;
  DigitalOutput({
    required this.id,
    required this.hwId,
    required this.pinIndex,
    required this.name,
    required this.value,
  });

  DigitalOutput copyWith({
    int? id,
    int? hwId,
    int? pinIndex,
    String? name,
    bool? value,
  }) {
    return DigitalOutput(
      id: id ?? this.id,
      hwId: hwId ?? this.hwId,
      pinIndex: pinIndex ?? this.pinIndex,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hwId': hwId,
      'pinIndex': pinIndex,
      'name': name,
      'value': value ? 1 : 0,
    };
  }

  factory DigitalOutput.fromMap(Map<String, dynamic> map) {
    return DigitalOutput(
      id: map['id']?.toInt() ?? 0,
      hwId: map['hwId']?.toInt() ?? 0,
      pinIndex: map['pinIndex']?.toInt() ?? 0,
      name: map['name'] ?? '',
      value: map['value'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory DigitalOutput.fromJson(String source) =>
      DigitalOutput.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DigitalOutput(id: $id, hwId: $hwId, pinIndex: $pinIndex, name: $name, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DigitalOutput &&
        other.id == id &&
        other.hwId == hwId &&
        other.pinIndex == pinIndex &&
        other.name == name &&
        other.value == value;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        hwId.hashCode ^
        pinIndex.hashCode ^
        name.hashCode ^
        value.hashCode;
  }
}
