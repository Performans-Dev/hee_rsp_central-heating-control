import 'dart:developer';

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

class LogManager {
  static LogManager? _instance;
  Database? _database;
  String _dbPath;

  LogManager._internal(this._dbPath);

  factory LogManager({String? year, String? month, String? day}) {
    final DateTime selectedDate = year != null && month != null && day != null
        ? DateTime(int.parse(year), int.parse(month), int.parse(day))
        : DateTime.now();

    final String newDbPath = _buildDbPath(selectedDate);

    if (_instance == null || _instance!._dbPath != newDbPath) {
      _instance = LogManager._internal(newDbPath);
    }
    return _instance!;
  }

  static String _buildDbPath(DateTime date) {
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');

    final String logDirectory =
        p.join('home/pi/Heethins/CC/databases', 'logs', year, month, day);
    return p.join(logDirectory, 'logs.db');
  }

  
}


// class LogProvider {
//   LogProvider._();
//   static final LogProvider lp = LogProvider._();
//   Database? _database;

//   Future<Database?> get database async {
//     if (_database != null) return _database;
//     _database = await initDb();
//     return _database;
//   }

//   Future<Database?> initDb() async {
//     var dbFactory = databaseFactoryFfi;
//     final dbPath = await getDbPath();
//     if (dbPath == null) return null;
//     log(dbPath);
//     return await dbFactory.openDatabase(
//       dbPath,
//       options: OpenDatabaseOptions(
//         onCreate: (db, version) async {
//           await createDatabaseStructure(db);
//         },
//         onUpgrade: (db, oldVersion, newVersion) async {
//           if (oldVersion < newVersion) {
//             await createDatabaseStructure(db);
//           }
//         },
//         singleInstance: true,
//         version: Keys.logDatabaseVersion,
//       ),
//     );
//   }

//   Future<String?> getDbPath() async {
//     try {
//       String dbPath = p.join(
//         'home/pi/Heethins/CC/databases',
//         'log_${CommonUtils.getCurrentDateFormatted()}.db',
//       );
//       return dbPath;
//     } on Exception catch (e) {
//       log(e.toString());
//       return null;
//     }
//   }

//   Future<void> createDatabaseStructure(Database db) async {
//     await db.execute(Keys.logDbDropLogTable);
//     await db.execute(Keys.logDbCreateLogTable);
//   }
// }
