import 'dart:convert';

class GroupDefinition {
  final int id;
  final String name;
  final String color;

  GroupDefinition({
    required this.id,
    required this.name,
    required this.color,
  });

  GroupDefinition copyWith({
    int? id,
    String? name,
    String? color,
  }) {
    return GroupDefinition(
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

  factory GroupDefinition.fromMap(Map<String, dynamic> map) {
    return GroupDefinition(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      color: map['color'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupDefinition.fromJson(String source) =>
      GroupDefinition.fromMap(json.decode(source));

  @override
  String toString() => 'Zone(id: $id, name: $name, color: $color)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupDefinition &&
        other.id == id &&
        other.name == name &&
        other.color == color;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ color.hashCode;
}
