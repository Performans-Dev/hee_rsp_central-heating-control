class Routes {
  static const String developer = '/dev';

  static const String home = '/home';
  static const String zone = '/zone';
  static const String splash = '/initializing';
  static const String splashFetchSettings = '/fetch-settings';

  static const String pin = '/pin';
  static const String screenSaver = '/screen-saver';

  //#region INITIAL SETUP
  static const String setupTheme = '/setup-theme';
  static const String setupLanguage = '/setup-language';
  static const String setupTimezone = '/setup-timezone';
  static const String setupDateFormat = '/setup-date-format';
  static const String setupConnection = '/setup-connection';
  static const String setupAdminUser = '/setup-admin-user';
  //#endregion

  //#region ACTIVATION
  static const String activation = '/activation';
  static const String signin = '/signin';
  static const String registerDevice = '/register-device';
  //#endregion

  static const String settings = '/settings';
  static const String settingsUserList = '/settings-user-list';
  static const String settingsUserAdd = '/settings-add-user';
  static const String settingsUserEdit = '/settings-edit-user';
  static const String settingsPreferences = '/settings-preferences';
  static const String settingsLanguage = '/settings-language';

  static const String settingsTimezone = '/settings-timezone';
  static const String settingsWifiCredentials = '/settings-wifi-credentials';
  static const String settingstZoneDeviceSensorManagement =
      '/settings-zone-device-sensor';

  static const String settingsZoneList = '/settings-zone-list';
  static const String settingsZoneAdd = '/settings-add-zone';
  static const String settingsZoneEdit = '/settings-edit-zone';

  static const String settingsHeaterList = '/settings-heater-list';
  static const String settingsHeaterAdd = '/settings-add-heater';
  static const String settingsHeaterEdit = '/settings-edit-heater';

  static const String settingsSensorsList = '/settings-sensor-list';
  static const String settingsSensorAdd = '/settings-add-sensor';
  static const String settingsSensorEdit = '/settings-edit-sensor';

  static const String settingsPlanList = '/settings-plan-list';
  static const String settingsPlanDetail = '/settings-plan-detail';
  static const String settingsAdvanced = '/settings-advanced';

  static const String onScreenKeyboard = '/oskb';

  static const String daySummaryScreen = '/day-summary-screen';
}
