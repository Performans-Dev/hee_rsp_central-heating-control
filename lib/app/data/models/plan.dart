import 'dart:convert';

class PlanDefinition {
  int id;
  String name;
  int isDefault;
  int isActive;
  PlanDefinition({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.isActive,
  });

  Map<String, dynamic> toMap() => id <= 0
      ? {
          'name': name,
          'isDefault': isDefault,
          'isActive': isActive,
        }
      : {
          'id': id,
          'name': name,
          'isDefault': isDefault,
          'isActive': isActive,
        };

  factory PlanDefinition.fromMap(Map<String, dynamic> map) {
    return PlanDefinition(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      isDefault: map['isDefault']?.toInt() ?? 0,
      isActive: map['isActive']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanDefinition.fromJson(String source) =>
      PlanDefinition.fromMap(json.decode(source));
}

class PlanDetail {
  int id;
  int planId;
  int hour;
  int day;
  int level;
  PlanDetail({
    required this.id,
    required this.planId,
    required this.hour,
    required this.day,
    required this.level,
  });

  Map<String, dynamic> toMap() => id <= 0
      ? {
          'planId': planId,
          'hour': hour,
          'day': day,
          'level': level,
        }
      : {
          'id': id,
          'planId': planId,
          'hour': hour,
          'day': day,
          'level': level,
        };

  factory PlanDetail.fromMap(Map<String, dynamic> map) {
    return PlanDetail(
      id: map['id']?.toInt() ?? 0,
      planId: map['planId']?.toInt() ?? 0,
      hour: map['hour']?.toInt() ?? 0,
      day: map['day']?.toInt() ?? 0,
      level: map['level']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanDetail.fromJson(String source) =>
      PlanDetail.fromMap(json.decode(source));
}
