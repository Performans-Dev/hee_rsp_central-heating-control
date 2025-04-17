// ignore_for_file: avoid_print

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/app_user/app_user.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/data/models/input_outputs/analog_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_output.dart';
import 'package:central_heating_control/app/data/models/group/group.dart';
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

  Future<Database?> initDb() async {
    var dbFactory = databaseFactoryFfi;
    final dbPath = await getDbPath();
    if (dbPath == null) return null;
    print(dbPath);
    return await dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        onOpen: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
          final result = await db.rawQuery('PRAGMA foreign_keys');
          print('Foreign keys enabled: ${result.first.values.first == 1}');
        },
        onCreate: (db, version) async {
          await db.execute('PRAGMA foreign_keys = ON');
          await createDbStructure(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          // TODO: Handle backup
          await createDbStructure(db);
          // TODO: Handle restore
        },
        singleInstance: true,
        version: Keys.databaseVersion,
      ),
    );
  }

  Future<String?> getDbPath() async {
    try {
      String dbPath = p.join(
        Box.documentsDirectoryPath,
        Keys.databasePath,
        Keys.databaseName,
      );
      return dbPath;
    } catch (e) {
      return null;
    }
  }

  //#region MARK: Database
  Future<void> createDbStructure(Database db) async {
    // users
    await db.execute(Keys.dropTableAppUsers);
    await db.execute(Keys.createTableAppUsers);
    await db.execute(Keys.populateTableAppUsers);

    // heaters

    // zones
    await db.execute(Keys.dropTableZones);
    await db.execute(Keys.createTableZones);
    await db.execute(Keys.populateTableZones);

    // digital outputs
    await db.execute(Keys.dropTableDigitalOutputs);
    await db.execute(Keys.createTableDigitalOutputs);
    await db.execute(Keys.populateTableDigitalOutputs);

    // digital inputs
    await db.execute(Keys.dropTableDigitalInputs);
    await db.execute(Keys.createTableDigitalInputs);
    await db.execute(Keys.populateTableDigitalInputs);

    // analog inputs
    await db.execute(Keys.dropTableAnalogInputs);
    await db.execute(Keys.createTableAnalogInputs);
    await db.execute(Keys.populateTableAnalogInputs);

    // devices
    await db.execute(Keys.dropTableDevices);
    await db.execute(Keys.createTableDevices);

    // device inputs
    await db.execute(Keys.dropTableDeviceInputs);
    await db.execute(Keys.createTableDeviceInputs);

    // device outputs
    await db.execute(Keys.dropTableDeviceOutputs);
    await db.execute(Keys.createTableDeviceOutputs);

    // device states
    await db.execute(Keys.dropTableDeviceStates);
    await db.execute(Keys.createTableDeviceStates);

    // device levels
    await db.execute(Keys.dropTableDeviceLevels);
    await db.execute(Keys.createTableDeviceLevels);
  }
  //#endregion

  //#region MARK: Input Outputs
  Future<List<AnalogInput>> getAnalogInputs() async {
    final db = await database;
    if (db == null) return [];
    final rows = await db.query(Keys.tableAnalogInputs);
    return rows.map((row) => AnalogInput.fromMap(row)).toList();
  }

  Future<int> saveAnalogInput(AnalogInput analogInput) async {
    final db = await database;
    if (db == null) return 0;
    return await db.update(
        Keys.tableAnalogInputs,
        where: 'id = ?',
        whereArgs: [analogInput.id],
        analogInput.toMap());
  }

  Future<List<DigitalInput>> getDigitalInputs() async {
    final db = await database;
    if (db == null) return [];
    final rows = await db.query(Keys.tableDigitalInputs);
    return rows.map((row) => DigitalInput.fromMap(row)).toList();
  }

  Future<int> saveDigitalInput(DigitalInput digitalInput) async {
    final db = await database;
    if (db == null) return 0;
    return await db.update(
        Keys.tableDigitalInputs,
        where: 'id = ?',
        whereArgs: [digitalInput.id],
        digitalInput.toMap());
  }

  Future<List<DigitalOutput>> getDigitalOutputs() async {
    final db = await database;
    if (db == null) return [];
    final rows = await db.query(Keys.tableDigitalOutputs);
    return rows.map((row) => DigitalOutput.fromMap(row)).toList();
  }

  Future<int> saveDigitalOutput(DigitalOutput digitalOutput) async {
    final db = await database;
    if (db == null) return 0;
    return await db.update(
        Keys.tableDigitalOutputs,
        where: 'id = ?',
        whereArgs: [digitalOutput.id],
        digitalOutput.toMap());
  }
  //#endregion

  //#region MARK: AppUsers
  Future<List<AppUser>> getAppUsers() async {
    final db = await database;
    if (db == null) return [];
    final rows = await db.query(Keys.tableAppUsers);
    return rows.map((row) => AppUser.fromMap(row)).toList();
  }

  Future<int> saveAppUser(AppUser appUser) async {
    final db = await database;
    if (db == null) return 0;
    return await db.update(
        Keys.tableAppUsers,
        where: 'id = ?',
        whereArgs: [appUser.id],
        appUser.toMap());
  }

  Future<int> insertUser(AppUser appUser) async {
    final db = await database;
    if (db == null) return 0;
    return await db.insert(Keys.tableAppUsers, appUser.toMap());
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    if (db == null) return 0;
    return await db
        .delete(Keys.tableAppUsers, where: 'id = ?', whereArgs: [id]);
  }
  //#endregion

  //#region MARK: Zones
  Future<List<GroupDefinition>> getZones() async {
    final db = await database;
    if (db == null) return [];
    final rows = await db.query(Keys.tableZones);
    return rows.map((row) => GroupDefinition.fromMap(row)).toList();
  }

  Future<int> saveZone(GroupDefinition zone) async {
    final db = await database;
    if (db == null) return 0;
    return await db.update(
        Keys.tableZones, where: 'id = ?', whereArgs: [zone.id], zone.toMap());
  }

  Future<int> insertZone(GroupDefinition zone) async {
    final db = await database;
    if (db == null) return 0;
    return await db.insert(Keys.tableZones, zone.toMap());
  }

  Future<int> deleteZone(int id) async {
    final db = await database;
    if (db == null) return 0;

    /// TODO: implement later
    /// delete devices also inside that zone
    return await db.delete(Keys.tableZones, where: 'id = ?', whereArgs: [id]);
  }
  //#endregion

  //#region MARK: Devices
  Future<List<Device>> getDevices() async {
    final db = await database;
    if (db == null) return [];

    final deviceRows = await db.query(Keys.tableDevices);

    List<Device> devices = [];

    for (final row in deviceRows) {
      final deviceId = row['id'] as int;

      final results = await Future.wait([
        db.query(Keys.tableDeviceInputs,
            where: 'deviceId = ?', whereArgs: [deviceId]),
        db.query(Keys.tableDeviceOutputs,
            where: 'deviceId = ?', whereArgs: [deviceId]),
        db.query(Keys.tableDeviceStates,
            where: 'deviceId = ?', whereArgs: [deviceId]),
        db.query(Keys.tableDeviceLevels,
            where: 'deviceId = ?', whereArgs: [deviceId]),
      ]);

      final inputs = results[0] as List<Map<String, dynamic>>;
      final outputs = results[1] as List<Map<String, dynamic>>;
      final states = results[2] as List<Map<String, dynamic>>;
      final levels = results[3] as List<Map<String, dynamic>>;

      final device = Device.fromMap(row).copyWith(
        deviceInputs: inputs.map((e) => DeviceInput.fromMap(e)).toList(),
        deviceOutputs: outputs.map((e) => DeviceOutput.fromMap(e)).toList(),
        states: states.map((e) => DeviceState.fromMap(e)).toList(),
        levels: levels.map((e) => DeviceLevel.fromMap(e)).toList(),
      );

      devices.add(device);
    }

    return devices;
  }

  Future<Device?> getDevice(int id) async {
    final db = await database;
    if (db == null) return null;

    final rows =
        await db.query(Keys.tableDevices, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;

    final device = Device.fromMap(rows.first);

    // Optionally fetch child tables if needed:
    final results = await Future.wait([
      db.query(Keys.tableDeviceInputs, where: 'deviceId = ?', whereArgs: [id]),
      db.query(Keys.tableDeviceOutputs, where: 'deviceId = ?', whereArgs: [id]),
      db.query(Keys.tableDeviceStates, where: 'deviceId = ?', whereArgs: [id]),
      db.query(Keys.tableDeviceLevels, where: 'deviceId = ?', whereArgs: [id]),
    ]);

    final inputs = results[0] as List<Map<String, dynamic>>;
    final outputs = results[1] as List<Map<String, dynamic>>;
    final states = results[2] as List<Map<String, dynamic>>;
    final levels = results[3] as List<Map<String, dynamic>>;

    return device.copyWith(
      deviceInputs: inputs.map((e) => DeviceInput.fromMap(e)).toList(),
      deviceOutputs: outputs.map((e) => DeviceOutput.fromMap(e)).toList(),
      states: states.map((e) => DeviceState.fromMap(e)).toList(),
      levels: levels.map((e) => DeviceLevel.fromMap(e)).toList(),
    );
  }

  Future<int> updateDevice(Device device) async {
    final db = await database;
    if (db == null) return 0;

    final deviceMap = device.toMap();
    if (device.id == -1) {
      deviceMap.remove('id'); // Let DB auto-generate
    }
    deviceMap.remove('states');
    deviceMap.remove('levels');
    deviceMap.remove('deviceInputs');
    deviceMap.remove('deviceOutputs');
    deviceMap['modifiedOn'] = DateTime.now().millisecondsSinceEpoch;

    // Update the main device record
    final updatedCount = await db.update(
      Keys.tableDevices,
      deviceMap,
      where: 'id = ?',
      whereArgs: [device.id],
    );

    // Update related tables if necessary
    if (updatedCount > 0) {
      await _updateDeviceInputs(device.id, device.deviceInputs);
      await _updateDeviceOutputs(device.id, device.deviceOutputs);
      await _updateDeviceLevels(device.id, device.levels);
      await _updateDeviceStates(device.id, device.states);
    }

    return updatedCount;
  }

  Future<void> _updateDeviceInputs(
      int deviceId, List<DeviceInput> inputs) async {
    final db = await database;
    if (db == null) return;
    await db.delete(Keys.tableDeviceInputs,
        where: 'deviceId = ?', whereArgs: [deviceId]);
    for (final input in inputs) {
      await db.insert(Keys.tableDeviceInputs, {
        ...input.toMap(),
        'deviceId': deviceId,
      });
    }
  }

  Future<void> _updateDeviceOutputs(
      int deviceId, List<DeviceOutput> outputs) async {
    final db = await database;
    if (db == null) return;
    await db.delete(Keys.tableDeviceOutputs,
        where: 'deviceId = ?', whereArgs: [deviceId]);
    for (final output in outputs) {
      await db.insert(Keys.tableDeviceOutputs, {
        ...output.toMap(),
        'deviceId': deviceId,
      });
    }
  }

  Future<void> _updateDeviceLevels(
      int deviceId, List<DeviceLevel> levels) async {
    final db = await database;
    if (db == null) return;
    await db.delete(Keys.tableDeviceLevels,
        where: 'deviceId = ?', whereArgs: [deviceId]);
    for (final level in levels) {
      await db.insert(Keys.tableDeviceLevels, {
        ...level.toMap(),
        'deviceId': deviceId,
      });
    }
  }

  Future<void> _updateDeviceStates(
      int deviceId, List<DeviceState> states) async {
    final db = await database;
    if (db == null) return;
    await db.delete(Keys.tableDeviceStates,
        where: 'deviceId = ?', whereArgs: [deviceId]);
    for (final state in states) {
      await db.insert(Keys.tableDeviceStates, {
        ...state.toMap(),
        'deviceId': deviceId,
      });
    }
  }

  Future<int> insertDevice(Device device) async {
    final db = await database;
    if (db == null) return 0;

    final deviceMap = device.toMap();
    if (device.id == -1) {
      deviceMap.remove('id'); // Let DB auto-generate
    }
    deviceMap.remove('states');
    deviceMap.remove('levels');
    deviceMap.remove('deviceInputs');
    deviceMap.remove('deviceOutputs');

    final insertedId = await db.insert(Keys.tableDevices, deviceMap);

    // Insert inputs
    for (final input in device.deviceInputs) {
      await db.insert(Keys.tableDeviceInputs, {
        ...input.toMap(),
        'deviceId': insertedId,
      });
    }

    // Insert outputs
    for (final output in device.deviceOutputs) {
      await db.insert(Keys.tableDeviceOutputs, {
        ...output.toMap(),
        'deviceId': insertedId,
      });
    }

    // Insert states
    for (final state in device.states) {
      await db.insert(Keys.tableDeviceStates, {
        ...state.toMap(),
        'deviceId': insertedId,
      });
    }

    return insertedId;
  }

  Future<int> deleteDevice(int deviceId) async {
    final db = await database;
    if (db == null) return 0;

    return await db
        .delete(Keys.tableDevices, where: 'id = ?', whereArgs: [deviceId]);
  }

  //#endregion
}
