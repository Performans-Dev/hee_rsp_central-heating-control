import 'package:central_heating_control/app/app.dart';
import 'package:central_heating_control/app/data/services/bindings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
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
  bool isPi = !kDebugMode;

  ///
  ///
  ///
  ///
  ///
  ///

  // shared preferences
  await GetStorage.init();

  // final box = GetStorage();
  // await box.erase();

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

  // bind services
  await AppBindings().dependencies();

  // run app
  runApp(const MainApp());
}
