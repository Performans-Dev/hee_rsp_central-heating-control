import 'package:central_heating_control/app/data/middlewares/account.dart';
import 'package:central_heating_control/app/data/middlewares/admin.dart';
import 'package:central_heating_control/app/data/middlewares/chc_device.dart';
import 'package:central_heating_control/app/data/middlewares/setup.dart';
import 'package:central_heating_control/app/data/middlewares/user.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/screens/activation/activation_screen.dart';
import 'package:central_heating_control/app/presentation/screens/activation/register_device_screen.dart';
import 'package:central_heating_control/app/presentation/screens/auth/signin/signin_screen.dart';
import 'package:central_heating_control/app/presentation/screens/home/home_screen.dart';
import 'package:central_heating_control/app/presentation/screens/pin/pin_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/add_user_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/developer_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/edit_user_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/language_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/preferences.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/timezone_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_settings/users_screen.dart';
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
    page: () => LanguageScreen(),
    middlewares: [
      AdminMiddleware(),
    ],
  ),

  GetPage(
    name: Routes.settingsTimezone,
    page: () => TimezoneScreen(),
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

  //#endregion
];
