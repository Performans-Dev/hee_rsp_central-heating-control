import 'package:central_heating_control/app/data/middlewares/platform_middleware.dart';
import 'package:central_heating_control/app/presentation/screens/settings/advanced/advanced_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_users/add_new_user_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/app_users/app_users_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/device_add_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/device_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/management_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/group/group_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/datetime_format_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/language_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/network_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/preferences_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/saver_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/theme_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/timezone_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/settings_screen.dart';
import 'package:central_heating_control/app/presentation/screens/splash/read_platform_info.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/screens/home/home_screen.dart';
import 'package:central_heating_control/app/presentation/screens/developer/developer_screen.dart';

final getPages = [
  GetPage(
    name: Routes.home,
    page: () => const HomeScreen(),
    middlewares: [PlatformMiddleware()],
  ),
  GetPage(
    name: Routes.developer,
    page: () => const DeveloperScreen(),
  ),
  // MARK: Settings
  GetPage(
    name: Routes.settings,
    page: () => const SettingsScreen(),
  ),

  // MARK: Preferences
  GetPage(
    name: Routes.preferences,
    page: () => const PreferencesScreen(),
  ),
  GetPage(
    name: Routes.preferencesLanguage,
    page: () => const PreferencesLanguageScreen(),
  ),
  GetPage(
    name: Routes.preferencesTimezone,
    page: () => const PreferencesTimezoneScreen(),
  ),
  GetPage(
    name: Routes.preferencesDatetimeFormat,
    page: () => const PreferencesDateTimeFormatScreen(),
  ),
  GetPage(
    name: Routes.preferencesTheme,
    page: () => const PreferencesThemeScreen(),
  ),
  GetPage(
    name: Routes.preferencesScreenSaver,
    page: () => const PreferencesScreenSaverScreen(),
  ),
  GetPage(
    name: Routes.preferencesNetworkConnections,
    page: () => const PreferencesNetworkConnectionsScreen(),
  ),

  // MARK: Management
  GetPage(
    name: Routes.management,
    page: () => const ManagementScreen(),
  ),
  GetPage(
    name: Routes.managementZones,
    page: () => const ManagementZoneListScreen(),
  ),
  GetPage(
    name: Routes.managementDevices,
    page: () => const ManagementDeviceListScreen(),
  ),
  GetPage(
    name: Routes.managementAddDevice,
    page: () => const ManagementDeviceAddScreen(),
  ),

  // MARK: Advanced
  GetPage(
    name: Routes.advanced,
    page: () => const AdvancedScreen(),
  ),

  // MARK: App Users
  GetPage(
    name: Routes.appUsers,
    page: () => const AppUsersScreen(),
  ),
  GetPage(
    name: Routes.addNewAppUser,
    page: () => const AddNewAppUserScreen(),
  ),

  // MARK: Splash
  GetPage(
    name: Routes.splashReadPlatformInfo,
    page: () => const SplashReadPlatformInfoScreen(),
  ),
];
