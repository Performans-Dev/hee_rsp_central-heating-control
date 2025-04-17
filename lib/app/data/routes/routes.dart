class Routes {
  static const String home = '/';
  static const String developer = '/developer';

  static const String settings = '/settings';
  // MARK: Management
  static const String management = '/settings/management';
  static const String managementZones = '/settings/management/zones';
  static const String managementAddZone = '/settings/management/add-zone';
  static const String managementEditZone = '/settings/management/edit-zone';
  static const String managementDevices = '/settings/management/devices';
  static const String managementAddDevice = '/settings/management/add-device';
  static const String managementViewDevice = '/settings/management/view-device';
  static const String managementEditDevice = '/settings/management/edit-device';
  static const String managementSensors = '/settings/management/sensors';
  static const String managementSchedules = '/settings/management/schedules';
  static const String managementScheduleDetail =
      '/settings/management/schedule-detail';
  // MARK: AppUser
  static const String appUsers = '/settings/app-users';
  static const String addNewAppUser = '/settings/app-users/add-new';
  // MARK: Preferences
  static const String preferences = '/settings/preferences';
  static const String preferencesLanguage = '/settings/preferences/language';
  static const String preferencesTimezone = '/settings/preferences/timezone';
  static const String preferencesDatetimeFormat =
      '/settings/preferences/datetime-format';
  static const String preferencesTheme = '/settings/preferences/theme';
  static const String preferencesScreenSaver =
      '/settings/preferences/screen-saver';
  static const String preferencesNetworkConnections =
      '/settings/preferences/network-connections';
  // MARK: Advanced
  static const String advanced = '/settings/advanced';
  static const String advancedCheckForUpdates =
      '/settings/advanced/check-for-updates';
  static const String advancedDiagnostics = '/settings/advanced/diagnostics';
  static const String advancedHardwares = '/settings/advanced/hardwares';
  static const String advancedFactoryReset = '/settings/advanced/factory-reset';
  static const String advancedOsUpdates = '/settings/advanced/os-updates';
  static const String advancedRepair = '/settings/advanced/repair';
  // MARK: Other
  static const String logs = '/logs';
  static const String account = '/account';
  static const String lock = '/lock';
  static const String schematics = '/schematics';
  // MARK: Rules
  static const String rules = '/rules';
  static const String addNewRule = '/rules/add';
  static const String ruleDetail = '/rules/detail';
  // MARK: Group
  static const String groupDetail = '/group';
  static const String groupControls = '/group-controls';
  static const String groupDevices = '/group-devices';
  static const String deviceControls = '/device-controls';
}
