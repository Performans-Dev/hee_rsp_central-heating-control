import 'package:central_heating_control/app/app.dart';
import 'package:central_heating_control/app/data/services/bindings.dart';
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
  // shared preferences
  await GetStorage.init();

  // await for flutter widgets bindings
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // init database
  sqfliteFfiInit();

  //TODO: get width-height, set window size if not 800x480

  // apply window options
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: GetPlatform.isMacOS ? const Size(800, 480) : null,
    backgroundColor: Colors.black,
    skipTaskbar: false,
    // center: true,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    if (!GetPlatform.isMacOS) {
      await windowManager.setFullScreen(true);
    }
    await windowManager.focus();
  });

  // localization
  initializeDateFormatting();

  // bind services
  await AppBindings().dependencies();

  // run app
  runApp(const MainApp());
}
