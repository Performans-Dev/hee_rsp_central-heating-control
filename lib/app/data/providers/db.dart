import 'dart:developer';
import 'dart:io' as io;
import 'package:central_heating_control/app/data/models/app_user.dart';
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
    String dbPath = p.join(appDocumentsDir.path, "databases", "chcDb.db");
    print(dbPath);
    return await dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        onCreate: (db, version) async {
          await db.execute(_dropUsersTable);
          await db.execute(_createUsersTable);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          //TODO: backup users
          await db.execute(_dropUsersTable);
          await db.execute(_createUsersTable);
          //TODO: restore users
        },
        singleInstance: true,
        version: 1,
      ),
    );
  }
  //#endregion

  //#region SQL
  static const _dropUsersTable = """
    DROP TABLE IF EXISTS users
  """;

  static const _createUsersTable = """
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      pin TEXT,
      isAdmin INTEGER NOT NULL DEFAULT 0
    )
  """;
  //#endregion

  //#region INSERT
  Future<int> addUser(AppUser user) async {
    final db = await database;
    if (db == null) return -1;
    try {
      int id = await db.insert(
        'users',
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

  //#region DELETE
  Future<int> deleteUser(AppUser user) async {
    final db = await database;
    if (db == null) return -1;
    try {
      return await db.delete(
        'users',
        where: "username=?",
        whereArgs: [user.username],
      );
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region UPDATE
  Future<int> updateUser(AppUser user) async {
    final db = await database;
    if (db == null) return -1;
    try {
      int updateCount = await db.update(
        'users',
        user.toMap(),
        where: "username=?",
        whereArgs: [user.username],
      );
      return updateCount;
    } on Exception catch (err) {
      log(err.toString());
      return -1;
    }
  }
  //#endregion

  //#region SELECT ALL
  Future<List<AppUser>> getUsers() async {
    final users = <AppUser>[];
    final db = await database;
    if (db == null) return users;
    try {
      final result = await db.query('users');
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

  //#region SELECT ADMINS
  Future<List<AppUser>> getAdminUsers() async {
    final users = <AppUser>[];
    final db = await database;
    if (db == null) return users;
    try {
      final result = await db.query(
        'users',
        where: "isAdmin=?",
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

  //#region SELECT ONE
  Future<AppUser?> getUser({
    required String username,
    required String pin,
  }) async {
    final db = await database;
    if (db == null) return null;
    try {
      final result = await db.query(
        'users',
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
}
