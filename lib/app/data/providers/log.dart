import 'dart:convert';
import 'dart:io';

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:path/path.dart' as path;

class LogService {
  static Future<String> _getLogFilePath({DateTime? date}) async {
    final now = date ?? DateTime.now();
    final logDir = path.join(
        Box.documentsDirectoryPath,
        Keys.logPath,
        now.year.toString(),
        now.month.toString().padLeft(2, '0'),
        now.day.toString().padLeft(2, '0'));

    // Ensure the directory exists
    await Directory(logDir).create(recursive: true);

    return path.join(logDir, 'logs.json');
  }

  static Future<void> log(LogDefinition logEntry) async {
    final logFilePath = await _getLogFilePath();
    final logFile = File(logFilePath);

    List<LogDefinition> logs = [];

    if (await logFile.exists()) {
      final content = await logFile.readAsString();
      if (content.isNotEmpty) {
        final decoded = jsonDecode(content);
        logs = List<Map<String, dynamic>>.from(decoded)
            .map((map) => LogDefinition.fromMap(map))
            .toList();
      }
    }

    logs.add(logEntry);

    final encodedLogs = jsonEncode(logs.map((log) => log.toMap()).toList());
    await logFile.writeAsString(encodedLogs, mode: FileMode.write);
  }

  static Future<void> addLog(LogDefinition logEntry) async {
    final logFilePath = await _getLogFilePath();
    final logFile = File(logFilePath);

    List<LogDefinition> logs = [];

    if (await logFile.exists()) {
      final content = await logFile.readAsString();
      if (content.isNotEmpty) {
        final decoded = jsonDecode(content);
        logs = List<Map<String, dynamic>>.from(decoded)
            .map((map) => LogDefinition.fromMap(map))
            .toList();
      }
    }

    // Append the new log entry to the existing list
    logs.add(logEntry);

    // Write the updated list back to the file
    final encodedLogs = jsonEncode(logs.map((log) => log.toMap()).toList());
    await logFile.writeAsString(encodedLogs, mode: FileMode.write);
  }

  static Future<List<LogDefinition>> readLogs({DateTime? date}) async {
    final logFilePath = await _getLogFilePath(date: date);
    final logFile = File(logFilePath);

    if (await logFile.exists()) {
      final content = await logFile.readAsString();
      if (content.isNotEmpty) {
        final decoded = jsonDecode(content);
        return List<Map<String, dynamic>>.from(decoded)
            .map((map) => LogDefinition.fromMap(map))
            .toList();
      }
    }

    return [];
  }

  // static Future<List<LogDefinition>> updateLogs(
  //     {required List<String> logsIds}) async {}
}
