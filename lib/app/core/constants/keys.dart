class Keys {
  static const String appSettings = 'appSettings';
  static const String lastTouchTime = 'lastTouchTime';
  static const String localeLang = 'localeLang';
  static const String localeCulture = 'localeCulture';
  static const String isDarkMode = 'isDarkMode';
  static const String selectedTheme = 'selectedTheme';
  static const String themeMode = 'themeMode';

  static const String selectedTimezone = 'selectedTimezone';
  static const String selectedTimeFormat = 'selectedTimeFormat';
  static const String selectedDateFormat = 'selectedDateFormat';
  static const String didLanguageSelected = 'didLanguageSelected';
  static const String didTimezoneSelected = 'didTimezoneSelected';
  static const String didDateFormatSelected = 'didDateFormatSelected';
  static const String didThemeSelected = 'didPickedTheme';
  static const String didTermsAccepted = 'didTermsAccepted';
  static const String didPrivacyAccepted = 'didPrivacyAccepted';
  static const String didActivated = 'didActivated';
  static const String didRegisteredDevice = 'didRegisteredDevice';
  static const String didSignedIn = 'didSignedIn';
  static const String didSubscriptionResultReceived =
      'didSubscriptionResultReceived';
  static const String subscriptionResult = 'subscriptionResult';
  static const String didTechSupportUserCreated = 'didTechSupportUserCreated';
  static const String didAdminUserCreated = 'didAdminUserCreated';

  static const String sessionKey = 'sessionKey';
  static const String deviceId = 'deviceId';
  static const String accountId = 'accountId';
  static const String account = 'account';
  static const String activationId = 'activationId';
  static const String activationResult = 'activationResult';

  static const String wifiCredentials = 'wifiCredentials';
  static const String wifiSsid = 'wifiSsid';
  static const String wifiPass = 'wifiPass';
  static const String userList = 'userList';
  static const String forgottenPin = 'forgottenPin';

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
  static const int databaseVersion = 14;
  static const String databasePath = 'databases';
  static const String databaseName = 'chcDb.db';
  static const String tableUsers = 'users';
  static const String tableSensors = 'sensors';
  static const String tableHeaters = 'heaters';
  static const String tableZones = 'zones';
  static const String tableZoneUsers = 'zoneUsers';
  static const String tableZoneHeaters = 'zoneHeaters';
  static const String tableZoneSensors = 'zoneSensors';
  static const String tableHardwareParameters = 'hardwareParameters';
  static const String tablePlans = 'plans';
  static const String tablePlanDetails = 'planDetails';

  static const String queryId = 'id=?';
  static const String queryUsername = 'username=?';
  static const String queryIsAdmin = 'isAdmin=?';
  static const String queryZoneId = 'zoneId=?';
  static const String queryPlanId = 'planId=?';
  static const String queryIdIn = 'id IN (?)';
  static const String queryDayAndHour = 'day=? AND hour=?';

  static const String dbDropUsers = '''
    DROP TABLE IF EXISTS users
  ''';
  static const String dbCreateUsers = '''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      pin TEXT,
      level INTEGER NOT NULL DEFAULT 0
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
      levelType INTEGER NOT NULL DEFAULT 1,
      level1Relay TEXT,
      level1ConsumptionAmount DOUBLE,
      level1ConsumptionUnit TEXT,
      level1Carbon DOUBLE,
      level2Relay TEXT,
      level2ConsumptionAmount DOUBLE,
      level2ConsumptionUnit TEXT,
      level2Carbon DOUBLE,
      level3Relay TEXT,
      level3ConsumptionAmount DOUBLE,
      level3ConsumptionUnit TEXT,
      level3Carbon DOUBLE,
      errorChannel INTEGER,
      errorChannelType INTEGER,
      state INTEGER NOT NULL DEFAULT 0,
      zoneId INTEGER NOT NULL DEFAULT 0
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
      state INTEGER NOT NULL DEFAULT 0,
      setValue INTEGER,
      selectedPlan INTEGER
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

  static const String dbDropHardwareParameters = '''
    DROP TABLE IF EXISTS hardwareParameters
  ''';

  static const String dbCreateHardwareParameters = '''
    CREATE TABLE IF NOT EXISTS hardwareParameters (
      id INTEGER NOT NULL DEFAULT 0,
      name TEXT,
      inputCount INTEGER NOT NULL DEFAULT 0,
      outputCount INTEGER NOT NULL DEFAULT 0,
      analogCount INTEGER NOT NULL DEFAULT 0,
      version TEXT,
      type TEXT,
      isExtension INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String dbDropPlans = '''
    DROP TABLE IF EXISTS plans
  ''';
  static const String dbCreatePlans = '''
    CREATE TABLE IF NOT EXISTS plans (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      isDefault INTEGER NOT NULL DEFAULT 0,
      isActive INTEGER NOT NULL DEFAULT 0
    )
  ''';

  static const String dbDropPlanDetails = '''
    DROP TABLE IF EXISTS planDetails
  ''';
  static const String dbCreatePlanDetails = '''
    CREATE TABLE IF NOT EXISTS planDetails (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      planId INTEGER NOT NULL,
      hour INTEGER NOT NULL,
      day INTEGER NOT NULL,
      level INTEGER NOT NULL DEFAULT 0,
      degree INTEGER NOT NULL DEFAULT 20,
      hasThermostat INTEGER NOT NULL DEFAULT 0
    )
  ''';
  static const String dbInsertDefaultPlan = '''
    INSERT INTO plans (name, isDefault, isActive) VALUES ('Default', 1, 1)
  ''';
  static const String dbInsertDefaultPlanDetails = '''
    INSERT INTO planDetails (planId, hour, day, level) VALUES (1, {H}, {D}, 1)
  ''';

  //#endregion
}
