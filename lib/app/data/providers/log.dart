import 'dart:convert';
import 'dart:io';

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/providers/log_db.dart';
import 'package:path/path.dart' as path;

class LogService {
  static Future<String> getLogFilePath({DateTime? date}) async {
    try {
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
    } on Exception catch (_) {
      return '/home/pi/Heethings/CC/logs';
    }
  }

  static Future<void> log(LogDefinition logEntry) async {
    try {
      final logFilePath = await getLogFilePath();
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
    } on Exception catch (_) {}
  }

  static Future<void> addLog(LogDefinition logEntry) async {
    await LogDbProvider.db.addLog(logEntry);
    // try {
    //   final logFilePath = await getLogFilePath();
    //   final logFile = File(logFilePath);

    //   List<LogDefinition> logs = [];

    //   if (await logFile.exists()) {
    //     final content = await logFile.readAsString();
    //     if (content.isNotEmpty) {
    //       final decoded = jsonDecode(content);
    //       logs = List<Map<String, dynamic>>.from(decoded)
    //           .map((map) => LogDefinition.fromMap(map))
    //           .toList();
    //     }
    //   }

    //   // Append the new log entry to the existing list
    //   logs.add(logEntry);

    //   // Write the updated list back to the file
    //   final encodedLogs = jsonEncode(logs.map((log) => log.toMap()).toList());
    //   await logFile.writeAsString('', mode: FileMode.write); // Clear the file
    //   await logFile.writeAsString(encodedLogs, mode: FileMode.write);
    // } on Exception catch (_) {
    //   Buzz.error();
    // }
  }

  static Future<List<LogDefinition>> readLogs({DateTime? date}) async {
    return await LogDbProvider.db.getLogs(
      year: date?.year,
      month: date?.month,
      day: date?.day,
    );
    // try {
    //   final logFilePath = await getLogFilePath(date: date);
    //   final logFile = File(logFilePath);

    //   if (await logFile.exists()) {
    //     final content = await logFile.readAsString();
    //     if (content.isNotEmpty) {
    //       final decoded = jsonDecode(content);
    //       return List<Map<String, dynamic>>.from(decoded)
    //           .map((map) => LogDefinition.fromMap(map))
    //           .toList();
    //     }
    //   }
    // } on Exception catch (_) {}

    // return [];
  }

  // static Future<List<LogDefinition>> updateLogs(
  //     {required List<String> logsIds}) async {}
}
