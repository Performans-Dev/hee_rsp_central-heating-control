import 'package:central_heating_control/app/app.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/services/app.dart';

import 'package:central_heating_control/app/data/services/bindings.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

final Logger logger = Logger();
Future<void> main() async {
  ///
  ///
  ///
  ///
  ///
  ///
  bool isPi = !GetPlatform.isMacOS;

  ///
  ///
  ///
  ///
  ///
  ///

  // shared preferences
  await GetStorage.init();

  // await for flutter widgets bindings
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // init database
  sqfliteFfiInit();

  // apply window options
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: !isPi ? const Size(800, 480) : null,
    backgroundColor: Colors.black,
    skipTaskbar: false,
    // center: true,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    if (isPi) {
      await windowManager.setFullScreen(true);
    }
    await windowManager.focus();
  });

  // localization
  initializeDateFormatting();

  // bind services
  await AppBindings().dependencies();

  // Box.setBool(key: Keys.didLanguageSelected, value: false);
  // Box.setBool(key: Keys.didTimezoneSelected, value: false);
  // Box.setBool(key: Keys.didDateFormatSelected, value: false);
  // Box.setBool(key: Keys.didPickedTheme, value: false);
  // Box.setBool(key: Keys.didRegisteredDevice, value: false);
  // Box.setBool(key: Keys.didActivated, value: false);
  // await DbProvider.db.deleteUser(
  // AppUser(id: 1, username: "Admin User", pin: "0000000", isAdmin: true));
  // await DbProvider.db
  //     .deleteUser(AppUser(id: 2, username: "İo", pin: "123456", isAdmin: true));

  // run app
  runApp(const MainApp());
}
