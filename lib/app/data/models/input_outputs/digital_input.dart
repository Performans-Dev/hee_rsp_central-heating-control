import 'dart:convert';

class DigitalInput {
  final int id;
  final int hwId;
  final int pinIndex;
  final String name;
  DigitalInput({
    required this.id,
    required this.hwId,
    required this.pinIndex,
    required this.name,
  });

  DigitalInput copyWith({
    int? id,
    int? hwId,
    int? pinIndex,
    String? name,
  }) {
    return DigitalInput(
      id: id ?? this.id,
      hwId: hwId ?? this.hwId,
      pinIndex: pinIndex ?? this.pinIndex,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hwId': hwId,
      'pinIndex': pinIndex,
      'name': name,
    };
  }

  factory DigitalInput.fromMap(Map<String, dynamic> map) {
    return DigitalInput(
      id: map['id']?.toInt() ?? 0,
      hwId: map['hwId']?.toInt() ?? 0,
      pinIndex: map['pinIndex']?.toInt() ?? 0,
      name: map['name'] ?? '',
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
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ hwId.hashCode ^ pinIndex.hashCode ^ name.hashCode;
  }
}
