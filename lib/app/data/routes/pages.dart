import 'package:central_heating_control/app/data/middlewares/account.dart';
import 'package:central_heating_control/app/data/middlewares/admin.dart';
import 'package:central_heating_control/app/data/middlewares/chc_device.dart';
import 'package:central_heating_control/app/data/middlewares/setup.dart';
import 'package:central_heating_control/app/data/middlewares/user.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/core/utils/osk/keyboard_screen.dart';
import 'package:central_heating_control/app/presentation/screens/activation/activation_screen.dart';
import 'package:central_heating_control/app/presentation/screens/activation/register_device_screen.dart';
import 'package:central_heating_control/app/presentation/screens/auth/signin/signin_screen.dart';
import 'package:central_heating_control/app/presentation/screens/home/home_screen.dart';
import 'package:central_heating_control/app/presentation/screens/pin/pin_screen.dart';
import 'package:central_heating_control/app/presentation/screens/screen_saver/screen_saver.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/add_user_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/developer_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/edit_user_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/language_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/preferences.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/timezone_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/users_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/sensor_settings/settings_sensor_add_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/sensor_settings/edit_settings_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/sensor_settings/settings_sensor_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/zone_device_settings_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/zone_settings/add_zone_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/zone_settings/settings_zone_edit_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/device_zone_settings/zone_settings/settings_zone_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/settings_screen.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_admin_user_screen.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_language_screen.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_timezone_screen.dart';
import 'package:central_heating_control/app/presentation/screens/splash/splash_screen.dart';
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
    name: Routes.home,
    page: () => const HomeScreen(),
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
    name: Routes.setupAdminUser,
    page: () => const SetupAdminUserScreen(),
  ),
  GetPage(
    name: Routes.splash,
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: Routes.setupLanguage,
    page: () => const SetupLanguageScreen(),
  ),
  GetPage(
    name: Routes.setupTimezone,
    page: () => const SetupTimezoneScreen(),
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
    name: Routes.settingsWifiCredentials,
    page: () => SettingsPreferences(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsSensorsList,
    page: () => SettingsSensorListScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsSensorAdd,
    page: () => SettingsSensorAddScreen(),
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
    page: () => SettingsZoneListScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsZoneAdd,
    page: () => SettingsZoneAddScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsZoneEdit,
    page: () => SettingsZoneEditScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),
  //#endregion

  GetPage(
    name: Routes.screenSaver,
    page: () => const ScreenSaverScreen(),
    transitionDuration: const Duration(milliseconds: 1000),
    transition: Transition.zoom,
  ),

  GetPage(
    name: Routes.onScreenKeyboard,
    page: () => OnScreenKeyboard(),
  ),
];
