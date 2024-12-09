import 'dart:async';
import 'dart:io';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/device.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/models/chc_device.dart';
import 'package:central_heating_control/app/data/models/heethings_account.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/models/preferences.dart';
import 'package:central_heating_control/app/data/providers/app_provider.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:central_heating_control/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:network_info_plus/network_info_plus.dart';

class AppController extends GetxController {
  //#region Structure Flags
  final RxBool _didCheckFoldersExists = false.obs;
  final RxBool _didCheckedProvisionResults = false.obs;
  final RxBool _didReadDeviceInfoCompleted = false.obs;

  bool get didCheckFoldersExists => _didCheckFoldersExists.value;
  bool get didCheckedProvisionResults => _didCheckedProvisionResults.value;
  bool get didReadDeviceInfoCompleted => _didReadDeviceInfoCompleted.value;

  void setDidCheckFoldersExists(bool value) {
    _didCheckFoldersExists.value = value;
    update();
  }

  void setDidCheckProvisionTestResults(bool value) {
    _didCheckedProvisionResults.value = value;
    update();
  }

  void setReadDeviceInfoCompleted(bool value) {
    _didReadDeviceInfoCompleted.value = value;
    update();
  }
  //#endregion

  //#region Setup Flags
  final RxBool _doesFoldersExists = false.obs;
  bool get doesFoldersExists => _doesFoldersExists.value;
  void setDoesFoldersExists(bool value) {
    _doesFoldersExists.value = value;
    update();
  }

  final RxBool _doesProvisionExists = false.obs;
  bool get doesProvisionExists => _doesProvisionExists.value;
  void setDoesProvisionExists(bool value) {
    _doesProvisionExists.value = value;
    update();
  }

  final _preferencesDefinition = PreferencesDefinition.empty().obs;
  PreferencesDefinition get preferencesDefinition =>
      _preferencesDefinition.value;

  void setPreferencesDefinition(PreferencesDefinition value) {
    _preferencesDefinition.value = value;
    update();
    // TODO: bu value box a yazıcak
  }

  final Rxn<HeethingsAccount> _heethingsAccount = Rxn();
  HeethingsAccount? get heethingsAccount => _heethingsAccount.value;

  void setHeethingsAccount(HeethingsAccount? value) {
    _heethingsAccount.value = value;
    update();
    // TODO: bu value box a yazıcak
  }

  bool get hasAdmin => _userList.any((user) => user.level.name == 'admin');
  bool get hasTechSupport =>
      _userList.any((user) => user.level.name == 'techSupport');

  bool get hasRequiredAppUserRoles => hasAdmin && hasTechSupport;

  final RxBool _shouldUpdateApp = false.obs;
  bool get shouldUpdateApp => _shouldUpdateApp.value;

  bool get isSerialNumberValid {
    final cpuSerial = deviceInfo?.serialNumber;
    final serialOnDisk = Box.getString(key: Keys.serialNumber);

    return cpuSerial != null && cpuSerial == serialOnDisk;
  }

  bool get hasLoggedInUser => loggedInAppUser != null;
  //#endregion

  //#region MARK: Session
  final RxString _sessionKey = ''.obs;
  String get sessionKey => _sessionKey.value;

  void startSession() {
    _sessionKey.value = Guid.newGuid.toString();
    update();
  }
  //#endregion

  //#region MARK: Device Info

  final Rxn<ChcDevice> _deviceInfo = Rxn();
  ChcDevice? get deviceInfo => _deviceInfo.value;

  Future<void> readDevice() async {
    ChcDevice device = await DeviceUtils.createDeviceInfo();
    _deviceInfo.value = device;

    update();
  }

  //#endregion

