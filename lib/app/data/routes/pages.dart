import 'package:central_heating_control/app/presentation/screens/settings/preferences/datetime_format_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/language_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/network_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/preferences_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/saver_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/theme_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/timezone_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/settings_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/screens/home/home_screen.dart';
import 'package:central_heating_control/app/presentation/screens/developer/developer_screen.dart';

final getPages = [
  GetPage(
    name: Routes.home,
    page: () => const HomeScreen(),
  ),
  GetPage(
    name: Routes.developer,
    page: () => const DeveloperScreen(),
  ),
  GetPage(
    name: Routes.settings,
    page: () => const SettingsScreen(),
  ),
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
];
