class Routes {
  static const String developer = '/dev';

  static const String home = '/home';
  static const String splash = '/initializing';

  static const String pin = '/pin';

  //#region INITIAL SETUP
  static const String setupLanguage = '/setup-language';
  static const String setupTimezone = '/setup-timezone';
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
}
