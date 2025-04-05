import 'dart:convert';

class AppUser {
  final int id;
  final String name;
  final String pinCode;
  final int level;
  AppUser({
    required this.id,
    required this.name,
    required this.pinCode,
    required this.level,
  });

  bool get isValid =>
      name.length > 2 && name.length < 13 && pinCode.length == 6;

  AppUser copyWith({
    int? id,
    String? name,
    String? pinCode,
    int? level,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      pinCode: pinCode ?? this.pinCode,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return id > 0
        ? {
            'id': id,
            'name': name,
            'pinCode': pinCode,
            'level': level,
          }
        : {
            'name': name,
            'pinCode': pinCode,
            'level': level,
          };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      pinCode: map['pinCode'] ?? '',
      level: map['level']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(id: $id, name: $name, pinCode: $pinCode, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.id == id &&
        other.name == name &&
        other.pinCode == pinCode &&
        other.level == level;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ pinCode.hashCode ^ level.hashCode;
  }
}
