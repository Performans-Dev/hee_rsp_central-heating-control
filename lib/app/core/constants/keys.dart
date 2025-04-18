import 'package:central_heating_control/app/core/utils/color_utils.dart';

class Keys {
  static const String piPath = '/home/pi/Heethings/CC/';
  static const String databasePath = 'databases';
  static const String logPath = 'logs';

  static const String documentsDirectoryPath = 'documentsDirectoryPath';

  static const String preferences = 'preferences';
  static const String selectedTheme = 'selectedTheme';
  static const String isDarkMode = 'isDarkMode';
  static const String selectedLanguage = 'selectedLanguage';
  static const String selectedTimezone = 'selectedTimezone';
  static const String selectedDateFormat = 'selectedDateFormat';
  static const String selectedTimeFormat = 'selectedTimeFormat';

  static const String cpuSerialNumberFilePath =
      '/sys/firmware/devicetree/base/serial-numberl';

  static const String deviceId = 'deviceId';

  static const String themeDefault = 'default';
  static const String themeNature = 'nature';
  static const String themeWarmy = 'warmy';
  static const String themeCrimson = 'crimson';

  static const String idleTimerInSeconds = 'idleTimerInSeconds';
  static const String slideShowDurationInSeconds = 'slideShowDurationInSeconds';
  static const String screenSaverType = 'screenSaverType';

  //#region MARK: Database
  static const int databaseVersion = 46;
  static const int logDatabaseVersion = 19;
  static const String databaseName = 'heethings_cc.db';
  static const String logDatabaseName = 'logs.db';
  //#endregion

  //#region MARK: Input Outputs
  static const String tableAnalogInputs = 'analogInputs';
  static const String dropTableAnalogInputs =
      'DROP TABLE IF EXISTS $tableAnalogInputs';
  static const String createTableAnalogInputs = '''
    CREATE TABLE IF NOT EXISTS $tableAnalogInputs(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      hwId INTEGER NOT NULL,
      pinIndex INTEGER NOT NULL,
      type INTEGER NOT NULL,
      name TEXT NOT NULL
    );
  ''';

  static const String populateTableAnalogInputs = '''
    INSERT INTO $tableAnalogInputs (hwId, pinIndex, type, name)
    VALUES
    (0x00, 1, 1, 'Sensor 1'),
    (0x00, 2, 1, 'Sensor 2'),
    (0x00, 3, 1, 'Sensor 3'),
    (0x00, 4, 1, 'Sensor 4');
  ''';

  static const String tableDigitalInputs = 'digitalInputs';
  static const String dropTableDigitalInputs =
      'DROP TABLE IF EXISTS $tableDigitalInputs';
  static const String createTableDigitalInputs = '''
    CREATE TABLE IF NOT EXISTS $tableDigitalInputs(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      hwId INTEGER NOT NULL,
      pinIndex INTEGER NOT NULL,
      name TEXT NOT NULL
    );
  ''';

  static const String populateTableDigitalInputs = '''
    INSERT INTO $tableDigitalInputs (hwId, pinIndex, name)
    VALUES
    (0x00, 1, 'Input 1'),
    (0x00, 2, 'Input 2'),
    (0x00, 3, 'Input 3'),
    (0x00, 4, 'Input 4'),
    (0x00, 5, 'Input 5'),
    (0x00, 6, 'Input 6'),
    (0x00, 7, 'Input 7'),
    (0x00, 8, 'Input 8');
  ''';

  static const String tableDigitalOutputs = 'digitalOutputs';
  static const String dropTableDigitalOutputs =
      'DROP TABLE IF EXISTS $tableDigitalOutputs';
  static const String createTableDigitalOutputs = '''
    CREATE TABLE IF NOT EXISTS $tableDigitalOutputs(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      hwId INTEGER NOT NULL,
      pinIndex INTEGER NOT NULL,
      name TEXT NOT NULL
    );
  ''';

  static const String populateTableDigitalOutputs = '''
    INSERT INTO $tableDigitalOutputs (hwId, pinIndex, name)
    VALUES
    (0x00, 1, 'Output 1'),
    (0x00, 2, 'Output 2'),
    (0x00, 3, 'Output 3'),
    (0x00, 4, 'Output 4'),
    (0x00, 5, 'Output 5'),
    (0x00, 6, 'Output 6'),
    (0x00, 7, 'Output 7'),
    (0x00, 8, 'Output 8');
  ''';
  //#endregion

