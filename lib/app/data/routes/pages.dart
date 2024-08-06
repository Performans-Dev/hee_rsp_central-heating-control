import 'package:central_heating_control/app/data/middlewares/account.dart';
import 'package:central_heating_control/app/data/middlewares/admin.dart';
import 'package:central_heating_control/app/data/middlewares/chc_device.dart';
import 'package:central_heating_control/app/data/middlewares/heetings_login.dart';
import 'package:central_heating_control/app/data/middlewares/pin.dart';
import 'package:central_heating_control/app/data/middlewares/setup.dart';
import 'package:central_heating_control/app/data/middlewares/user.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/screens/activation/register_device_screen.dart';
import 'package:central_heating_control/app/presentation/screens/auth/signin/signin_screen.dart';
import 'package:central_heating_control/app/presentation/screens/home/home_screen.dart';
import 'package:central_heating_control/app/presentation/screens/pin/pin_recovery_login.dart';
import 'package:central_heating_control/app/presentation/screens/pin/pin_recovery.dart';
import 'package:central_heating_control/app/presentation/screens/pin/pin_screen.dart';
import 'package:central_heating_control/app/presentation/screens/screen_saver/screen_saver.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/add_user_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/advanced/advanced.dart';
import 'package:central_heating_control/app/presentation/screens/pin/check_connection.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/developer_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/edit_user_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/language_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/preferences.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/theme_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/timezone_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/users_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/wifi_credentials.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/heater_settings/settings_heater_add_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/heater_settings/settings_heater_edit_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/heater_settings/settings_heater_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/sensor_settings/edit_settings_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/sensor_settings/settings_sensor_add_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/sensor_settings/settings_sensor_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/zone_device_settings_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/zone_settings/settings_zone_add_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/zone_settings/settings_zone_edit_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/zone_settings/settings_zone_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/settings_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/weekly_plan_settings/day_summary.dart';
import 'package:central_heating_control/app/presentation/screens/settings/weekly_plan_settings/plan_detail.dart';
import 'package:central_heating_control/app/presentation/screens/settings/weekly_plan_settings/plan_list.dart';
import 'package:central_heating_control/app/presentation/screens/setup/activation/activation.dart';
import 'package:central_heating_control/app/presentation/screens/setup/connection/connection_setup_screen.dart';
import 'package:central_heating_control/app/presentation/screens/setup/date_format/date_format_setup_screen.dart';
import 'package:central_heating_control/app/presentation/screens/setup/language/language_setup_screen.dart';
import 'package:central_heating_control/app/presentation/screens/setup/admin_user/setup_admin_user_screen.dart';
import 'package:central_heating_control/app/presentation/screens/setup/subscription/check_subscription.dart';
import 'package:central_heating_control/app/presentation/screens/setup/theme/theme_setup_screen.dart';
import 'package:central_heating_control/app/presentation/screens/setup/timezone/timezone_setup_screen.dart';
import 'package:central_heating_control/app/presentation/screens/shell_test.dart';
import 'package:central_heating_control/app/presentation/screens/splash/splash_connection.dart';
import 'package:central_heating_control/app/presentation/screens/splash/splash_screen.dart';
import 'package:central_heating_control/app/presentation/screens/splash/splash_settings.dart';
import 'package:central_heating_control/app/presentation/screens/zone/zone_screen.dart';
import 'package:get/get.dart';

final List<GetPage> getPages = [
  GetPage(
    name: Routes.developer,
    page: () => const DeveloperScreen(),
  ),
  GetPage(
    name: Routes.pin,
    page: () => const PinScreen(),
    middlewares: [
      SetupMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.pinRecovery,
    page: () => const PinRecoveryScreen(),
    middlewares: [
      ResetPinAccountMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.heetingsLogin,
    page: () => const PinRecoveryLogin(),
    middlewares: [
      HeetingsLoginMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.home,
    page: () => const HomeScreen(),
    middlewares: [
      SetupMiddleware(),
      UserMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.zone,
    page: () => const ZoneScreen(),
    middlewares: [
      SetupMiddleware(),
      UserMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.activation,
    page: () => const ActivationScreen(),
    middlewares: [
      AccountMiddleware(),
      ChcDeviceMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.signin,
    page: () => const SigninScreen(),
  ),
  GetPage(
    name: Routes.registerDevice,
    page: () => const RegisterDeviceScreen(),
  ),
  GetPage(
    name: Routes.checkSubscription,
    page: () => const CheckSubscriptionScreen(),
  ),
  GetPage(
    name: Routes.checkConnection,
    page: () => const CheckConnectionScreen(),
  ),
  GetPage(
    name: Routes.setupAdminUser,
    page: () => const SetupAdminUserScreen(),
  ),
  GetPage(
    name: Routes.splash,
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: Routes.splashFetchSettings,
    page: () => const SplashFetchSettingsScreen(),
  ),
  GetPage(
    name: Routes.splashConnection,
    page: () => const SplashConnectionScreen(),
  ),
  GetPage(
    name: Routes.setupTheme,
    page: () => const SetupThemeScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: Routes.setupLanguage,
    page: () => const SetupLanguageScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: Routes.setupTimezone,
    page: () => const SetupTimezoneScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: Routes.setupDateFormat,
    page: () => const SetupDateFormatScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: Routes.setupConnection,
    page: () => const SetupConnectionScreen(),
    transition: Transition.fadeIn,
  ),

  //#region SETTINGS
  GetPage(
    name: Routes.settings,
    page: () => const SettingsScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingstZoneDeviceSensorManagement,
    page: () => const SettingsZoneDeviceSensorManagementScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsUserList,
    page: () => const SettingsUserListScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsUserAdd,
    page: () => const SettingsAddUserScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsUserEdit,
    page: () => const SettingsEditUserScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferences,
    page: () => SettingsPreferences(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsLanguage,
    page: () => const LanguageScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),

  GetPage(
    name: Routes.settingsTimezone,
    page: () => const TimezoneScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsTheme,
    page: () => const ThemeScreen(),
  ),
  GetPage(
    name: Routes.settingsWifiCredentials,
    page: () => const WifiCredentialsScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsSensorsList,
    page: () => const SettingsSensorListScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsSensorAdd,
    page: () => const SettingsSensorAddScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsSensorEdit,
    page: () => SettingsEditSensorScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsZoneList,
    page: () => const SettingsZoneListScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsZoneAdd,
    page: () => const SettingsZoneAddScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsZoneEdit,
    page: () => const SettingsZoneEditScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsHeaterList,
    page: () => const SettingsHeaterListScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsHeaterAdd,
    page: () => const SettingsHeaterAddScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsHeaterEdit,
    page: () => const SettingsHeaterEditScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPlanList,
    page: () => const SettingsPlanListScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPlanDetail,
    page: () => const SettingsPlanDetailScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsAdvanced,
    page: () => const SettingsAdvancedScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  //#endregion

  GetPage(
    name: Routes.screenSaver,
    page: () => const ScreenSaverScreen(),
    transition: Transition.fadeIn,
  ),

  GetPage(
    name: Routes.daySummaryScreen,
    page: () => const DaySummaryScreen(),
  ),

  GetPage(
    name: Routes.shellTest,
    page: () => const ShellTestScreen(),
  ),
];
