// ignore_for_file: avoid_print

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/app_user/app_user.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/data/models/input_outputs/analog_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_output.dart';
import 'package:central_heating_control/app/data/models/zone/zone.dart';
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
        onCreate: (db, version) async {
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
  Future<List<ZoneDefinition>> getZones() async {
    final db = await database;
    if (db == null) return [];
    final rows = await db.query(Keys.tableZones);
    return rows.map((row) => ZoneDefinition.fromMap(row)).toList();
  }

  Future<int> saveZone(ZoneDefinition zone) async {
    final db = await database;
    if (db == null) return 0;
    return await db.update(
        Keys.tableZones, where: 'id = ?', whereArgs: [zone.id], zone.toMap());
  }

  Future<int> insertZone(ZoneDefinition zone) async {
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
    final rows = await db.query(Keys.tableDevices);
    return rows.map((row) => Device.fromMap(row)).toList();
  }

  Future<int> saveDevice(Device device) async {
    final db = await database;
    if (db == null) return 0;
    return await db.update(
        Keys.tableDevices,
        where: 'id = ?',
        whereArgs: [device.id],
        device.toMap());
  }

  Future<int> insertDevice(Device device) async {
    final db = await database;
    if (db == null) return 0;
    return await db.insert(Keys.tableDevices, device.toMap());
  }

  Future<int> deleteDevice(int id) async {
    final db = await database;
    if (db == null) return 0;
    return await db.delete(Keys.tableDevices, where: 'id = ?', whereArgs: [id]);
  }
  //#endregion

  //#region MARK: DeviceInputs
  Future<List<DeviceInputs>> getDeviceInputs() async {
    final db = await database;
    if (db == null) return [];
    final rows = await db.query(Keys.tableDeviceInputs);
    return rows.map((row) => DeviceInputs.fromMap(row)).toList();
  }

  Future<int> saveDeviceInput(DeviceInputs deviceInput) async {
    final db = await database;
    if (db == null) return 0;
    return await db.update(
        Keys.tableDeviceInputs,
        where: 'id = ?',
        whereArgs: [deviceInput.id],
        deviceInput.toMap());
  }

  Future<int> insertDeviceInput(DeviceInputs deviceInput) async {
    final db = await database;
    if (db == null) return 0;
    return await db.insert(Keys.tableDeviceInputs, deviceInput.toMap());
  }

  Future<int> deleteDeviceInput(int id) async {
    final db = await database;
    if (db == null) return 0;
    return await db
        .delete(Keys.tableDeviceInputs, where: 'id = ?', whereArgs: [id]);
  }
  //#endregion

  //#region MARK: DeviceOutputs
  Future<List<DeviceOutputs>> getDeviceOutputs() async {
    final db = await database;
    if (db == null) return [];
    final rows = await db.query(Keys.tableDeviceOutputs);
    return rows.map((row) => DeviceOutputs.fromMap(row)).toList();
  }

  Future<int> saveDeviceOutput(DeviceOutputs deviceOutput) async {
    final db = await database;
    if (db == null) return 0;
    return await db.update(
        Keys.tableDeviceOutputs,
        where: 'id = ?',
        whereArgs: [deviceOutput.id],
        deviceOutput.toMap());
  }

  Future<int> insertDeviceOutput(DeviceOutputs deviceOutput) async {
    final db = await database;
    if (db == null) return 0;
    return await db.insert(Keys.tableDeviceOutputs, deviceOutput.toMap());
  }

  Future<int> deleteDeviceOutput(int id) async {
    final db = await database;
    if (db == null) return 0;
    return await db
        .delete(Keys.tableDeviceOutputs, where: 'id = ?', whereArgs: [id]);
  }
  //#endregion

  //#region MARK: DeviceStates
  Future<List<DeviceStates>> getDeviceStates() async {
    final db = await database;
    if (db == null) return [];
    final rows = await db.query(Keys.tableDeviceStates);
    return rows.map((row) => DeviceStates.fromMap(row)).toList();
  }

  Future<int> saveDeviceState(DeviceStates deviceState) async {
    final db = await database;
    if (db == null) return 0;
    return await db.update(
        Keys.tableDeviceStates,
        where: 'id = ?',
        whereArgs: [deviceState.id],
        deviceState.toMap());
  }

  Future<int> insertDeviceState(DeviceStates deviceState) async {
    final db = await database;
    if (db == null) return 0;
    return await db.insert(Keys.tableDeviceStates, deviceState.toMap());
  }

  Future<int> deleteDeviceState(int id) async {
    final db = await database;
    if (db == null) return 0;
    return await db
        .delete(Keys.tableDeviceStates, where: 'id = ?', whereArgs: [id]);
  }
  //#endregion
}
