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
  static const int databaseVersion = 3;
  static const String databasePath = 'databases';
  static const String databaseName = 'chcDb.db';
  static const String tableUsers = 'users';
  static const String tableSensors = 'sensors';

  static const String queryId = 'id=?';
  static const String queryUsername = 'username=?';
  static const String queryIsAdmin = 'isAdmin=?';

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
  //#endregion
}
