class Keys {
  static const String piPath = '/home/pi/Heethings/CC/';
  static const String databasePath = 'databases';
  static const String logPath = 'logs';

  ///
  static const String preferences = 'preferences';
  static const String appSettings = 'appSettings';
  static const String idleTimerInSeconds = 'idleTimerInSeconds';
  static const String slideShowTimer = 'slideShowTimer';
  static const String screenSaverType = 'screenSaverType';
  static const String lastTouchTime = 'lastTouchTime';
  static const String localeLang = 'localeLang';
  static const String localeCulture = 'localeCulture';
  static const String isDarkMode = 'isDarkMode';
  static const String selectedTheme = 'selectedTheme';
  static const String themeMode = 'themeMode';
  static const String documentsDirectoryPath = 'documentsDirectoryPath';

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
  static const String didConnected = 'didConnected';
  static const String sessionKey = 'sessionKey';
  static const String deviceId = 'deviceId';
  static const String accountId = 'accountId';
  static const String account = 'account';
  static const String activationId = 'activationId';
  static const String activationResult = 'activationResult';
  static const String serialNumber = 'activationResult';

  static const String wifiCredentials = 'wifiCredentials';
  static const String wifiSsid = 'wifiSsid';
  static const String wifiPass = 'wifiPass';
  static const String ethIpAddress = 'ethIpAddress';
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

  //#region MARK: DATABASE
  static const int databaseVersion = 32;
  static const int logDatabaseVersion = 18;
  static const String databaseName = 'heethings_cc.db';
  static const String logDatabaseName = 'logs.db';
  static const String tableUsers = 'users';
  static const String tableSensors = 'sensors';
  static const String tableHeaters = 'heaters';
  static const String tableZones = 'zones';
  static const String tableZoneUsers = 'zoneUsers';
  static const String tableZoneHeaters = 'zoneHeaters';
  static const String tableZoneSensors = 'zoneSensors';
  static const String tablePlans = 'plans';
  static const String tablePlanDetails = 'planDetails';
  static const String tableHardwares = 'hardwares';
  static const String tableTemperatureValues = 'temperatureValues';
  static const String tableFunctions = 'tblFunctions';
  static const String tableButtonFunctions = 'buttonFunctions';

