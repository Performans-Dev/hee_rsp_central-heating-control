import 'dart:convert';

class LogDefinition {
  int? id;
  DateTime time;
  String message;
  int level;
  int type;
  int status;
  LogDefinition({
    this.id,
    required this.time,
    required this.message,
    this.level = 0,
    this.type = 0,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time.millisecondsSinceEpoch,
      'message': message,
      'level': level,
      'type': type,
      'status': status,
    };
  }

  factory LogDefinition.add({required String message, int? level, int? type}) {
    return LogDefinition(
      time: DateTime.now(),
      message: message,
      level: level ?? 0,
      type: type ?? 0,
    );
  }

  factory LogDefinition.fromMap(Map<String, dynamic> map) {
    return LogDefinition(
      id: map['id']?.toInt(),
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      message: map['message'] ?? '',
      level: map['level']?.toInt() ?? 0,
      type: map['type']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory LogDefinition.fromJson(String source) =>
      LogDefinition.fromMap(json.decode(source));
}
