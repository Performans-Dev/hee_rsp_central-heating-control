import 'package:central_heating_control/app/app.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/data/services/bindings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

// final Logger logger = Logger();
bool isPi = !kDebugMode;
Future<void> main() async {

  // shared preferences
  await GetStorage.init();
  final documentsDirectory = await getApplicationDocumentsDirectory();

  final box = GetStorage();
  //

  box.write(
    Keys.documentsDirectoryPath,
    isPi ? Keys.piPath : documentsDirectory.path,
  );

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

  /// OVERRIDE SETTINGS TO SKIP SETUP SEQUENCE
  //#region SkipSetup
  /* Box.setBool(key: Keys.didLanguageSelected, value: true);
  Box.setBool(key: Keys.didTimezoneSelected, value: true);
  Box.setBool(key: Keys.didDateFormatSelected, value: true);
  Box.setBool(key: Keys.didThemeSelected, value: true);
  Box.setString(key: Keys.localeLang, value: 'tr');
  Box.setString(
      key: Keys.selectedTimezone,
      value: StaticProvider.getTimezoneList.first['name']);
  Box.setString(
      key: Keys.selectedDateFormat,
      value: StaticProvider.getDateFormatList.first);
  Box.setSelectedTheme(StaticProvider.getThemeList.first);

  Account account = Account(
    id: 'test',
    displayName: 'test',
    email: 'test',
    status: 1,
    token: 'test',
    createdAt: 'test',
  );
  ActivationResult activationResult = ActivationResult(
    id: 'test',
    createdAt: 'test',
    chcDeviceId: 'test',
    userId: 'test',
    status: 1,
    activationTime: 'test',
  );
  Box.setString(key: Keys.account, value: account.toJson());
  Box.setString(key: Keys.activationResult, value: activationResult.toJson()); */
  //#endregion
  /// OVERRIDE SETTINGS TO SKIP SETUP SEQUENCE

  // bind services
  await AppBindings().dependencies();

  // run app
  runApp(const MainApp());
}
