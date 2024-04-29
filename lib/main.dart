import 'package:central_heating_control/app/app.dart';
import 'package:central_heating_control/app/data/services/bindings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  // shared preferences
  await GetStorage.init();

  // await for flutter widgets bindings
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // apply window options
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1024, 768),
    center: true,
    backgroundColor: Colors.black,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // localization
  initializeDateFormatting();

  // bind services
  await AppBindings().dependencies();

  // run app
  runApp(const MainApp());
}
