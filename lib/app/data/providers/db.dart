import 'dart:developer';
import 'dart:io' as io;
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbProvider {
  DbProvider._();
  static final DbProvider db = DbProvider._();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  //#region INIT
  Future<Database?> initDb() async {
    var dbFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
    String dbPath = p.join(
      appDocumentsDir.path,
      Keys.databasePath,
      Keys.databaseName,
    );
    log(dbPath);
    return await dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        onCreate: (db, version) async {
          await createDatabaseStructure(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          //TODO: backup users

          await createDatabaseStructure(db);
          //TODO: restore users
        },
        singleInstance: true,
        version: Keys.databaseVersion,
      ),
    );
  }

  Future<void> createDatabaseStructure(Database db) async {
    await db.execute(Keys.dbDropUsers);
    await db.execute(Keys.dbCreateUsers);
    await db.execute(Keys.dbDropSensors);
    await db.execute(Keys.dbCreateSensors);
  }
  //#endregion

  //MARK: USERS

  //#region USER INSERT
  Future<int> addUser(AppUser user) async {
    final db = await database;
    if (db == null) return -1;
    try {
      int id = await db.insert(
        Keys.tableUsers,
        user.toSQL(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region USER DELETE
  Future<int> deleteUser(AppUser user) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.delete(
        Keys.tableUsers,
        where: Keys.queryUsername,
        whereArgs: [user.username],
      );
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region USER UPDATE
  Future<int> updateUser(AppUser user) async {
    final db = await database;
    if (db == null) return -1;
    try {
      int updateCount = await db.update(
        Keys.tableUsers,
        user.toMap(),
        where: Keys.queryUsername,
        whereArgs: [user.username],
      );
      return updateCount;
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region USER SELECT ALL
  Future<List<AppUser>> getUsers() async {
    final users = <AppUser>[];
    final db = await database;
    if (db == null) return users;
    try {
      final result = await db.query(Keys.tableUsers);
      if (result.isNotEmpty) {
        for (final item in result) {
          final user = AppUser.fromSQL(item);
          users.add(user);
        }
      }
    } on Exception catch (err) {
      log(err.toString());
      return users;
    }
    return users;
  }
  //#endregion

  //#region USER SELECT ADMINS
  Future<List<AppUser>> getAdminUsers() async {
    final users = <AppUser>[];
    final db = await database;
    if (db == null) return users;
    try {
      final result = await db.query(
        Keys.tableUsers,
        where: Keys.queryIsAdmin,
        whereArgs: [1],
      );
      if (result.isNotEmpty) {
        for (final item in result) {
          final user = AppUser.fromSQL(item);
          users.add(user);
        }
      }
    } on Exception catch (err) {
      log(err.toString());
      return users;
    }
    return users;
  }
  //#endregion

  //#region USER SELECT ONE
  Future<AppUser?> getUser({
    required String username,
    required String pin,
  }) async {
    final db = await database;
    if (db == null) return null;
    try {
      final result = await db.query(
        Keys.tableUsers,
        where: 'username=? AND pin=?',
        whereArgs: [username, pin],
      );
      if (result.isNotEmpty) {
        final user = AppUser.fromSQL(result.first);
        return user;
      }
      return null;
    } on Exception catch (err) {
      log(err.toString());
      return null;
    }
  }
  //#endregion

  //MARK: SENSORS

  //#region SENSOR INSERT
  Future<int> addSensor(SensorDevice sensor) async {
    final db = await database;
    if (db == null) return -1;
    try {
      final int id = await db.insert(
        Keys.tableSensors,
        sensor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region SENSOR DELETE
  Future<int> deleteSensor(SensorDevice sensor) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.delete(
        Keys.tableSensors,
        where: Keys.queryId,
        whereArgs: [sensor.id],
      );
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region SENSORS UPDATE
  Future<int> updateSensor(SensorDevice sensor) async {
    final db = await database;
    if (db == null) return -1;
    try {
      final int updateCount = await db.update(
        Keys.tableSensors,
        sensor.toMap(),
        where: Keys.queryId,
        whereArgs: [sensor.id],
      );
      return updateCount;
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region SENSORS SELECT ALL
  Future<List<SensorDevice>> getSensors() async {
    final sensors = <SensorDevice>[];
    final db = await database;
    if (db == null) return sensors;
    try {
      final result = await db.query(Keys.tableSensors);
      if (result.isNotEmpty) {
        for (final map in result) {
          sensors.add(SensorDevice.fromMap(map));
        }
      }
    } on Exception catch (err) {
      log(err.toString());
      return sensors;
    }
    return sensors;
  }
  //#endregion

  //#region SENSORS SELECT ONE
  Future<SensorDevice?> getSensor({required String id}) async {
    final db = await database;
    if (db == null) return null;
    try {
      final result = await db.query(
        Keys.tableSensors,
        where: Keys.queryId,
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        return SensorDevice.fromMap(result.first);
      }
      return null;
    } on Exception catch (err) {
      log(err.toString());
      return null;
    }
  }
  //#endregion
}