  //#region MARK: AppUsers
  static const String tableAppUsers = 'appUsers';
  static const String dropTableAppUsers = 'DROP TABLE IF EXISTS $tableAppUsers';
  static const String createTableAppUsers = '''
    CREATE TABLE IF NOT EXISTS $tableAppUsers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      pinCode TEXT NOT NULL,
      level INTEGER NOT NULL DEFAULT 0
    );
  ''';
  static const String populateTableAppUsers = '''
    INSERT INTO $tableAppUsers (name, pinCode, level)
    VALUES
    ('Developer', '969696', 100),
    ('Admin', '000000', 50),
    ('User', '123456', 0);
  ''';
  //#endregion

  //#region MARK: Zone
  static const String tableZones = 'zones';
  static const String dropTableZones = 'DROP TABLE IF EXISTS $tableZones';
  static const String createTableZones = '''
    CREATE TABLE IF NOT EXISTS $tableZones(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      color TEXT NOT NULL
    );
  ''';
  static final String populateTableZones = '''
    INSERT INTO $tableZones (name, color)
    VALUES
    ('Zone 1', '${ItemColor.purple.value}'),
    ('Zone 2', '${ItemColor.orange.value}');
  ''';
  //#endregion

  //#region MARK: Devices
  static const String tableDevices = 'devices';
  static const String dropTableDevices = 'DROP TABLE IF EXISTS $tableDevices';
  static const String createTableDevices = '''
    CREATE TABLE IF NOT EXISTS $tableDevices(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      groupId INTEGER,
      name TEXT NOT NULL,
      icon TEXT,
      type INTEGER NOT NULL DEFAULT 0,
      levelCount INTEGER NOT NULL DEFAULT 0,
      outputCount INTEGER NOT NULL DEFAULT 0,
      inputCount INTEGER NOT NULL DEFAULT 0,
      createdOn INTEGER NOT NULL DEFAULT 0,
      modifiedOn INTEGER NOT NULL DEFAULT 0
    );
  ''';

  static const String tableDeviceInputs = 'deviceInputs';
  static const String dropTableDeviceInputs =
      'DROP TABLE IF EXISTS $tableDeviceInputs';
  static const String createTableDeviceInputs = '''
    CREATE TABLE IF NOT EXISTS $tableDeviceInputs(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      deviceId INTEGER NOT NULL,
      inputId INTEGER NOT NULL,
      priority INTEGER NOT NULL DEFAULT 0,
      description TEXT,
      FOREIGN KEY (deviceId) REFERENCES $tableDevices(id) ON DELETE CASCADE
    );
  ''';

  static const String tableDeviceOutputs = 'deviceOutputs';
  static const String dropTableDeviceOutputs =
      'DROP TABLE IF EXISTS $tableDeviceOutputs';
  static const String createTableDeviceOutputs = '''
    CREATE TABLE IF NOT EXISTS $tableDeviceOutputs(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      deviceId INTEGER NOT NULL,
      outputId INTEGER NOT NULL,
      priority INTEGER NOT NULL DEFAULT 0,
      description TEXT,
      FOREIGN KEY (deviceId) REFERENCES $tableDevices(id) ON DELETE CASCADE
    );
  ''';

  static const String tableDeviceStates = 'deviceStates';
  static const String dropTableDeviceStates =
      'DROP TABLE IF EXISTS $tableDeviceStates';
  static const String createTableDeviceStates = '''
    CREATE TABLE IF NOT EXISTS $tableDeviceStates(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      deviceId INTEGER NOT NULL,
      level INTEGER NOT NULL,
      doId INTEGER,
      diId INTEGER,
      value INTEGER NOT NULL DEFAULT 0,
      isFeedback INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (deviceId) REFERENCES $tableDevices(id) ON DELETE CASCADE
    );
  ''';

  static const String tableDeviceLevels = 'deviceLevels';

  static const String dropTableDeviceLevels =
      'DROP TABLE IF EXISTS $tableDeviceLevels';

  static const String createTableDeviceLevels = '''
  CREATE TABLE IF NOT EXISTS $tableDeviceLevels(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    deviceId INTEGER NOT NULL,
    level INTEGER NOT NULL,
    name TEXT NOT NULL,
    FOREIGN KEY (deviceId) REFERENCES $tableDevices(id) ON DELETE CASCADE
  );
''';

  //#endregion
}
