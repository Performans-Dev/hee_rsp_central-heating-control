/* import 'dart:async';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/core/utils/device.dart';
import 'package:central_heating_control/app/data/models/account.dart';
import 'package:central_heating_control/app/data/models/activation_request.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/models/chc_device.dart';
import 'package:central_heating_control/app/data/models/language_definition.dart';
import 'package:central_heating_control/app/data/models/signin_request.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:central_heating_control/app/data/providers/app_provider.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/gpio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';

class OldAppController extends GetxController {
  //#region SUPER
  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
    checkFlags();
    _selectedTheme.value = Box.getString(key: Keys.selectedTheme);
    update();
  }

  @override
  void onReady() {
    populateUserList();
    // fetchSettings();
    logoutUser();
    readDevice();
    checkAdminUser();
    super.onReady();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
  //#endregion

  //#region SESSION
  final RxString _sessionKey = ''.obs;
  String get sessionKey => _sessionKey.value;

  void startSession() {
    _sessionKey.value = Guid.newGuid.toString();
    update();
  }
  //#endregion

  //#region FLAGS
  final RxBool _connectivityResultReceived = false.obs;
  bool get connectivityResultReceived => _connectivityResultReceived.value;

  final RxBool _didSettingsFetched = false.obs;
  bool get didSettingsFetched => _didSettingsFetched.value;

  final RxBool _didLanguageSelected = false.obs;
  bool get didLanguageSelected => _didLanguageSelected.value;

  final RxBool _didTimezoneSelected = false.obs;
  bool get didTimezoneSelected => _didTimezoneSelected.value;

  final RxBool _didDateFormatSelected = false.obs;
  bool get didDateFormatSelected => _didDateFormatSelected.value;

  final RxBool _didActivated = false.obs;
  bool get didActivated => _didActivated.value;

  final RxBool _didConnected = false.obs;
  bool get didConnected => _didConnected.value;

  final RxBool _hasAdminUser = false.obs;
  bool get hasAdminUser => _hasAdminUser.value;

  final RxBool _didPickedTheme = false.obs;
  bool get didPickedTheme => _didPickedTheme.value;

  final Rxn<String> _token = Rxn();
  String? get token => _token.value;
  void deleteToken() {
    _token.value = null;
    update();
  }

  Future<void> checkFlags() async {
    _didLanguageSelected.value = Box.getBool(key: Keys.didLanguageSelected);
    _didTimezoneSelected.value = Box.getBool(key: Keys.didTimezoneSelected);
    _didDateFormatSelected.value = Box.getBool(key: Keys.didDateFormatSelected);
    _didPickedTheme.value = Box.getBool(key: Keys.didThemeSelected);
    _didActivated.value = Box.getBool(key: Keys.didActivated);
    _hasAdminUser.value = (await DbProvider.db.getAdminUsers()).isNotEmpty;
    update();
  }

  Future<void> resetFlags() async {
    _didLanguageSelected.value = false;
    _didTimezoneSelected.value = false;
    _didDateFormatSelected.value = false;
    _didActivated.value = false;
    _hasAdminUser.value = false;
    _didPickedTheme.value = false;
    _didSettingsFetched.value = false;
    update();
  }

  Future<void> checkAdminUser() async {
    final users = await DbProvider.db.getAdminUsers();
    for (var user in users) {
      print(" ${user.username}, ${user.level},  ${user.pin}");
    }
    if (users.isEmpty) {
      print("user yok");
    }
    _hasAdminUser.value = (users).isNotEmpty;
    update();
  }

  //#endregion

  //#region CONECTIVITY
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;
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
    _connectivityResultReceived.value = true;
    update();
    getNetworkInfo();
  }

  final Rx<NetworkIndicator> _networkIndicator = NetworkIndicator.none.obs;
  NetworkIndicator get networkIndicator => _networkIndicator.value;
  //#endregion

  //#region NETWORK
  Future<void> getNetworkInfo() async {
    final info = NetworkInfo();
    final wifiName = await info.getWifiName();
    final wifiIp = await info.getWifiIP();
    final wifiGateway = await info.getWifiGatewayIP();
    _networkName.value = wifiName;
    _networkIP.value = wifiIp;
    _networkGateway.value = wifiGateway;
    update();
  }

  final Rxn<String> _networkName = Rxn();
  final Rxn<String> _networkIP = Rxn();
  final Rxn<String> _networkGateway = Rxn();
  String? get networkName => _networkName.value;
  String? get networkIp => _networkIP.value;
  String? get networkGateway => _networkGateway.value;

  //#endregion

  //#region USER
  final Rxn<AppUser> _appUser = Rxn();
  AppUser? get appUser => _appUser.value;

  final RxList<AppUser> _userList = <AppUser>[].obs;
  List<AppUser> get userList => _userList;

  Future<void> populateUserList() async {
    final users = await DbProvider.db.getUsers();
    _userList.assignAll(users);
    if (users.isEmpty) {
/*       final defaultUser = AppUser(
        username: 'Admin User',
        id: -1,
        isAdmin: true,
        pin: '000000',
      ); */
      //await DbProvider.db.addUser(defaultUser);
      await populateUserList();
    }
    update();
  }

  Future<bool> loginUser({
    required String username,
    required String pin,
  }) async {
    final user = await DbProvider.db.getUser(username: username, pin: pin);
    _appUser.value = user;
    update();
    return appUser != null;
  }

  Future<void> logoutUser() async {
    _appUser.value = null;
    update();
  }

  //#endregion

  //#region SETTINGS
  Future<void> fetchSettings() async {
    _didSettingsFetched.value = true;
    update();
    await populateLanguages();
    await populateTimezones();
    // NavController.toHome();
  }
  //#endregion

  //#region LANGUAGES
  final RxList<LanguageDefinition> _languages = <LanguageDefinition>[].obs;
  List<LanguageDefinition> get languages => _languages;
  Future<void> populateLanguages() async {
    final response = await AppProvider.fetchLanguageList();
    final List<LanguageDefinition> data =
        response.data as List<LanguageDefinition>;
    _languages.assignAll(data);
    update();
  }

  Future<void> onLanguageSelected(int index) async {
    final selectedLang = languages[index];

    await Box.setBool(key: Keys.didLanguageSelected, value: true);
    await LocalizationService().changeLocale(selectedLang.languageCode);
    _didLanguageSelected.value = true;
    update();
  }
  //#endregion

  //#region TIMEZONES
  final RxList<TimezoneDefinition> _timezones = <TimezoneDefinition>[].obs;
  List<TimezoneDefinition> get timezones => _timezones;

  Future<void> populateTimezones() async {
    final response = await AppProvider.fetchTimezoneList();
    final data = response.data as List<TimezoneDefinition>;
    _timezones.assignAll(data);
    final set = _timezones.toSet();
    _timezones.assignAll(set.toList());
    update();
  }

  Future<void> onTimezoneSelected(int index) async {
    final selectedTimezone = timezones[index];
    await Box.setString(
      key: Keys.selectedTimezone,
      value: selectedTimezone.toJson(),
    );
    await Box.setBool(key: Keys.didTimezoneSelected, value: true);
    _didTimezoneSelected.value = true;
    update();

    //TODO: inform OS to selected timezone
  }

  //#endregion

  //#region ACCOUNT
  final Rxn<Account> _account = Rxn();
  Account? get account => _account.value;

  Future<Account?> signin({
    required String email,
    required String password,
  }) async {
    final response = await AppProvider.accountSignin(
      request: SigninRequest(
        email: email,
        password: password,
      ),
    );
    _account.value = response.data;
    if (response.success) {
      _token.value = response.data?.token ?? '';
    }
    update();
    await Box.setString(key: Keys.accountId, value: account?.id ?? '');
    await Box.setBool(key: Keys.didSignedIn, value: response.success);
    return account;
  }
  //#endregion

  //#region CHC-DEVICE
  final Rxn<String> _chcDeviceId = Rxn();
  String? get chcDeviceId => _chcDeviceId.value;

  Future<String?> registerDevice(ChcDevice device) async {
    final response = await AppProvider.registerChcDevice(request: device);
    _chcDeviceId.value = response.data?.id;
    update();
    await Box.setString(key: Keys.deviceId, value: chcDeviceId ?? '');
    await Box.setBool(key: Keys.didRegisteredDevice, value: true);
    return chcDeviceId;
  }

  final Rxn<String> _versionName = Rxn();
  String? get versionName => _versionName.value;

  Future<void> readDevice() async {
    ChcDevice device = await DeviceUtils.createDeviceInfo();
    _versionName.value = device.appVersion;
    update();
  }

  //#endregion
