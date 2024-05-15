import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/constants/strings.dart';
import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/core/theme/dark.dart';
import 'package:central_heating_control/app/core/theme/light.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/routes/pages.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/bindings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: UiStrings.appName,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode:
          Box.getBool(key: Keys.isDarkMode) ? ThemeMode.dark : ThemeMode.light,
      defaultTransition: Transition.circularReveal,
      getPages: getPages,
      initialRoute: Routes.home,
      initialBinding: AppBindings(),
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      translationsKeys: LocalizationService.keys,
      onReady: onReady,
    );
  }

  void onReady() async {
    // apply saved language and locale
    await LocalizationService().applySavedLocale();

    // remove splash screen
    FlutterNativeSplash.remove();

    // apply theme from disk
    final AppController appController = Get.find();
    bool isDarkModeOnDisk = Box.getBool(key: Keys.isDarkMode);
    bool isDarkModeOnApp = appController.isDarkMode;
    if (isDarkModeOnApp != isDarkModeOnDisk) {
      appController.toggleDarkMode();
    }
  }
}
