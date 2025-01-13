import 'dart:developer';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/models/hardware.dart';
import 'package:central_heating_control/app/data/models/heater.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/models/plan.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/temperature_value.dart';
import 'package:central_heating_control/app/data/models/zone.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:path/path.dart' as p;
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

  //#region MARK: INIT

  /// Initializes the database by opening a connection to the database file.
  ///
  /// This function creates the database file if it doesn't exist and performs
  /// necessary migrations if the database version is different from the expected
  /// version.
  ///
  /// Returns a [Future] that completes with a [Database] object representing
  /// the opened database connection. If the database file cannot be opened,
  /// the function returns `null`.
  ///
  /// Throws a [DatabaseException] if there is an error opening the database.
  Future<Database?> initDb() async {
    var dbFactory = databaseFactoryFfi;
    final dbPath = await getDbPath();
    if (dbPath == null) return null;
    log(dbPath);
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
        version: Keys.databaseVersion,
      ),
    );
  }

  //MARK: PATH
  Future<String?> getDbPath() async {
    try {
      String dbPath = p.join(
        Box.documentsDirectoryPath,
        Keys.databasePath,
        Keys.databaseName,
      );
      return dbPath;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  /// Creates the database structure by executing SQL commands to drop and create tables.
  ///
  /// This function drops and creates the following tables:
  /// - Users
  /// - Sensors
  /// - Heaters
  /// - Zones
  /// - ZoneUsers
  /// - HardwareParameters
  /// - Plans
  /// - PlanDetails
  ///
  /// After creating the tables, it inserts a default plan and default plan details.
  ///
  /// Parameters:
  /// - `db`: The [Database] object representing the database connection.
  ///
  /// Returns:
  /// - A [Future] that completes when the database structure is created.
  /// MARK: SRUCTURE
  Future<void> createDatabaseStructure(Database db) async {
    await db.execute(Keys.dbDropUsers);
    await db.execute(Keys.dbCreateUsers);

    await db.execute(Keys.dbDropSensors);
    await db.execute(Keys.dbCreateSensors);
    for (int i = 1; i <= 4; i++) {
      await db.execute(Keys.dbInsertSensor.replaceAll('{INDEX}', i.toString()));
    }
    await db.execute(Keys.dbDropHeaters);
    await db.execute(Keys.dbCreateHeaters);

    await db.execute(Keys.dbDropZones);
    await db.execute(Keys.dbCreateZones);
    await db.execute(Keys.dbInsertSampleZones);

    await db.execute(Keys.dbDropZoneUsers);
    await db.execute(Keys.dbCreateZoneUsers);

    // await db.execute(Keys.dbDropHardwareParameters);
    // await db.execute(Keys.dbCreateHardwareParameters);

    await db.execute(Keys.dbDropPlans);
    await db.execute(Keys.dbCreatePlans);

    await db.execute(Keys.dbDropPlanDetails);
    await db.execute(Keys.dbCreatePlanDetails);
    //add default plan
    await db.execute(Keys.dbInsertDefaultPlan);
    for (int h = 8; h <= 17; h++) {
      for (int d = 0; d <= 5; d++) {
        await db.execute(Keys.dbInsertDefaultPlanDetails
            .replaceAll('{H}', h.toString())
            .replaceAll('{D}', d.toString()));
      }
    }

    await db.execute(Keys.dbDropHardwareTable);
    await db.execute(Keys.dbCreateHardwareTable);
    await db.execute(Keys.dbInsertMainBoardHardwareExtension);
    await db.execute(Keys.dbInsertSampleHardwareExtension);

    await db.execute(Keys.dbDropTemperatureValues);
    await db.execute(Keys.dbCreateTemperatureValues);

    await db.execute(Keys.dbDropUsers);
    await db.execute(Keys.dbCreateUsers);
  }

  // MARK: RESET DB
  Future<void> resetDb() async {
    final db = await database;
    if (db == null) return;
    await createDatabaseStructure(db);
  }
  //#endregion

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  //#region MARK: USER INSERT
  /// Inserts a new user into the database.
  ///
  /// The [user] parameter represents the user object to be inserted.
  ///
  /// Returns the number of rows affected by the insertion. If the database is not
  /// available, -1 is returned.
  Future<int> addUser(AppUser user) async {
    final db = await database;
    if (db == null) return -2;

    final existingUser = await getUserByName(username: user.username);
    if (existingUser != null) return -3;
    if (user.level == AppUserLevel.developer) {
      final developerUser = await db.query(
        Keys.tableUsers,
        where: 'level=?',
        whereArgs: [AppUserLevel.developer.index],
      );

      if (developerUser.isNotEmpty) {
        return -4;
      }
    }
    try {
      return await db.insert(
        Keys.tableUsers,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: USER DELETE
  /// Deletes a user from the database.
  ///
  /// The [user] parameter represents the user object to be deleted.
  ///
  /// Returns the number of rows affected by the deletion. If the database is not
  /// available, -1 is returned.
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
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: USER UPDATE
  Future<int> updateUser(AppUser user) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.update(
        Keys.tableUsers,
        user.toMap(),
        where: Keys.queryId,
        whereArgs: [user.id],
      );
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: USER PIN
  Future<int> savePin(String newPin, String username) async {
    final db = await database;
    if (db == null) return -1;

    try {
      final result = await db.update(
        Keys.tableUsers,
        {"pin": newPin},
        where: Keys.queryUsername,
        whereArgs: [username],
      );
      return result;
    } on Exception catch (_) {
      return -2;
    }
  }
  //#endregion

  //#region MARK: USER SELECT ALL
  Future<List<AppUser>> getUsers() async {
    final users = <AppUser>[];
    final db = await database;
    if (db == null) return users;
    try {
      final result = await db.query(Keys.tableUsers);
      if (result.isNotEmpty) {
        for (final item in result) {
          users.add(AppUser.fromMap(item));
        }
      }
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return users;
    }
    return users;
  }
  //#endregion

  //#region MARK: GET USER BY NAME
  Future<AppUser?> getUserByName({required String username}) async {
    final db = await database;
    if (db == null) return null;
    try {
      final result = await db.query(
        Keys.tableUsers,
        where: 'username=?',
        whereArgs: [username],
      );
      if (result.isNotEmpty) {
        return AppUser.fromMap(result.first);
      }
      return null;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return null;
    }
  }
  //#endregion

  //#region MARK: USER SELECT BY ZONE
  Future<List<AppUser>> getUsersByZone() async {
    final users = <AppUser>[];
    final db = await database;
    if (db == null) return users;
    try {
      final result = await db.query(
        Keys.tableUsers,
        where: Keys.queryIdIn,
        whereArgs: [],
      );
      if (result.isNotEmpty) {
        for (final item in result) {
          users.add(AppUser.fromMap(item));
        }
      }
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return users;
    }
    return users;
  }
  //#endregion

  //#region MARK: USER ADMINS
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
          users.add(AppUser.fromMap(item));
        }
      }
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return users;
    }
    return users;
  }
  //#endregion

  //#region MARK: USER ONE
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
        return AppUser.fromMap(result.first);
      }
      return null;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return null;
    }
  }
  //#endregion

  //#region MARK: SENSOR INSERT
  Future<int> addSensor(SensorDevice sensor) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.insert(
        Keys.tableSensors,
        sensor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: SENSOR DELETE
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
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: SENSORS UPDATE
  Future<int> updateSensor(SensorDevice sensor) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.update(
        Keys.tableSensors,
        sensor.toMap(),
        where: Keys.queryId,
        whereArgs: [sensor.id],
      );
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: SENSORS SELECT ALL
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
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return sensors;
    }
    return sensors;
  }
  //#endregion

  //#region MARK: SENSORS SELECT ONE
  Future<SensorDevice?> getSensor({required int id}) async {
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
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return null;
    }
  }
  //#endregion

  //#region MARK: HEATER INSERT
  Future<int> addHeater(Heater heater) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.insert(
        Keys.tableHeaters,
        heater.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: HEATER DELETE
  Future<int> deleteHeater(Heater heater) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.delete(
        Keys.tableHeaters,
        where: Keys.queryId,
        whereArgs: [heater.id],
      );
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: HEATER UPDATE
  Future<int> updateHeater(Heater heater) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.update(
        Keys.tableHeaters,
        heater.toMap(),
        where: Keys.queryId,
        whereArgs: [heater.id],
      );
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: HEATER SELECT ALL
  Future<List<Heater>> getHeaters() async {
    final heaters = <Heater>[];
    final db = await database;
    if (db == null) return heaters;
    try {
      final result = await db.query(Keys.tableHeaters);
      if (result.isNotEmpty) {
        for (final map in result) {
          final h = Heater.fromMap(map);
          heaters.add(h);
        }
      }
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return heaters;
    }
    return heaters;
  }
  //#endregion

  //#region MARK: HEATERS SELECT ONE
  Future<Heater?> getHeater({required int id}) async {
    final db = await database;
    if (db == null) return null;
    try {
      final result = await db.query(
        Keys.tableHeaters,
        where: Keys.queryId,
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        return Heater.fromMap(result.first);
      }
      return null;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return null;
    }
  }
  //#endregion

  //#region MARK: ZONE INSERT
  Future<int> addZone(Zone zone) async {
    final db = await database;
    if (db == null) return -1;
    try {
      final zoneUsers = zone.users;

      final int id = await db.insert(Keys.tableZones, zone.toDb());
      for (final user in zoneUsers) {
        await db.insert(Keys.tableZoneUsers, {'zoneId': id, 'userId': user.id});
      }

      return id;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: ZONE DELETE
  Future<int> deleteZone(Zone zone) async {
    final db = await database;
    if (db == null) return -1;
    try {
      final int zoneUsersToDelete = await db.delete(Keys.tableZoneUsers,
          where: Keys.queryZoneId, whereArgs: [zone.id]);

      final int heaterResult = await db.delete(
        Keys.tableHeaters,
        where: Keys.queryZoneId,
        whereArgs: [zone.id],
      );

      final int result = await db.delete(
        Keys.tableZones,
        where: Keys.queryId,
        whereArgs: [zone.id],
      );
      LogService.addLog(
        LogDefinition(
          message:
              'Deleting zone #${zone.id}, with $zoneUsersToDelete users, $heaterResult heaters with result $result',
          level: LogLevel.critical,
          type: LogType.database,
        ),
      );
      return result;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: ZONE UPDATE
  Future<int> updateZone(Zone zone) async {
    final db = await database;
    if (db == null) return -1;
    try {
      final zoneUsers = zone.users;
      // final zoneSensors = zone.sensors;
      // final zoneDevices = zone.heaters;

      final int updateResult = await db.update(
        Keys.tableZones,
        zone.toDb(),
        where: Keys.queryId,
        whereArgs: [zone.id],
      );
      final int zoneUsersToDelete = await db.delete(Keys.tableZoneUsers,
          where: Keys.queryZoneId, whereArgs: [zone.id]);

      for (final user in zoneUsers) {
        await db.insert(
            Keys.tableZoneUsers, {'zoneId': zone.id, 'userId': user.id});
      }

      return updateResult + zoneUsersToDelete;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: ZONE ONE
  Future<Zone?> getZone({required int id}) async {
    final db = await database;
    if (db == null) return null;
    try {
      final result = await db.query(
        Keys.tableZones,
        where: Keys.queryId,
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        final users = await getZoneUsers(zoneId: id);
        final zone = Zone.fromDb(result.first, users);
        return zone;
      }
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return null;
    }
    return null;
  }
  //#endregion

  //#region MARK: ZONE  ALL
  Future<List<Zone>> getZoneList() async {
    final zones = <Zone>[];
    final db = await database;
    if (db == null) return zones;
    try {
      final data = await db.query(Keys.tableZones);
      for (final map in data) {
        final users =
            await getZoneUsers(zoneId: int.parse(map['id'].toString()));
        final zone = Zone.fromDb(map, users);
        zones.add(zone);
      }
      return zones;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return zones;
    }
  }
  //#endregion

  //#region MARK: ZONE USERS
  Future<List<AppUser>> getZoneUsers({required int zoneId}) async {
    final zoneUsers = <AppUser>[];
    final db = await database;
    if (db == null) return zoneUsers;
    try {
      final userIds = await db.query(
        Keys.tableZoneUsers,
        where: Keys.queryZoneId,
        whereArgs: [zoneId],
      );

      final result = await db.rawQuery(
          "SELECT * FROM users WHERE id IN (${userIds.map((e) => e['userId']).toList().join(',')}) LIMIT 100");

      if (result.isNotEmpty) {
        for (final map in result) {
          zoneUsers.add(AppUser.fromMap(map));
        }
      }
      return zoneUsers;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return zoneUsers;
    }
  }
  //#endregion

  //#region MARK: PLAN LIST
  Future<List<PlanDefinition>> getPlanDefinitions() async {
    final plans = <PlanDefinition>[];
    final db = await database;
    if (db == null) return plans;
    try {
      final data = await db.query(Keys.tablePlans);
      for (final map in data) {
        plans.add(PlanDefinition.fromMap(map));
      }
      return plans;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return plans;
    }
  }

  //#endregion

  //#region MARK: PLAN BY ID
  Future<PlanDefinition?> getPlanById({required int planId}) async {
    final db = await database;
    if (db == null) return null;
    try {
      final data = await db.query(
        Keys.tablePlans,
        where: Keys.queryId,
        whereArgs: [planId],
      );
      if (data.isNotEmpty) {
        final map = data.first;
        return PlanDefinition.fromMap(map);
      }
      return null;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return null;
    }
  }

  //#endregion

  //#region MARK: ADD PLAN
  Future<PlanDefinition?> addPlanDefinition(
      {required PlanDefinition plan}) async {
    final db = await database;
    if (db == null) return null;
    try {
      final id = await db.insert(
        Keys.tablePlans,
        plan.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      final data = await db.query(
        Keys.tablePlans,
        where: Keys.queryId,
        whereArgs: [id],
      );
      if (data.isNotEmpty) {
        final map = data.first;
        return PlanDefinition.fromMap(map);
      }
      return null;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return null;
    }
  }

  //#endregion

  //#region MARK: UPDATE PLAN
  Future<PlanDefinition?> updatePlanDefinition(
      {required PlanDefinition plan}) async {
    final db = await database;
    if (db == null) return null;
    try {
      final id = await db.update(
        Keys.tablePlans,
        plan.toMap(),
        where: Keys.queryId,
        whereArgs: [plan.id],
      );
      final data = await db.query(
        Keys.tablePlans,
        where: Keys.queryId,
        whereArgs: [id],
      );
      if (data.isNotEmpty) {
        final map = data.first;
        return PlanDefinition.fromMap(map);
      }
      return null;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return null;
    }
  }

  //#endregion

  //#region MARK: DELETE PLAN + DETAILS
  Future<bool> deletePlanAndDetails({required int planId}) async {
    final db = await database;
    if (db == null) return false;
    try {
      final planToDelete = await getPlanById(planId: planId);
      if (planToDelete?.isDefault == 1) {
        return false;
      }
      final itemsToDelete = await getPlanDetails(planId: planId);
      if (itemsToDelete.isNotEmpty) {
        await removePlanDetails(planDetails: itemsToDelete);
      } else {
        log('Plan details are empty.');
      }
      final int result = await db.delete(
        Keys.tablePlans,
        where: Keys.queryId,
        whereArgs: [planId],
      );
      return result > 0;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return false;
    }
  }
  //#endregion

  //#region MARK: PLAN DETAILS
  Future<List<PlanDetail>> getPlanDetails({
    int? planId,
  }) async {
    final planDetails = <PlanDetail>[];
    final db = await database;
    if (db == null) return planDetails;
    try {
      final data = planId != null
          ? await db.query(
              Keys.tablePlanDetails,
              where: Keys.queryPlanId,
              whereArgs: [planId],
            )
          : await db.query(Keys.tablePlanDetails);
      for (final map in data) {
        planDetails.add(PlanDetail.fromMap(map));
      }
      return planDetails;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return planDetails;
    }
  }

  //#endregion

  //#region MARK: ADD PLAN DETAILS
  Future<List<PlanDetail>> addPlanDetails({
    required List<PlanDetail> planDetails,
  }) async {
    final result = <PlanDetail>[];
    final db = await database;
    if (db == null) return result;
    try {
      for (var item in planDetails) {
        await db.delete(
          Keys.tablePlanDetails,
          where: Keys.queryDayAndHourAndPlanId,
          whereArgs: [item.day, item.hour, item.planId],
        );
        await db.insert(
          Keys.tablePlanDetails,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return getPlanDetails(planId: planDetails.first.planId);
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return result;
    }
  }

  //#endregion

  //#region MARK: REMOVE PLAN DETAILS
  Future<List<PlanDetail>> removePlanDetails(
      {required List<PlanDetail> planDetails}) async {
    final result = <PlanDetail>[];
    final db = await database;
    if (db == null) return result;
    try {
      for (var item in planDetails) {
        await db.delete(
          Keys.tablePlanDetails,
          where: Keys.queryId,
          whereArgs: [item.id],
        );
      }
      return getPlanDetails(planId: planDetails.first.planId);
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return result;
    }
  }

  //#endregion

  //#region MARK: COPY PLAN DETAILS
  Future<List<PlanDetail>> copyPlanDetails({
    required int sourcePlanId,
    required int targetPlanId,
  }) async {
    final sourceItems = await getPlanDetails(planId: sourcePlanId);
    final existingItems = await getPlanDetails(planId: targetPlanId);
    if (existingItems.isNotEmpty) {
      await removePlanDetails(planDetails: existingItems);
    }
    final newItems = <PlanDetail>[];
    for (var item in sourceItems) {
      newItems.add(PlanDetail(
        id: 0,
        planId: targetPlanId,
        hour: item.hour,
        day: item.day,
        level: item.level,
        degree: item.degree,
        hasThermostat: item.hasThermostat,
      ));
    }
    return await addPlanDetails(planDetails: newItems);
  }
  //#endregion

  //#region MARK: HARDWARE LIST
  Future<List<Hardware>> getHardwareDevices() async {
    final hwList = <Hardware>[];
    final db = await database;
    if (db == null) return hwList;
    try {
      final data = await db.query(Keys.tableHardwares);
      for (final map in data) {
        final ext = Hardware.fromDb(map);
        hwList.add(ext);
      }
      return hwList;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return hwList;
    }
  }
  //#endregion

  //#region MARK: HARDWARE ADD
  Future<int> addHardwareDevice(Hardware hw) async {
    final db = await database;
    if (db == null) return -1;
    try {
      final int id = await db.insert(
        Keys.tableHardwares,
        hw.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: HARDWARE DELETE
  Future<int> deleteHardwareDevice(Hardware hw) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.delete(
        Keys.tableHardwares,
        where: Keys.queryId,
        whereArgs: [hw.id],
      );
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: HARDWARE UPDATE
  Future<int> updateHardwareDevice(Hardware hw) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.update(
        Keys.tableHardwares,
        hw.toDb(),
        where: Keys.queryId,
        whereArgs: [hw.id],
      );
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: ADD TEMPERATURE VALUES
  Future<int> insertTemperatureValues(
      List<TemperatureValue> temperatureValues) async {
    final db = await database;
    if (db == null) return -2;
    try {
      for (var item in temperatureValues) {
        await db.insert(
          Keys.tableTemperatureValues,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return temperatureValues.length;
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion

  //#region MARK: GET TEMPERATURE VALUES
  Future<List<TemperatureValue>> getTemperatureValues(String name) async {
    final db = await database;
    if (db == null) return [];
    try {
      final data = await db.query(Keys.tableTemperatureValues,
          where: Keys.queryName, whereArgs: [name]);
      return data.map((map) => TemperatureValue.fromMap(map)).toList();
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return [];
    }
  }
  //#endregion

  //#region MARK: GET ALL TEMPERATURE
  Future<List<TemperatureValue>> getAllTemperatureValues() async {
    final db = await database;
    if (db == null) return [];
    try {
      final data = await db.query(
        Keys.tableTemperatureValues,
      );
      return data.map((map) => TemperatureValue.fromMap(map)).toList();
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return [];
    }
  }
  //#endregion

  //#region MARK: GET TEMPERATURE VALUE NAMES
  Future<List<String>> getTemperatureValueNames() async {
    final db = await database;
    if (db == null) return [];
    try {
      final data = await db.query(
        Keys.tableTemperatureValues,
        groupBy: "name",
        having: "count(name) > 0",
        columns: ["name"],
        distinct: true,
      );
      return data.map((e) => e['name'].toString()).toList();
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return [];
    }
  }
  //#endregion

  //#region MARK: DELETE TEMPERATURE VALUES
  Future<int> deleteTemperatureValues() async {
    final db = await database;
    if (db == null) return -2;
    try {
      return await db.delete(
        Keys.tableTemperatureValues,
      );
    } on Exception catch (err) {
      LogService.addLog(LogDefinition(
        message: err.toString(),
        level: LogLevel.error,
        type: LogType.database,
      ));
      return -1;
    }
  }
  //#endregion
}
