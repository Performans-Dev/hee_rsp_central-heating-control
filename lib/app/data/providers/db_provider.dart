// ignore_for_file: avoid_print

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/app_user/app_user.dart';
import 'package:central_heating_control/app/data/models/input_outputs/analog_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_output.dart';
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

  Future<void> createDbStructure(Database db) async {
    // users
    await db.execute(Keys.dropTableAppUsers);
    await db.execute(Keys.createTableAppUsers);
    await db.execute(Keys.populateTableAppUsers);

    // heaters

    // zones

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
  }

  //#region MARK input-output
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
}
