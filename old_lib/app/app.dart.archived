import 'dart:ui';

import 'package:central_heating_control/app/core/constants/strings.dart';
import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/core/theme/theme.dart';
import 'package:central_heating_control/app/core/utils/theme.dart';
import 'package:central_heating_control/app/data/routes/pages.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/bindings.dart';
import 'package:central_heating_control/app/presentation/screens/lock/user_list.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:central_heating_control/app/presentation/widgets/wallpaper.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:screen_saver/screen_saver_definition.dart';
import 'package:screen_saver/screen_saver_observer.dart';
import 'package:screen_saver/screen_saver_wrapper.dart';

final screenSaverDefinition = ScreenSaverDefinition(
  date: const DateTextWidget(large: true),
  logo: const LogoWidget(
    themeMode: ThemeMode.dark,
    height: 30,
  ),
  content: const WallpaperWidget(),
  target: const UserListScreen(),
);

class PiScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,

        // etc.
      };
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenSaverWrapper(
        definition: screenSaverDefinition,
        excludedRoutes: autoLockExcludedRoutes,
        allowNoUser: !enabledLocalUsers,
        timerDuration: 600,
        child: RestartWidget(
          child: Builder(builder: (context) {
            final theme = MaterialTheme(
                ThemeUtils.createTextTheme(context, "Roboto", "Roboto Flex"));
            return GetMaterialApp(
              navigatorObservers: [
                ScreenSaverObserver(
                    autoLockExcludedRoutes: autoLockExcludedRoutes)
              ],
              scrollBehavior: PiScrollBehavior(),
              debugShowCheckedModeBanner: false,
              title: UiStrings.appName,
              theme: theme.light(),
              darkTheme: theme.dark(),
              highContrastTheme: theme.lightHighContrast(),
              highContrastDarkTheme: theme.darkHighContrast(),
              themeMode: getThemeMode(),
              defaultTransition: Transition.circularReveal,
              getPages: getPages,
              initialRoute: Routes.home,
              initialBinding: AppBindings(),
              locale: LocalizationService.locale,
              fallbackLocale: LocalizationService.fallbackLocale,
              translationsKeys: LocalizationService.keys,
              onReady: onReady,
              builder: FlutterSmartDialog.init(),
            );
          }),
        ),
      );
    });
    /* return RestartWidget(
      child: Builder(builder: (context) {
        final theme = MaterialTheme(
            ThemeUtils.createTextTheme(context, "Roboto", "Roboto Flex"));
        return IdleDetector(
          excludedRoutes: const [
            Routes.setup,
            Routes.developer,
            Routes.screenSaver,
            // Routes.setupAdminUser,
          ],
          child: GetMaterialApp(
            scrollBehavior: PiScrollBehavior(),
            debugShowCheckedModeBanner: false,
            title: UiStrings.appName,
            theme: theme.light(),
            darkTheme: theme.dark(),
            highContrastTheme: theme.lightHighContrast(),
            highContrastDarkTheme: theme.darkHighContrast(),
            themeMode: Box.getBool(key: Keys.isDarkMode)
                ? ThemeMode.dark
                : ThemeMode.light,
            defaultTransition: Transition.circularReveal,
            getPages: getPages,
            initialRoute: Routes.home,
            initialBinding: AppBindings(),
            locale: LocalizationService.locale,
            fallbackLocale: LocalizationService.fallbackLocale,
            translationsKeys: LocalizationService.keys,
            onReady: onReady,
            builder: FlutterSmartDialog.init(),
          ),
        );
      }),
    ); */
  }

  void onReady() async {
    // apply saved language and locale
    await LocalizationService().applySavedLocale();
    // remove splash screen
    FlutterNativeSplash.remove();

    // localization
    initializeDateFormatting(
        '${LocalizationService.locale.languageCode}_${LocalizationService.locale.countryCode?.toUpperCase()}');
  }

  ThemeMode getThemeMode() {
    final AppController appController = Get.find();
    return appController.preferencesDefinition.isDark
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
