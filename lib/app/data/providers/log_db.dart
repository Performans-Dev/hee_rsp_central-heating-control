import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

class LogDbProvider {
  LogDbProvider._();
  static final LogDbProvider db = LogDbProvider._();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  Future<Database?> initDb() async {
    var dbFactory = databaseFactoryFfi;
    final dbPath = await getDbPath();
    if (dbPath == null) return null;
    return await dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        onCreate: (db, version) async {
          await createDatabaseStructure(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < newVersion) {
            await createDatabaseStructure(db);
          }
        },
        singleInstance: true,
        version: Keys.logDatabaseVersion,
      ),
    );
  }

  Future<String?> getDbPath() async {
    try {
      String dbPath = p.join(
        Box.documentsDirectoryPath,
        Keys.databasePath,
        Keys.logDatabaseName,
      );
      return dbPath;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<void> createDatabaseStructure(Database db) async {
    await db.execute('DROP TABLE IF EXISTS logs');

    await db.execute('CREATE TABLE IF NOT EXISTS logs ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'yearValue INTEGER NOT NULL DEFAULT 0,'
        'monthValue INTEGER NOT NULL DEFAULT 0,'
        'dayValue INTEGER NOT NULL DEFAULT 0,'
        'time INTEGER NOT NULL DEFAULT 0,'
        'message TEXT,'
        'level INTEGER NOT NULL DEFAULT 0,'
        'type INTEGER NOT NULL DEFAULT 0,'
        'status INTEGER NOT NULL DEFAULT 0'
        ')');
  }

  Future<int> addLog(LogDefinition data) async {
    final db = await database;
    if (db == null) return -2;
    try {
      final int id = await db.insert(
        'logs',
        data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (data.level == LogLevel.error) {
        AppController appController = Get.find();
        appController.setDisplayErrorNotification(true);
      }
      return id;
    } on Exception catch (_) {
      return -1;
    }
  }

  Future<List<LogDefinition>> getLogs({int? year, int? month, int? day}) async {
    final logs = <LogDefinition>[];
    final db = await database;
    if (db == null) return logs;
    try {
      String? query;
      List<String> arguments = [];
      if (year != null) {
        query = 'yearValue = ?';
        arguments.add(year.toString());
        if (month != null) {
          query += ' AND monthValue = ?';
          arguments.add(month.toString());
          if (day != null) {
            query += ' AND dayValue = ?';
            arguments.add(day.toString());
          }
        }
      }
      final result = await db.query(
        'logs',
        where: query,
        whereArgs: arguments,
      );

      if (result.isNotEmpty) {
        for (final map in result) {
          logs.add(LogDefinition.fromMap(map));
        }
      }
    } catch (_) {
      return logs;
    }
    return logs;
  }
}