  //#region MARK: Connectivity
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;

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
    //checkInternetConnection();
    getNetworkInfo();
  }

  Future<void> getMacAddresses() async {
    // Run the 'ip link' command and get the output
    final processResult = await Process.run('ip', ['link']);
    final ipLinkOutput = processResult.stdout as String;

    // Define regular expression pattern to match interface name and MAC address
    final macPattern =
        RegExp(r'^\d+: (\S+): .*\n\s+link/ether ([\da-f:]+)', multiLine: true);

    String? ethMac;
    String? wifiMac;

    // Iterate through all matches
    for (final match in macPattern.allMatches(ipLinkOutput)) {
      final interface = match.group(1);
      final macAddress = match.group(2);

      // Identify Ethernet and Wi-Fi interfaces by their names
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

  Future<void> checkInternetConnection() async {
    final result = await AppProvider.testInternetConnection();
    _didConnected.value = result;
    _didConnectionChecked.value = true;
    update();
  }

  Future<void> getNetworkInfo() async {
    _networkName.value = '';
    _networkIP.value = '';
    _networkGateway.value = '';
    _eth0Mac.value = '';
    _wlan0Mac.value = '';
    update();
    await getMacAddresses();
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

  //#region MARK: Super
  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);

    readDevice();
    startSession();
    loadPreferencesFromBox();
    //TODO:loadaccountfrombox
    //boxdaki account boş ise null olarak güncelle.
  }

  @override
  void onReady() {
    super.onReady();
    loadAppUserList();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  //#endregion

  //#region MARK: Flags

  final RxBool _didConnectivityResultReceived = false.obs;
  bool get didConnectivityResultReceived =>
      _didConnectivityResultReceived.value;

  final RxBool _didConnected = false.obs;
  bool get didConnected => _didConnected.value;

  final RxBool _didConnectionChecked = false.obs;
  bool get didConnectionChecked => _didConnectionChecked.value;

  final RxBool _displayErrorNotification = false.obs;
  bool get displayErrorNotification => _displayErrorNotification.value;

  void setDisplayErrorNotification(bool value) {
    _displayErrorNotification.value = value;
    update();
  }
  //#endregion

  //#region MARK: Preferences

  loadPreferencesFromBox() {
    final prefs = Box.getString(key: Keys.preferences);
    if (prefs.isNotEmpty) {
      _preferencesDefinition.value = PreferencesDefinition.fromJson(prefs);
      update();
    }
  }

//#endregion

  //#region MARK: AppUser
  final Rxn<AppUser> _loggedInAppUser = Rxn();
  AppUser? get loggedInAppUser => _loggedInAppUser.value;

  final List<AppUser> _userList = <AppUser>[].obs;
  List<AppUser> get userList => _userList;

  void setLoggedInAppUser(AppUser? user) {
    _loggedInAppUser.value = user;
    update();
  }

  Future<void> loadAppUserList() async {
    final users = await DbProvider.db.getUsers();
    _userList.assignAll(users);
    update();

    final isDeveloperUserExists = _userList.any((user) =>
        user.username.toLowerCase() == 'developer' &&
        user.level == AppUserLevel.developer);
    if (_userList.isEmpty || !isDeveloperUserExists) {
      await DbProvider.db.addUser(AppUser(
        id: -1,
        username: 'Developer',
        pin: '111111',
        level: AppUserLevel.developer,
      ));
      final updatedUsers = await DbProvider.db.getUsers();
      _userList.assignAll(updatedUsers);
    }

    update();
  }

  void logoutUser() {
    _loggedInAppUser.value = null;
    update();
  }

  Future<bool> loginUser({
    required String username,
    required String pin,
  }) async {
    final user = userList
        .firstWhereOrNull((e) => e.username == username && e.pin == pin);
    _loggedInAppUser.value = user;
    update();
    final result = loggedInAppUser != null;
    if (result) {
      setLoggedInAppUser(user);
      LogService.addLog(LogDefinition(
        message:
            'Unlock Screen ${user != null ? '${user.username}(${user.level.name})' : ''}',
        type: LogType.unlockScreenEvent,
      ));
    }
    return result;
  }
//#endregion

  Future<void> performFactoryReset() async {
    final box = GetStorage();
    await box.erase();
    await DbProvider.db.resetDb();
    logoutUser();
    if (isPi) {
      Process.run('sudo', ['reboot', 'now']);
    } else {
      Process.killPid(pid);
    }
  }


}
