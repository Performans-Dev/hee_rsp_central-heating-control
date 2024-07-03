import 'dart:async';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
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
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';

class AppController extends GetxController {
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
    // populateUserList();
    fetchSettings();
    // logoutUser();
    // readDevice();
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
  final RxBool _didSettingsFetched = false.obs;
  bool get didSettingsFetched => _didSettingsFetched.value;

  final RxBool _didLanguageSelected = false.obs;
  bool get didLanguageSelected => _didLanguageSelected.value;

  final RxBool _didTimezoneSelected = false.obs;
  bool get didTimezoneSelected => _didTimezoneSelected.value;

  final RxBool _didActivated = false.obs;
  bool get didActivated => _didActivated.value;

  final RxBool _didConnected = false.obs;
  bool get didConnected => _didConnected.value;

  final RxBool _hasAdminUser = false.obs;
  bool get hasAdminUser => _hasAdminUser.value;

  Future<void> checkFlags() async {
    _didLanguageSelected.value = Box.getBool(key: Keys.didLanguageSelected);
    _didTimezoneSelected.value = Box.getBool(key: Keys.didTimezoneSelected);
    _didActivated.value = Box.getBool(key: Keys.didActivated);
    _hasAdminUser.value = (await DbProvider.db.getAdminUsers()).isNotEmpty;
    update();
  }

  Future<void> resetFlags() async {
    _didLanguageSelected.value = false;
    _didTimezoneSelected.value = false;
    _didActivated.value = false;
    _hasAdminUser.value = false;
    _didSettingsFetched.value = false;
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
    final response = await AppProvider.userSignin(
      request: SigninRequest(
        email: email,
        password: password,
      ),
    );
    _account.value = response.data;
    update();
    await Box.setString(key: Keys.accountId, value: account?.id ?? '');
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

  Future<void> createAdmin() async {
    var result = await DbProvider.db.addUser(
        AppUser(id: -1, username: 'Admin', pin: '000000', isAdmin: true));
    GpioController gpio = GpioController();
    if (result < -1) {
      gpio.buzz(BuzzerType.alarm);
    } else if (result == -1) {
      gpio.buzz(BuzzerType.error);
    } else if (result == 0) {
      gpio.buzz(BuzzerType.success);
    } else {
      gpio.buzz(BuzzerType.feedback);
    }
  }
}