//#region  CHECK-SUBSCRIPTION
  Future<void> checkSubscirption() async {
    final response = await AppProvider.checkSubscription();

    await Box.setBool(key: Keys.didCheckedSubscription, value: true);
    await Box.setInt(
        key: Keys.subscriptionResult, value: response.data?.index ?? 0);
  }
//#endregion

  //#region ACTIVATION
  final Rxn<String> _activationId = Rxn();
  String? get activationId => _activationId.value;

  Future<String?> checkActivation() async {
    final response = await AppProvider.checkActivation(
      request: ActivationRequest(
        userId: account!.id,
        chcDeviceId: chcDeviceId ?? '',
      ),
    );

    _activationId.value = response.data?.id;
    update();

    await Box.setString(key: Keys.activationId, value: activationId ?? '');
    if (activationId != null) {
      _didActivated.value = true;
      update();
      await Box.setBool(key: Keys.didActivated, value: true);
    }

    return activationId;
  }

  Future<String?> activateChcDevice() async {
    final response = await AppProvider.activateDevice(
      request: ActivationRequest(
        userId: account!.id,
        chcDeviceId: chcDeviceId ?? '',
      ),
    );

    _activationId.value = response.data?.id;
    update();

    await Box.setString(key: Keys.activationId, value: activationId ?? '');
    if (activationId != null) {
      _didActivated.value = true;
      update();
      await Box.setBool(key: Keys.didActivated, value: true);
    }

    return activationId;
  }
  //#endregion

  //#region DARK MODE
  final RxBool _isDarkMode = Get.isDarkMode.obs;
  bool get isDarkMode => _isDarkMode.value;

  void toggleDarkMode() async {
    _isDarkMode.value = !isDarkMode;
    update();
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    await Box.setBool(key: Keys.isDarkMode, value: isDarkMode);
  }

  //#endregion

  //#region THEME
  final RxList<String> _themeList = <String>[
    'default',
    'nature',
    'warmy',
    'crimson',
  ].obs;
  List<String> get themeList => _themeList;

  final Rx<String> _selectedTheme = 'nature'.obs;
  String get selectedTheme => _selectedTheme.value;
  void setSelectedTheme(String theme) async {
    _selectedTheme.value = theme;
    update();
    await Box.setString(key: Keys.selectedTheme, value: selectedTheme);
  }
  //#endregion

/*   Future<void> createAdmin() async {
    var result = await DbProvider.db.addUser(
        AppUser(id: -1, username: 'Admin', pin: '000000', isAdmin: true));

    if (result < -1) {
      Buzz.alarm();
    } else if (result == -1) {
      Buzz.error();
    } else if (result == 0) {
      Buzz.success();
    } else {
      Buzz.feedback();
    }
  } */
}
 */