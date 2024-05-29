import 'dart:developer';
import 'dart:io' as io;
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/plan.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
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
    // await db.execute(Keys.dbDropUsers);
    // await db.execute(Keys.dbCreateUsers);

    // await db.execute(Keys.dbDropSensors);
    // await db.execute(Keys.dbCreateSensors);

    // await db.execute(Keys.dbDropHeaters);
    // await db.execute(Keys.dbCreateHeaters);

    // await db.execute(Keys.dbDropZones);
    // await db.execute(Keys.dbCreateZones);

    // await db.execute(Keys.dbDropZoneUsers);
    // await db.execute(Keys.dbCreateZoneUsers);

    // await db.execute(Keys.dbDropZoneSensors);
    // await db.execute(Keys.dbCreateZoneSensors);

    // await db.execute(Keys.dbDropZoneHeaters);
    // await db.execute(Keys.dbCreateZoneHeaters);
    //
    await db.execute(Keys.dbDropHardwareParameters);
    await db.execute(Keys.dbCreateHardwareParameters);
    //
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
  }
  //#endregion

  //MARK: USERS

  //#region USER INSERT
  Future<int> addUser(AppUser user) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.insert(
        Keys.tableUsers,
        user.toSQL(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
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
      return await db.update(
        Keys.tableUsers,
        user.toSQL(),
        where: Keys.queryId,
        whereArgs: [user.id],
      );
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
          users.add(AppUser.fromSQL(item));
        }
      }
    } on Exception catch (err) {
      log(err.toString());
      return users;
    }
    return users;
  }
  //#endregion

  //#region USER SELECT BY ZONE
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
          users.add(AppUser.fromSQL(item));
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
          users.add(AppUser.fromSQL(item));
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
        return AppUser.fromSQL(result.first);
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
      return await db.insert(
        Keys.tableSensors,
        sensor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
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
      return await db.update(
        Keys.tableSensors,
        sensor.toMap(),
        where: Keys.queryId,
        whereArgs: [sensor.id],
      );
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
      log(err.toString());
      return null;
    }
  }
  //#endregion

  //MARK: HEATER

  //#region HEATER INSERT
  Future<int> addHeater(HeaterDevice heater) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.insert(
        Keys.tableHeaters,
        heater.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region HEATER DELETE
  Future<int> deleteHeater(HeaterDevice heater) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.delete(
        Keys.tableHeaters,
        where: Keys.queryId,
        whereArgs: [heater.id],
      );
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region HEATER UPDATE
  Future<int> updateHeater(HeaterDevice heater) async {
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
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region HEATER SELECT ALL
  Future<List<HeaterDevice>> getHeaters() async {
    final heaters = <HeaterDevice>[];
    final db = await database;
    if (db == null) return heaters;
    try {
      final result = await db.query(Keys.tableHeaters);
      if (result.isNotEmpty) {
        for (final map in result) {
          heaters.add(HeaterDevice.fromMap(map));
        }
      }
    } on Exception catch (err) {
      log(err.toString());
      return heaters;
    }
    return heaters;
  }
  //#endregion

  //#region HEATERS SELECT ONE
  Future<HeaterDevice?> getHeater({required int id}) async {
    final db = await database;
    if (db == null) return null;
    try {
      final result = await db.query(
        Keys.tableHeaters,
        where: Keys.queryId,
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        return HeaterDevice.fromMap(result.first);
      }
      return null;
    } on Exception catch (err) {
      log(err.toString());
      return null;
    }
  }
  //#endregion

  //MARK: ZONE

  //#region ZONE INSERT
  Future<int> addZone(ZoneDefinition zone) async {
    final db = await database;
    if (db == null) return -1;
    try {
      final zoneUsers = zone.users;
      final zoneSensors = zone.sensors;
      final zoneDevices = zone.heaters;
      final zoneMap = {
        'name': zone.name,
        'color': zone.color,
        'state': zone.state,
      };
      final int id = await db.insert(Keys.tableZones, zoneMap);
      for (final user in zoneUsers) {
        await db.insert(Keys.tableZoneUsers, {'zoneId': id, 'userId': user.id});
      }
      for (final sensor in zoneSensors) {
        await db.insert(
            Keys.tableZoneSensors, {'zoneId': id, 'sensorId': sensor.id});
      }
      for (final device in zoneDevices) {
        await db.insert(
            Keys.tableZoneHeaters, {'zoneId': id, 'heaterId': device.id});
      }
      return id;
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region ZONE DELETE
  Future<int> deleteZone(ZoneDefinition zone) async {
    final db = await database;
    if (db == null) return -1;
    try {
      final int zoneUsersToDelete = await db.delete(Keys.tableZoneUsers,
          where: Keys.queryZoneId, whereArgs: [zone.id]);
      final int zoneSensorsToDelete = await db.delete(Keys.tableZoneSensors,
          where: Keys.queryZoneId, whereArgs: [zone.id]);
      final int zoneHeatersToDelete = await db.delete(Keys.tableZoneHeaters,
          where: Keys.queryZoneId, whereArgs: [zone.id]);
      final int result = await db.delete(
        Keys.tableZones,
        where: Keys.queryId,
        whereArgs: [zone.id],
      );
      log('Deleting zone #${zone.id}, with $zoneUsersToDelete users, $zoneSensorsToDelete sensors, $zoneHeatersToDelete heaters with result $result');
      return result;
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region ZONE UPDATE
  Future<int> updateZone(ZoneDefinition zone) async {
    final db = await database;
    if (db == null) return -1;
    try {
      final zoneUsers = zone.users;
      final zoneSensors = zone.sensors;
      final zoneDevices = zone.heaters;
      final zoneMap = {
        'id': zone.id,
        'name': zone.name,
        'color': zone.color,
        'state': zone.state,
      };
      final int updateResult = await db.update(
        Keys.tableZones,
        zoneMap,
        where: Keys.queryId,
        whereArgs: [zone.id],
      );
      final int zoneUsersToDelete = await db.delete(Keys.tableZoneUsers,
          where: Keys.queryZoneId, whereArgs: [zone.id]);

      for (final user in zoneUsers) {
        await db.insert(
            Keys.tableZoneUsers, {'zoneId': zone.id, 'userId': user.id});
      }
      final int zoneSensorsToDelete = await db.delete(Keys.tableZoneSensors,
          where: Keys.queryZoneId, whereArgs: [zone.id]);
      for (final sensor in zoneSensors) {
        await db.insert(
            Keys.tableZoneSensors, {'zoneId': zone.id, 'sensorId': sensor.id});
      }
      final int zoneHeatersToDelete = await db.delete(Keys.tableZoneHeaters,
          where: Keys.queryZoneId, whereArgs: [zone.id]);
      for (final device in zoneDevices) {
        await db.insert(
            Keys.tableZoneHeaters, {'zoneId': zone.id, 'heaterId': device.id});
      }
      return updateResult +
          zoneUsersToDelete +
          zoneSensorsToDelete +
          zoneHeatersToDelete;
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region ZONE SELECT ONE
  Future<ZoneDefinition?> getZone({required int id}) async {
    final db = await database;
    if (db == null) return null;
    try {
      final result = await db.query(
        Keys.tableZones,
        where: Keys.queryId,
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        var zone = ZoneDefinition.fromMap(result.first);

        zone.users = await getZoneUsers(zoneId: id);
        //zone.sensors = await getZoneSensors(zoneId: id);
        //zone.heaters = await getZoneHeaters(zoneId: id);
        //
        return zone;
      }
    } on Exception catch (err) {
      log(err.toString());
      return null;
    }
    return null;
  }
  //#endregion

  //#region ZONE SELECT ALL
  Future<List<ZoneDefinition>> getZoneList() async {
    final zones = <ZoneDefinition>[];
    final db = await database;
    if (db == null) return zones;
    try {
      final data = await db.query(Keys.tableZones);
      for (final map in data) {
        var zone = ZoneDefinition.fromMap(map);
        zone.users = await getZoneUsers(zoneId: zone.id);
        //zone.sensors = await getZoneSensors(zoneId: zone.id);
        //zone.heaters = await getZoneHeaters(zoneId: zone.id);
        zones.add(zone);
      }
      return zones;
    } on Exception catch (err) {
      log(err.toString());
      return zones;
    }
  }
  //#endregion

  //MARK: RELATIONS

  //#region ZONE USERS
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
      // var whereArgs =
      //     userIds.map((e) => e['userId']).toList().join(',').toString();

      // final result = await db.query(
      //   Keys.tableUsers,
      //   where: Keys.queryIdIn,
      //   whereArgs: [whereArgs],
      // );

      final result = await db.rawQuery(
          "SELECT * FROM users WHERE id IN (${userIds.map((e) => e['userId']).toList().join(',')}) LIMIT 100");

      if (result.isNotEmpty) {
        for (final map in result) {
          zoneUsers.add(AppUser.fromSQL(map));
        }
      }
      return zoneUsers;
    } on Exception catch (err) {
      log(err.toString());
      return zoneUsers;
    }
  }
  //#endregion

  //#region ZONE SENSORS
  // Future<List<SensorDevice>> getZoneSensors({required int zoneId}) async {
  //   final zoneSensors = <SensorDevice>[];
  //   final db = await database;
  //   if (db == null) return zoneSensors;
  //   try {
  //     final sensorIds = await db.query(
  //       Keys.tableZoneSensors,
  //       where: Keys.queryZoneId,
  //       whereArgs: [zoneId],
  //     );
  //     final result = await db.query(
  //       Keys.tableSensors,
  //       where: Keys.queryIdIn,
  //       whereArgs: [
  //         sensorIds.map((e) => e['sensorId']).toList().join(',').toString()
  //       ],
  //     );
  //     if (result.isNotEmpty) {
  //       for (final map in result) {
  //         zoneSensors.add(SensorDevice.fromMap(map));
  //       }
  //     }
  //     return zoneSensors;
  //   } on Exception catch (err) {
  //     log(err.toString());
  //     return zoneSensors;
  //   }
  // }
  //#endregion

  //#region ZONE HEATERS
  // Future<List<HeaterDevice>> getZoneHeaters({required int zoneId}) async {
  //   final zoneHeaters = <HeaterDevice>[];
  //   final db = await database;
  //   if (db == null) return zoneHeaters;
  //   try {
  //     final heaterIds = await db.query(Keys.tableZoneHeaters,
  //         where: Keys.queryZoneId, whereArgs: [zoneId], columns: ['heaterId']);
  //     final result = await db.query(
  //       Keys.tableHeaters,
  //       where: Keys.queryIdIn,
  //       whereArgs: [
  //         heaterIds.map((e) => e['heaterId']).toList().join(',').toString()
  //       ],
  //     );
  //     if (result.isNotEmpty) {
  //       for (final map in result) {
  //         zoneHeaters.add(HeaterDevice.fromMap(map));
  //       }
  //     }
  //     return zoneHeaters;
  //   } on Exception catch (err) {
  //     log(err.toString());
  //     return zoneHeaters;
  //   }
  // }
  //#endregion

  //MARK: HARDWARE

  //MARK: PLANS

  //#region PLAN LIST
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
      log(err.toString());
      return plans;
    }
  }

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
      log(err.toString());
      return null;
    }
  }

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
      log(err.toString());
      return null;
    }
  }

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
      log(err.toString());
      return null;
    }
  }

  Future<bool> deletePlanAndDetails({required int planId}) async {
    final db = await database;
    if (db == null) return false;
    try {
      final planToDelete = await getPlanById(planId: planId);
      if (planToDelete?.isDefault == 1) {
        return false;
      }
      final itemsToDelete = await getPlanDetails(planId: planId);
      await removePlanDetails(planDetails: itemsToDelete);
      final int result = await db.delete(
        Keys.tablePlans,
        where: Keys.queryId,
        whereArgs: [planId],
      );
      return result > 0;
    } on Exception catch (err) {
      log(err.toString());
      return false;
    }
  }
  //#endregion

  //#region PLAN DETAILS
  Future<List<PlanDetail>> getPlanDetails({int? planId}) async {
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
      log(err.toString());
      return planDetails;
    }
  }

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
          where: Keys.queryDayAndHour,
          whereArgs: [item.day, item.hour],
        );

        await db.insert(
          Keys.tablePlanDetails,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return getPlanDetails(planId: planDetails.first.planId);
    } on Exception catch (err) {
      log(err.toString());
      return result;
    }
  }

  Future<List<PlanDetail>> removePlanDetails(
      {required List<PlanDetail> planDetails}) async {
    final result = <PlanDetail>[];
    final db = await database;
    if (db == null) return result;
    try {
      for (var item in result) {
        await db.delete(
          Keys.tablePlanDetails,
          where: Keys.queryId,
          whereArgs: [item.id],
        );
      }
      return getPlanDetails(planId: planDetails.first.planId);
    } on Exception catch (err) {
      log(err.toString());
      return result;
    }
  }

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
        planBy: item.planBy,
      ));
    }
    return await addPlanDetails(planDetails: newItems);
  }
  //#endregion
}
