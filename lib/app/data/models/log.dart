import 'dart:convert';

class LogDefinition {
  int? id;
  DateTime? time;
  String message;
  LogLevel level;
  int type;
  int status;
  LogDefinition({
    this.id,
    this.time,
    required this.message,
    this.level = LogLevel.debug,
    this.type = 0,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': (time ?? DateTime.now()).millisecondsSinceEpoch,
      'message': message,
      'level': level.index,
      'type': type,
      'status': status,
    };
  }

  factory LogDefinition.add(
      {required String message, LogLevel? level, int? type}) {
    return LogDefinition(
      time: DateTime.now(),
      message: message,
      level: level ?? LogLevel.debug,
      type: type ?? 0,
    );
  }

  factory LogDefinition.fromMap(Map<String, dynamic> map) {
    return LogDefinition(
      id: map['id']?.toInt(),
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      message: map['message'] ?? '',
      level: LogLevel.values[map['level']?.toInt() ?? 0],
      type: map['type']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory LogDefinition.fromJson(String source) =>
      LogDefinition.fromMap(json.decode(source));
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}
