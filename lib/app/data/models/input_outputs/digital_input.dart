import 'dart:convert';

class DigitalInput {
  final int id;
  final int hwId;
  final int pinIndex;
  final String name;
  bool value;
  DigitalInput({
    required this.id,
    required this.hwId,
    required this.pinIndex,
    required this.name,
    required this.value,
  });

  DigitalInput copyWith({
    int? id,
    int? hwId,
    int? pinIndex,
    String? name,
    bool? value,
  }) {
    return DigitalInput(
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

  factory DigitalInput.fromMap(Map<String, dynamic> map) {
    return DigitalInput(
      id: map['id']?.toInt() ?? 0,
      hwId: map['hwId']?.toInt() ?? 0,
      pinIndex: map['pinIndex']?.toInt() ?? 0,
      name: map['name'] ?? '',
      value: map['value'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory DigitalInput.fromJson(String source) =>
      DigitalInput.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DigitalInput(id: $id, hwId: $hwId, pinIndex: $pinIndex, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DigitalInput &&
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
