class Keys {
  static const String localeLang = 'localeLang';
  static const String localeCulture = 'localeCulture';
  static const String isDarkMode = 'isDarkMode';

  static const String selectedTimezone = 'selectedTimezone';
  static const String didLanguageSelected = 'didLanguageSelected';
  static const String didTimezoneSelected = 'didTimezoneSelected';
  static const String didActivated = 'didActivated';

  static const String sessionKey = 'sessionKey';
  static const String deviceId = 'deviceId';
  static const String accountId = 'accountId';
  static const String activationId = 'activationId';

  static const String wifiCredentials = 'wifiCredentials';
  static const String userList = 'userList';

  static const String message = 'message';
  static const String type = 'type';
  static const String metadata = 'metadata';
  static const String name = 'name';
  static const String code = 'code';
  static const String success = 'success';
  static const String statusCode = 'statusCode';
  static const String error = 'error';
  static const String data = 'data';
  static const String http = 'http';

  //#region DATABASE
  static const int databaseVersion = 6;
  static const String databasePath = 'databases';
  static const String databaseName = 'chcDb.db';
  static const String tableUsers = 'users';
  static const String tableSensors = 'sensors';
  static const String tableHeaters = 'heaters';
  static const String tableZones = 'zones';
  static const String tableZoneUsers = 'zoneUsers';
  static const String tableZoneHeaters = 'zoneHeaters';
  static const String tableZoneSensors = 'zoneSensors';

  static const String queryId = 'id=?';
  static const String queryUsername = 'username=?';
  static const String queryIsAdmin = 'isAdmin=?';
  static const String queryZoneId = 'zoneId=?';
  static const String queryIdIn = 'id IN (?)';

  static const String dbDropUsers = '''
    DROP TABLE IF EXISTS users
  ''';
  static const String dbCreateUsers = '''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      pin TEXT,
      isAdmin INTEGER NOT NULL DEFAULT 0
    )
  ''';
  static const String dbDropSensors = '''
    DROP TABLE IF EXISTS sensors
  ''';
  static const String dbCreateSensors = '''
    CREATE TABLE IF NOT EXISTS sensors (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      minValue DOUBLE,
      maxValue DOUBLE,
      comportId INTEGER,
      zoneId INTEGER
    )
  ''';
  static const String dbDropHeaters = '''
    DROP TABLE IF EXISTS heaters
  ''';
  static const String dbCreateHeaters = '''
    CREATE TABLE IF NOT EXISTS heaters (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      color TEXT,
      icon TEXT,
      type INTEGER NOT NULL DEFAULT 0,
      connectionType INTEGER NOT NULL DEFAULT 0,
      ipAddress TEXT,
      level1Relay TEXT,
      level1ConsumptionAmount DOUBLE,
      level1ConsumptionUnit TEXT,
      level2Relay TEXT,
      level2ConsumptionAmount DOUBLE,
      level2ConsumptionUnit TEXT,
      errorChannel INTEGER,
      errorChannelType INTEGER,
      state INTEGER NOT NULL DEFAULT 0,
      zoneId INTEGER
    )
  ''';
  static const String dbDropZones = '''
    DROP TABLE IF EXISTS zones
  ''';
  static const String dbCreateZones = '''
    CREATE TABLE IF NOT EXISTS zones (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      color TEXT,
      state INTEGER NOT NULL DEFAULT 0
    )
  ''';
  static const String dbDropZoneUsers = '''
    DROP TABLE IF EXISTS zoneUsers
  ''';
  static const String dbCreateZoneUsers = '''
    CREATE TABLE IF NOT EXISTS zoneUsers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      zoneId INTEGER NOT NULL,
      userId INTEGER NOT NULL
    )
  ''';
  static const String dbDropZoneSensors = '''
    DROP TABLE IF EXISTS zoneSensors
  ''';
  static const String dbCreateZoneSensors = '''
    CREATE TABLE IF NOT EXISTS zoneSensors (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      zoneId INTEGER NOT NULL,
      sensorId INTEGER NOT NULL
    )
  ''';
  static const String dbDropZoneHeaters = '''
    DROP TABLE IF EXISTS zoneHeaters
  ''';
  static const String dbCreateZoneHeaters = '''
    CREATE TABLE IF NOT EXISTS zoneHeaters (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      zoneId INTEGER NOT NULL,
      heaterId INTEGER NOT NULL
    )
  ''';

  //#endregion
}
