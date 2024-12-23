import 'dart:convert';

import 'package:flutter/material.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

enum LogType {
  generic,
  lockScreenEvent,
  unlockScreenEvent,
  sendRelayEvent,
  receiveRelayEvent,
  sendSerialEvent,
  receiveSerialEvent,
  telemetryEvent,
  error,
  database,
}

enum LogSyncStatus {
  notSynced,
  syncing,
  synced,
}

class LogDefinition {
  int id;
  DateTime? time;
  int? yearValue;
  int? monthValue;
  int? dayValue;
  String message;
  LogLevel level;
  LogType type;
  LogSyncStatus status;
  LogDefinition({
    this.id = 0,
    this.time,
    required this.message,
    this.level = LogLevel.debug,
    this.type = LogType.generic,
    this.status = LogSyncStatus.notSynced,
    this.yearValue,
    this.monthValue,
    this.dayValue,
  });

  Map<String, dynamic> toMap() {
    return id > 0
        ? {
            'id': id,
            'time': (time ?? DateTime.now()).millisecondsSinceEpoch,
            'message': message,
            'level': level.index,
            'type': type.index,
            'status': status.index,
            'yearValue': yearValue,
            'monthValue': monthValue,
            'dayValue': dayValue,
          }
        : {
            'time': (time ?? DateTime.now()).millisecondsSinceEpoch,
            'message': message,
            'level': level.index,
            'type': type.index,
            'status': status.index,
            'yearValue': yearValue ?? (time ?? DateTime.now()).year,
            'monthValue': monthValue ?? (time ?? DateTime.now()).month,
            'dayValue': dayValue ?? (time ?? DateTime.now()).day,
          };
  }

  Color get backgroundColorLight {
    switch (level) {
      case LogLevel.debug:
        return const Color(0xFFF0F0F0);
      case LogLevel.info:
        return const Color(0xFFE3F2FD);
      case LogLevel.warning:
        return const Color(0xFFFFF9C4);
      case LogLevel.error:
        return const Color(0xFFFFCDD2);
      case LogLevel.critical:
        return const Color(0xFFF8BBD0);
    }
  }

  Color get backgroundColorDark {
    switch (level) {
      case LogLevel.debug:
        return const Color(0xFF424242);
      case LogLevel.info:
        return const Color(0xFF1565C0);
      case LogLevel.warning:
        return const Color(0xFFFFA000);
      case LogLevel.error:
        return const Color(0xFFD32F2F);
      case LogLevel.critical:
        return const Color(0xFFC2185B);
    }
  }

  factory LogDefinition.add({
    required String message,
    LogLevel? level,
    LogType? type,
  }) {
    return LogDefinition(
      id: 0,
      time: DateTime.now(),
      message: message,
      level: level ?? LogLevel.debug,
      type: type ?? LogType.generic,
      yearValue: DateTime.now().year,
      monthValue: DateTime.now().month,
      dayValue: DateTime.now().day,
    );
  }

  factory LogDefinition.fromMap(Map<String, dynamic> map) {
    int t = map['time']?.toInt();
    DateTime d = DateTime.fromMillisecondsSinceEpoch(t);
    return LogDefinition(
      id: map['id']?.toInt(),
      time: d,
      message: map['message'] ?? '',
      level: LogLevel.values[map['level']?.toInt() ?? 0],
      type: LogType.values[map['type']?.toInt() ?? 0],
      status: LogSyncStatus.values[map['status']?.toInt() ?? 0],
      yearValue: map['yearValue']?.toInt(),
      monthValue: map['monthValue']?.toInt(),
      dayValue: map['dayValue']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LogDefinition.fromJson(String source) =>
      LogDefinition.fromMap(json.decode(source));
}
