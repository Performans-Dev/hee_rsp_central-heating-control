// Dart imports:
// Package imports:
import 'dart:convert';
import 'dart:developer';

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/data/models/account.dart';
import 'package:central_heating_control/app/data/models/account_subscription_type.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/models/preferences.dart';
import 'package:central_heating_control/app/data/models/wifi.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:get_storage/get_storage.dart';

class Box {
  //#region BASE METHODS
  static Future<void> setString({
    required String key,
    required String value,
  }) async {
    final box = GetStorage();
    LogService.addLog(LogDefinition(message: 'Box: setting $key to $value'));
    await box.write(key, value);
  }

  static String getString({
    required String key,
    String? defaultVal,
  }) {
    final box = GetStorage();
    return box.read(key) ?? (defaultVal ?? "");
  }

  static Future<void> setInt({
    required String key,
    required int value,
  }) async {
    final box = GetStorage();
    await box.write(key, value);
  }

  static int getInt({
    required String key,
    int? defaultVal,
  }) {
    final box = GetStorage();
    return box.read(key) ?? defaultVal ?? 0;
  }

  static Future<void> setBool({
    required String key,
    required bool value,
  }) async {
    final box = GetStorage();
    await box.write(key, value);
  }

  static bool getBool({
    required String key,
    bool? defaultVal,
  }) {
    final box = GetStorage();
    return box.read(key) ?? defaultVal ?? false;
  }
  //#endregion

  //#region DB PATH
  static String get documentsDirectoryPath =>
      getString(key: Keys.documentsDirectoryPath);
  //#endregion

  //#region FLAGS
  Future<void> markLanguageSelected() async =>
      await setBool(key: Keys.didLanguageSelected, value: true);
  Future<void> markTimezoneSelected() async =>
      await setBool(key: Keys.didTimezoneSelected, value: true);
  Future<void> markActivated() async =>
      await setBool(key: Keys.didActivated, value: true);
  Future<void> markConnected() async =>
      await setBool(key: Keys.didConnected, value: true);

  bool get didLanguageSelected => getBool(key: Keys.didLanguageSelected);
  bool get didTimezoneSelected => getBool(key: Keys.didTimezoneSelected);
  bool get didActivated => getBool(key: Keys.didActivated);
  bool get didconnected => getBool(key: Keys.didConnected);

  //#endregion

  //#region THEME
  static String get selectedTheme {
    return getString(
      key: Keys.selectedTheme,
      defaultVal: 'default',
    );
  }

  static Future<void> setSelectedTheme(String theme) async => await setString(
        key: Keys.selectedTheme,
        value: theme,
      );

  //#endregion

  //#region DEVICE-ID
  static String get deviceId {
    String id = getString(key: Keys.deviceId, defaultVal: "");
    if (id.isNotEmpty) {
      return id;
    } else {
      String newId = Guid.newGuid.toString();
      setString(key: Keys.deviceId, value: newId);
      return newId;
    }
  }
  //#endregion

  //#region WIFI
  Future<void> saveWifiCredentials(WiFiCredentials w) async => await setString(
        key: Keys.wifiCredentials,
        value: w.toJson(),
      );

  WiFiCredentials get wiFiCredentials {
    try {
      return WiFiCredentials.fromJson(getString(key: Keys.wifiCredentials));
    } on Exception catch (_) {
      return WiFiCredentials(ssid: '', password: '');
    }
  }
  //#endregion

  //#region USERS
  Future<void> saveUsers(List<AppUser> users) async => await setString(
        key: Keys.userList,
        value: json.encode(users.map((x) => x.toMap()).toList()),
      );

  List<AppUser> get users {
    final result = <AppUser>[];
    try {
      final data = json.decode(getString(key: Keys.userList));
      for (final map in data) {
        result.add(AppUser.fromMap(map));
      }
    } on Exception catch (_) {}
    return result;
  }
  //#endregion

  //#region SCREEN SAVER
  static Future<void> handleTouch() async {
    log('saving last touch');
    await setInt(
        key: Keys.lastTouchTime, value: DateTime.now().millisecondsSinceEpoch);
  }

  static DateTime get lastTouchTime =>
      DateTime.fromMicrosecondsSinceEpoch(getInt(key: Keys.lastTouchTime));
  //#endregion

  //#region Account
  static Account? get account {
    final String data = getString(key: Keys.account);
    if (data.isNotEmpty) {
      try {
        return Account.fromJson(data);
      } on Exception catch (_) {
        return null;
      }
    }
    return null;
  }

  static AccountSubscription? get accountSubscription {
    const String data = '{"id": "123", "status": "active"}';
    //final String data = getString(key: Keys.subscriptionResult);
    if (data.isNotEmpty) {
      try {
        return AccountSubscription.fromJson(data);
      } on Exception catch (_) {
        return null;
      }
    }
    return null;
  }
  //#endregion

  static PreferencesDefinition? get preferences {
    final String data = getString(key: Keys.preferences);
    if (data.isNotEmpty) {
      try {
        return PreferencesDefinition.fromJson(data);
      } on Exception catch (_) {
        return null;
      }
    }
    return null;
  }
}
