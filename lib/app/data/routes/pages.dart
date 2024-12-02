import 'package:central_heating_control/app/data/middlewares/admin_logged_in_middleware.dart';
import 'package:central_heating_control/app/data/middlewares/app_settings_middleware.dart';

import 'package:central_heating_control/app/data/middlewares/initialize_app_middleware.dart';
import 'package:central_heating_control/app/data/middlewares/setup_completed_middleware.dart';
import 'package:central_heating_control/app/data/middlewares/tech_support_logged_in_middleware.dart';
import 'package:central_heating_control/app/data/middlewares/user_logged_in_middleware.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';

import 'package:central_heating_control/app/presentation/screens/functions/function_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/home/home_screen.dart';
import 'package:central_heating_control/app/presentation/screens/lock/user_list.dart';
import 'package:central_heating_control/app/presentation/screens/misc/pi_info/pi_info_screen.dart';

import 'package:central_heating_control/app/presentation/screens/mode/mode_screen.dart';
import 'package:central_heating_control/app/presentation/screens/pin_reset/entry.dart';
import 'package:central_heating_control/app/presentation/screens/pin_reset/info.dart';
import 'package:central_heating_control/app/presentation/screens/pin_reset/result.dart';

import 'package:central_heating_control/app/presentation/screens/pin_reset/signin.dart';
import 'package:central_heating_control/app/presentation/screens/settings/functions/settings_function_add_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/functions/settings_function_edit_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/functions/settings_function_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/logs.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/settings_device_add_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/settings_device_edit_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/settings_device_list_screen.dart';

import 'package:central_heating_control/app/presentation/screens/settings/management/sensor/settings_sensor_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/settings_management_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/zone/settings_zone_add_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/zone/settings_zone_edit_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/zone/settings_zone_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/plans/plan_detail.dart';
import 'package:central_heating_control/app/presentation/screens/settings/plans/plan_list.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/advanced/diagnostics/settings_preferences_advanced_diagnostics_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/advanced/hardware_config/settings_preferences_advanced_hardware_addnew_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/advanced/hardware_config/settings_preferences_advanced_hardware_config_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/advanced/settings_preferences_advanced_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/advanced/updates/settings_preferences_advanced_updates_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/connection/settings_preferences_connection_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/date_format/settings_preferences_date_format_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/language/settings_preferences_language_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/lock_screen/settings_preferences_lock_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/settings_preferences.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/theme/settings_preferences_theme_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/preferences/timezone/settings_preferences_timezone_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/settings_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/users/users_add_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/users/users_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/activation.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/admin.dart';
import 'package:central_heating_control/app/presentation/screens/connection/connection.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/date_time.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/device_register.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/language.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/privacy.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/signin.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/subscription.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/tech_support.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/terms.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/theme.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/screens/timezone.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_screen.dart';
import 'package:central_heating_control/app/presentation/screens/splash/splash_app_settings_screen.dart';
import 'package:central_heating_control/app/presentation/screens/splash/splash_app_user_list_screen.dart';
import 'package:central_heating_control/app/presentation/screens/splash/splash_device_info_screen.dart';

import 'package:central_heating_control/app/presentation/screens/zone/zone_screen.dart';
import 'package:get/get.dart';

