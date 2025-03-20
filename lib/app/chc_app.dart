import 'package:central_heating_control/app/core/extensions/pi_scroll.dart';
import 'package:central_heating_control/app/core/extensions/restart.dart';
import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/core/theme/theme.dart';
import 'package:central_heating_control/app/core/theme/theme_utils.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/controllers/bindings.dart';
import 'package:central_heating_control/app/presentation/screens/developer/developer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

class ChcApp extends StatelessWidget {
  const ChcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return RestartWidget(
        child: Builder(builder: (context) {
          final theme = MaterialTheme(
              ThemeUtils.createTextTheme(context, "Roboto", "Roboto Flex"));
          return GetMaterialApp(
            title: 'Central Heating Control',
            debugShowCheckedModeBanner: false,
            scrollBehavior: PiScrollBehavior(),
            theme: theme.light(),
            darkTheme: theme.dark(),
            highContrastTheme: theme.lightHighContrast(),
            highContrastDarkTheme: theme.darkHighContrast(),
            themeMode: getThemeMode(),
            defaultTransition: Transition.circularReveal,
            home: const DeveloperScreen(),
            initialBinding: AppBindings(),
            locale: LocalizationService.locale,
            fallbackLocale: LocalizationService.fallbackLocale,
            translationsKeys: LocalizationService.keys,
            onReady: onReady,
            builder: FlutterSmartDialog.init(),
          );
        }),
      );
    });
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
    return appController.preferences.isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
