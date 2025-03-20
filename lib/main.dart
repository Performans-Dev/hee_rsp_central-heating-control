import 'dart:io';

import 'package:central_heating_control/app/chc_app.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/data/controllers/bindings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

bool isPi = !kDebugMode;

Future<void> main() async {
  //#region MARK: Splash

  // await for flutter widgets bindings to initialize
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //#endregion

  //#region MARK: GetStorage
  await GetStorage.init();
  final documentsDirectory = await getApplicationDocumentsDirectory();

  final box = GetStorage();
  box.write(
    Keys.documentsDirectoryPath,
    isPi ? Keys.piPath : documentsDirectory.path,
  );

  // Uncomment to erase the box
  // await box.erase();

  //#endregion

  //#region MARK: PID
  if (GetPlatform.isLinux) {
    final pidFile = File('/tmp/app_pid');
    if (pidFile.existsSync()) {
      final oldAppPid = int.tryParse(await pidFile.readAsString());
      if (oldAppPid != null && oldAppPid != pid) {
        // Avoid killing itself
        try {
          print('Terminating previous app with PID: $oldAppPid');
          Process.killPid(oldAppPid, ProcessSignal.sigterm);
        } catch (e) {
          print('Error terminating previous app: $e');
        }
      }
    }
    // Write the current app's PID to the file
    await pidFile.writeAsString('$pid');
  }

  //#endregion

  //#region MARK: DB
  sqfliteFfiInit();
  //#endregion

  //#region MARK: Window
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    size: !isPi ? const Size(800, 480) : null,
    backgroundColor: Colors.black,
    skipTaskbar: false,
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
  //#endregion

  //#region MARK: Services
  await AppBindings().dependencies();
  //#endregion

  runApp(const ChcApp());
}
