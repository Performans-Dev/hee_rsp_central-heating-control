import 'dart:convert';

class ZoneDefinition {
  final int id;
  final String name;
  final String color;

  ZoneDefinition({
    required this.id,
    required this.name,
    required this.color,
  });

  ZoneDefinition copyWith({
    int? id,
    String? name,
    String? color,
  }) {
    return ZoneDefinition(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }

  factory ZoneDefinition.fromMap(Map<String, dynamic> map) {
    return ZoneDefinition(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      color: map['color'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ZoneDefinition.fromJson(String source) => ZoneDefinition.fromMap(json.decode(source));

  @override
  String toString() => 'Zone(id: $id, name: $name, color: $color)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ZoneDefinition &&
      other.id == id &&
      other.name == name &&
      other.color == color;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ color.hashCode;
}