final List<GetPage> getPages = [
  //#region MARK: SETUP
  GetPage(
    name: Routes.setup,
    page: () => const SetupScreen(),
    middlewares: [
      AppSettingsMiddleware(),
      // ConnectionMiddleware(returnRoute: Routes.setup),
    ],
    transition: Transition.size,
  ),
  GetPage(
    name: Routes.setupLanguage,
    page: () => const SetupSequenceLanguageScreen(),
  ),
  GetPage(
    name: Routes.setupTimezone,
    page: () => const SetupSequenceTimezoneScreen(),
  ),
  GetPage(
    name: Routes.setupDateTime,
    page: () => const SetupSequenceDateTimeScreen(),
  ),
  GetPage(
    name: Routes.setupTheme,
    page: () => const SetupSequenceThemeScreen(),
  ),
  GetPage(
    name: Routes.setupTerms,
    page: () => const SetupSequenceTermsOfUseScreen(),
  ),
  GetPage(
    name: Routes.setupPrivacy,
    page: () => const SetupSequencePrivacyPolicyScreen(),
  ),
  GetPage(
    name: Routes.setupRegisterDevice,
    page: () => const SetupSequenceRegisterDeviceScreen(),
  ),
  GetPage(
    name: Routes.setupSignin,
    page: () => const SetupSequenceSignInScreen(),
  ),
  GetPage(
    name: Routes.setupActivation,
    page: () => const SetupSequenceActivationScreen(),
  ),
  GetPage(
    name: Routes.setupSubscriptionResult,
    page: () => const SetupSequenceSubscriptionResultScreen(),
  ),
  GetPage(
    name: Routes.setupTechSupport,
    page: () => const SetupSequenceTechSupportScreen(),
  ),
  GetPage(
    name: Routes.setupAdminUser,
    page: () => const SetupSequenceAdminUserScreen(),
  ),
  GetPage(
    name: Routes.connection,
    page: () => const ConnectionScreen(),
  ),

  //#endregion
  GetPage(
    name: Routes.settingsConnection,
    page: () => const SettingsPreferencesConnectionScreen(),
  ),
  GetPage(
    name: Routes.home,
    page: () => const HomeScreen(),
    middlewares: [
      InitializeAppMiddleware(),
      SetupCompletedMiddleware(),
      UserLoggedInMiddleware(),
    ],
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: Routes.zone,
    page: () => const ZoneScreen(),
    middlewares: [
      UserLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.logs,
    page: () => const LogViewScreen(),
    transition: Transition.zoom,
  ),
  GetPage(
    name: Routes.functions,
    page: () => const FunctionListScreen(),
    middlewares: [
      UserLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settings,
    page: () => const SettingsScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsManagement,
    page: () => const SettingsManagementScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsZoneList,
    page: () => const SettingsZoneListScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsZoneAdd,
    page: () => const SettingsZoneAddScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsZoneEdit,
    page: () => const SettingsZoneEditScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsDeviceList,
    page: () => const SettingsDeviceListScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsDeviceAdd,
    page: () => const SettingsDeviceAddScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsDeviceEdit,
    page: () => const SettingsDeviceEditScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsSensorList,
    page: () => const SettingsSensorListScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),

  GetPage(
    name: Routes.settingsUserList,
    page: () => const SettingsUserListScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsUserAdd,
    page: () => const SettingsUserAddScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsFunctionList,
    page: () => const SettingsFunctionListScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsFunctionAdd,
    page: () => const SettingsFunctionAddScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsFunctionEdit,
    page: () => const SettingsFunctionEditScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferences,
    page: () => const SettingsPreferencesScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferencesTheme,
    page: () => const SettingsPreferencesThemeScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferencesLockScreen,
    page: () => const SettingsPreferencesLockScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferencesLanguage,
    page: () => const SettingsPreferencesLanguageScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferencesTimezone,
    page: () => const SettingsPreferencesTimezoneScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferencesDateFormat,
    page: () => const SettingsPreferencesDateFormatScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferencesConnection,
    page: () => const SettingsPreferencesConnectionScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferencesAdvanced,
    page: () => const SettingsPreferencesAdvancedScreen(),
    middlewares: [
      TechSupportLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferencesAdvancedHardwareConfig,
    page: () => const SettingsPreferencesAdvancedHardwareConfigScreen(),
    middlewares: [
      TechSupportLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferencesAdvancedHardwareConfigAddNew,
    page: () => const SettingsPreferencesAdvancedHardwareConfigAddNewScreen(),
    middlewares: [
      TechSupportLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferencesAdvancedDiagnostics,
    page: () => const SettingsPreferencesAdvancedDiagnosticsScreen(),
    middlewares: [
      TechSupportLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPreferencesAdvancedUpdates,
    page: () => const SettingsPreferencesAdvancedUpdatesScreen(),
    middlewares: [
      TechSupportLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPlanList,
    page: () => const SettingsPlanListScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.settingsPlanDetail,
    page: () => const SettingsPlanDetailScreen(),
    middlewares: [
      AdminLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.lockUserListScreen,
    page: () => const UserListScreen(),
    transition: Transition.fadeIn,
  ),

  //
  GetPage(
    name: Routes.pinResetInfo,
    page: () => const PinResetInfoScreen(),
  ),
  GetPage(
    name: Routes.pinResetSignin,
    page: () => const PinResetSigninScreen(),
  ),
  GetPage(
    name: Routes.pinResetEntry,
    page: () => const PinResetEntryScreen(),
  ),
  GetPage(
    name: Routes.pinResetResult,
    page: () => const PinResetResultScreen(),
  ),
  //
  GetPage(
    name: Routes.mode,
    page: () => const ModeScreen(),
    middlewares: [
      UserLoggedInMiddleware(),
    ],
  ),
  GetPage(
    name: Routes.splashDeviceInfo,
    page: () => const SplashDeviceInfoScreen(),
  ),
  GetPage(
    name: Routes.splashAppUserList,
    page: () => const SplashAppUserListScreen(),
  ),
/*   GetPage(
    name: Routes.splashInternetConnectionProgress,
    page: () => const SplashInternetConnectionProgressScreen(),
  ), */
  GetPage(
    name: Routes.splashAppSettings,
    page: () => const SplashAppSettingsScreen(),
  ),

  ///
  ///
  GetPage(name: Routes.piInfo, page: () => const PiInfoScreen()),

  ////////////////////////////////////////////////////////////////////////////////////////////////
  // GetPage(
  //   name: Routes.developer,
  //   page: () => const DeveloperScreen(),
  // ),
  // GetPage(
  //   name: Routes.signin,
  //   page: () => const SigninScreen(),
  // ),
  // GetPage(
  //   name: Routes.registerDevice,
  //   page: () => const RegisterDeviceScreen(),
  // ),
  // GetPage(
  //   name: Routes.checkSubscription,
  //   page: () => const CheckSubscriptionScreen(),
  // ),
  // GetPage(
  //   name: Routes.checkConnection,
  //   page: () => const CheckConnectionScreen(),
  // ),
  // GetPage(
  //   name: Routes.setupAdminUser,
  //   page: () => const SetupAdminUserScreen(),
  // ),
  // GetPage(
  //   name: Routes.splashFetchSettings,
  //   page: () => const SplashFetchSettingsScreen(),
  // ),
  // GetPage(
  //   name: Routes.splashConnection,
  //   page: () => const SplashConnectionScreen(),
  // ),
  // GetPage(
  //   name: Routes.setupTheme,
  //   page: () => const SetupThemeScreen(),
  //   transition: Transition.fadeIn,
  // ),
  // GetPage(
  //   name: Routes.setupLanguage,
  //   page: () => const SetupLanguageScreen(),
  //   transition: Transition.fadeIn,
  // ),
  // GetPage(
  //   name: Routes.setupTimezone,
  //   page: () => const SetupTimezoneScreen(),
  //   transition: Transition.fadeIn,
  // ),
  // GetPage(
  //   name: Routes.setupDateFormat,
  //   page: () => const SetupDateFormatScreen(),
  //   transition: Transition.fadeIn,
  // ),
  // GetPage(
  //   name: Routes.setupConnection,
  //   page: () => const SetupConnectionScreen(),
  //   transition: Transition.fadeIn,
  // ),

  //#region SETTINGS
  // GetPage(
  //   name: Routes.settingstZoneDeviceSensorManagement,
  //   page: () => const SettingsZoneDeviceSensorManagementScreen(),
  //   middlewares: [
  //     AdminMiddleware(),
  //   ],
  // ),
  // GetPage(
  //   name: Routes.settingsUserList,
  //   page: () => const SettingsUserListScreen(),
  //   middlewares: [
  //     AdminMiddleware(),
  //   ],
  // ),
  // GetPage(
  //   name: Routes.settingsUserAdd,
  //   page: () => const SettingsUserAddScreen(),
  //   middlewares: [
  //     AdminMiddleware(),
  //   ],
  // ),

  // GetPage(
  //   name: Routes.settingsWifiCredentials,
  //   page: () => const WifiCredentialsScreen(),
  //   middlewares: [
  //     AdminMiddleware(),
  //   ],
  // ),

  // //#endregion

  // GetPage(
  //   name: Routes.daySummaryScreen,
  //   page: () => const DaySummaryScreen(),
  // ),

  // GetPage(
  //   name: Routes.shellTest,
  //   page: () => const ShellTestScreen(),
  // ),
  // GetPage(
  //   name: Routes.commandTest,
  //   page: () => const CommandTestScreen(),
  // ),
];

const List<String> autoLockExcludedRoutes = [
  Routes.lockScreen,
  Routes.developer,
  Routes.settingsPreferencesAdvancedDiagnostics,
  Routes.settingsPreferencesAdvancedHardwareConfig,
  Routes.settingsPreferencesAdvancedUpdates,
  Routes.settingsPreferencesAdvanced,
  Routes.pinResetSignin,
  Routes.pinResetInfo,
  Routes.pinResetEntry,
  Routes.pinResetResult,
  Routes.setup,
  Routes.setupActivation,
  Routes.setupAdminUser,
  Routes.setupDateTime,
  Routes.setupLanguage,
  Routes.setupPrivacy,
  Routes.setupRegisterDevice,
  Routes.setupSignin,
  Routes.setupSubscriptionResult,
  Routes.setupTechSupport,
  Routes.setupTerms,
  Routes.setupTheme,
  Routes.setupTimezone,
  Routes.piInfo
];