  static const String queryId = 'id=?';
  static const String queryName = 'name=?';
  static const String queryUsername = 'username=?';
  static const String queryIsAdmin = 'isAdmin=?';
  static const String queryZoneId = 'zoneId=?';
  static const String queryPlanId = 'planId=?';
  static const String queryIdIn = 'id IN (?)';
  static const String queryDayAndHourAndPlanId =
      'day=? AND hour=? AND planId=?';

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
      device INTEGER,
      sensorIndex INTEGER,
      zoneId INTEGER,
      color TEXT,
      name TEXT
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
      connectionType INTEGER NOT NULL DEFAULT 0,
      type INTEGER NOT NULL DEFAULT 0,
      levelType INTEGER NOT NULL DEFAULT 1,
      ipAddress TEXT,
      outputChannel1  INTEGER NOT NULL DEFAULT 0,
      outputChannel2  INTEGER NOT NULL DEFAULT 0,
      outputChannel3  INTEGER NOT NULL DEFAULT 0,
      errorChannel INTEGER NOT NULL DEFAULT 0,
      errorChannelType INTEGER,
      level1ConsumptionAmount DOUBLE,
      level1Carbon DOUBLE,
      level2ConsumptionAmount DOUBLE,
      level2Carbon DOUBLE,
      level3ConsumptionAmount DOUBLE,
      level3Carbon DOUBLE,
      consumptionUnit TEXT,
      zoneId INTEGER NOT NULL DEFAULT 0,
      desiredMode INTEGER NOT NULL DEFAULT 0,
      currentMode INTEGER NOT NULL DEFAULT 0,
      desiredTemperature DOUBLE,
      currentTemperature DOUBLE,
      hasThermostat INTEGER NOT NULL DEFAULT 0
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
      selectedPlan INTEGER,
      desiredMode INTEGER NOT NULL DEFAULT 0,
      currentMode INTEGER NOT NULL DEFAULT 0,
      desiredTemperature DOUBLE,
      currentTemperature DOUBLE,
      hasThermostat INTEGER NOT NULL DEFAULT 0
    )
  ''';
  static const String dbInsertSampleZones = '''
    INSERT INTO zones (name, color, desiredMode, currentMode, selectedPlan) VALUES
      ('Zone 1', '#FF0000', 0, 0, 0),
      ('Zone 2', '#00FF00', 0, 0, 0)
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

  // static const String dbDropHardwareParameters = '''
  //   DROP TABLE IF EXISTS hardwareParameters
  // ''';

  // static const String dbCreateHardwareParameters = '''
  //   CREATE TABLE IF NOT EXISTS hardwareParameters (
  //     id INTEGER NOT NULL DEFAULT 0,
  //     name TEXT,
  //     inputCount INTEGER NOT NULL DEFAULT 0,
  //     outputCount INTEGER NOT NULL DEFAULT 0,
  //     analogCount INTEGER NOT NULL DEFAULT 0,
  //     version TEXT,
  //     type TEXT,
  //     isExtension INTEGER NOT NULL DEFAULT 1
  //   )
  // ''';

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

  //#region LogDb
  static const String logDbDropLogTable = '''
    DROP TABLE IF EXISTS logTable
  ''';

  static const String logDbCreateLogTable = '''
    CREATE TABLE IF NOT EXISTS logTable (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       level INTEGER NOT NULL DEFAULT 0,
       device TEXT,
       session TEXT,
       time TEXT,
       category TEXT,
       message TEXT,
       payload TEXT,
       syncStatus INTEGER NOT NULL DEFAULT 0      
    )
  ''';
  //#endregion

  //#region Hardware
  static const String dbDropHardwareTable = '''
    DROP TABLE IF EXISTS hardwares
  ''';

  static const String dbCreateHardwareTable = '''
    CREATE TABLE IF NOT EXISTS hardwares (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      deviceId INTEGER NOT NULL DEFAULT 0,
      modelName TEXT,
      diCount INTEGER NOT NULL DEFAULT 0,
      doCount INTEGER NOT NULL DEFAULT 0,
      adcCount INTEGER NOT NULL DEFAULT 0,
      dacCount INTEGER NOT NULL DEFAULT 0,
      hardwareVersion TEXT,
      firmwareVersion TEXT,
      serialNumber TEXT,
      manufacturer TEXT,
      description TEXT
    )
  ''';

  static const String dbInsertMainBoardHardwareExtension = '''
    INSERT INTO hardwares
    (deviceId, modelName, diCount, doCount, adcCount, dacCount, hardwareVersion, 
    firmwareVersion, serialNumber, manufacturer, description) VALUES 
    (0x00, 'Mainboard', 8, 8, 4, 0, '1.0.0', '1.0.0', 'N/A', 'Heethings', '')
  ''';

  static const String dbInsertSampleHardwareExtension = '''
    INSERT INTO hardwares
    (deviceId, modelName, diCount, doCount, adcCount, dacCount, hardwareVersion, 
    firmwareVersion, serialNumber, manufacturer, description) VALUES 
    (0x01, '2041.01', 6, 6, 1, 0, '1.0.0', '1.0.0', 'N/A', 'Heethings', '')
  ''';

  //#endregion

  //#region Temperature Value
  static const String dbDropTemperatureValues = '''
    DROP TABLE IF EXISTS temperatureValues
  ''';
  static const String dbCreateTemperatureValues = '''
    CREATE TABLE IF NOT EXISTS temperatureValues (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      temperature REAL NOT NULL DEFAULT 0,
      raw REAL NOT NULL DEFAULT 0

    )
  ''';
  //#endregions

  static const String dbInsertSensor = '''
    INSERT INTO sensors 
    (device, sensorIndex,zoneId,color,name) VALUES 
    (0, {INDEX},NULL,NULL,NULL)
  ''';

  static const String dbDropFunctionsTable = '''
    DROP TABLE IF EXISTS $tableFunctions
  ''';

  static const String dbCreateFunctionsTable = '''
    CREATE TABLE IF NOT EXISTS $tableFunctions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      zoneId INTEGER,
      heaterId INTEGER,
      controlMode INTEGER,
      fromHour INTEGER,
      toHour INTEGER
    )
  ''';

  static const String dbDropButtonFunctionsTable = '''
    DROP TABLE IF EXISTS $tableButtonFunctions
  ''';

  static const String dbCreateButtonFunctionsTable = '''
    CREATE TABLE IF NOT EXISTS $tableButtonFunctions (
      buttonIndex INTEGER,
      functionId INTEGER
    )
  ''';
  static const String dbInsertButtonFunctions = '''
    INSERT INTO $tableButtonFunctions (buttonIndex, functionId) VALUES
      (1, -2),
      (2, -1),
      (3, 0),
      (4, 0)
  ''';
}
