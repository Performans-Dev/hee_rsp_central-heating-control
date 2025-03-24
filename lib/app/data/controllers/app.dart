// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/preferences/preferences.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class AppController extends GetxController {
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;
  final Connectivity _connecivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    print('AppController onInit');

    loadPreferencesFromBox();
    initConnectivity();
  }

  @override
  void onReady() {
    print('AppController onReady');
    super.onReady();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  //#region MARK: Preferences
  final _preferences = Preferences.empty().obs;
  Preferences get preferences => _preferences.value;
  void setPreferences(Preferences p) {
    _preferences.value = p;
    update();
    savePreferencesToBox();
  }
  //#endregion

  //#region MARK: Box
  Future<void> savePreferencesToBox() async {
    await Box.setString(
      key: Keys.preferences,
      value: _preferences.value.toJson(),
    );
  }

  void loadPreferencesFromBox() {
    final json = Box.getString(key: Keys.preferences);
    if (json.isNotEmpty) {
      _preferences.value = Preferences.fromJson(json);
      update();
    }
  }
  //#endregion

  //#region MARK: Connectivity
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> results;
    try {
      results = await _connecivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status $e');
      return;
    }

    _connectivitySubscription =
        _connecivity.onConnectivityChanged.listen(_onConnectivityChanged);
    _onConnectivityChanged(results);
  }

  final RxBool _didConnectivityResultReceived = false.obs;
  bool get didConnectivityResultReceived =>
      _didConnectivityResultReceived.value;

  final RxBool _didConnected = false.obs;
  bool get didConnected => _didConnected.value;

  final RxBool _didConnectionChecked = false.obs;
  bool get didConnectionChecked => _didConnectionChecked.value;

  final Rx<NetworkIndicator> _networkIndicator = NetworkIndicator.none.obs;
  NetworkIndicator get networkIndicator => _networkIndicator.value;

  final Rxn<String> _networkName = Rxn();
  String? get networkName => _networkName.value;

  final Rxn<String> _networkIP = Rxn();
  String? get networkIp => _networkIP.value;

  final Rxn<String> _networkGateway = Rxn();
  String? get networkGateway => _networkGateway.value;

  final Rxn<String> _eth0Mac = Rxn();
  String? get eth0Mac => _eth0Mac.value;

  final Rxn<String> _wlan0Mac = Rxn();
  String? get wlan0Mac => _wlan0Mac.value;

  _onConnectivityChanged(List<ConnectivityResult> results) {
    bool connected = false;
    for (final result in results) {
      if (!connected) {
        switch (result) {
          case ConnectivityResult.wifi:
            connected = true;
            _networkIndicator.value = NetworkIndicator.wifi;
            break;
          case ConnectivityResult.ethernet:
            connected = true;
            _networkIndicator.value = NetworkIndicator.ethernet;
            break;
          case ConnectivityResult.vpn:
          case ConnectivityResult.mobile:
          case ConnectivityResult.bluetooth:
            connected = true;
            _networkIndicator.value = NetworkIndicator.none;
            break;
          default:
            connected = false;
            _networkIndicator.value = NetworkIndicator.none;
            break;
        }
      }
    }
    _didConnected.value = connected;
    _didConnectivityResultReceived.value = true;
    update();
    getNetworkInfo();
  }

  Future<void> getMacAddresses() async {
    final processResult = await Process.run('ip', ['link']);
    final ipLinkOutput = processResult.stdout as String;

    final macPattern =
        RegExp(r'^\d+: (\S+): .*\n\s+link/ether ([\da-f:]+)', multiLine: true);

    String? ethMac;
    String? wifiMac;

    for (final match in macPattern.allMatches(ipLinkOutput)) {
      final interface = match.group(1);
      final macAddress = match.group(2);

      if (interface != null && interface.contains(RegExp(r'enp|eth'))) {
        ethMac = macAddress;
      } else if (interface != null && interface.contains(RegExp(r'wl|wlan'))) {
        wifiMac = macAddress;
      }
    }
    _eth0Mac.value = ethMac;
    _wlan0Mac.value = wifiMac;
    update();
  }

  // Future<void> checkInternetConnection() async {
  //   final result = await AppProvider.testInternetConnection();
  //   _didConnected.value = result;
  //   _didConnectionChecked.value = true;
  //   update();
  // }

  Future<void> getNetworkInfo() async {
    _networkName.value = '';
    _networkIP.value = '';
    _networkGateway.value = '';
    _eth0Mac.value = '';
    _wlan0Mac.value = '';
    update();
    if (isPi) {
      await getMacAddresses();
    }
    final info = NetworkInfo();
    final wifiName = await info.getWifiName();
    final wifiIp = await info.getWifiIP();
    final wifiGateway = await info.getWifiGatewayIP();
    _networkName.value = wifiName;
    _networkIP.value = wifiIp ?? "-";
    _networkGateway.value = wifiGateway ?? "-";
    update();
  }
  //#endregion
}
