// Dart imports:
// Package imports:
import 'dart:convert';

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/models/wifi.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:get_storage/get_storage.dart';

class Box {
  //#region BASE METHODS
  static Future<void> setString({
    required String key,
    required String value,
  }) async {
    final box = GetStorage();
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

  //#region FLAGS
  Future<void> markLanguageSelected() async =>
      await setBool(key: Keys.didLanguageSelected, value: true);
  Future<void> markTimezoneSelected() async =>
      await setBool(key: Keys.didTimezoneSelected, value: true);
  Future<void> markActivated() async =>
      await setBool(key: Keys.didActivated, value: true);

  bool get didLanguageSelected => getBool(key: Keys.didLanguageSelected);
  bool get didTimezoneSelected => getBool(key: Keys.didTimezoneSelected);
  bool get didActivated => getBool(key: Keys.didActivated);
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
}
