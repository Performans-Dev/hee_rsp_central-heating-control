import 'dart:async';
import 'dart:io';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/device.dart';
import 'package:central_heating_control/app/data/models/account.dart';
import 'package:central_heating_control/app/data/models/activation_result.dart';
import 'package:central_heating_control/app/data/models/app_settings.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/models/chc_device.dart';
import 'package:central_heating_control/app/data/models/forgot_password_request.dart';
import 'package:central_heating_control/app/data/models/generic_response.dart';
import 'package:central_heating_control/app/data/models/language_definition.dart';
import 'package:central_heating_control/app/data/models/log.dart';
import 'package:central_heating_control/app/data/models/register_request.dart';
import 'package:central_heating_control/app/data/models/signin_request.dart';
import 'package:central_heating_control/app/data/models/subscription_result.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:central_heating_control/app/data/providers/app_provider.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/providers/log.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:network_info_plus/network_info_plus.dart';

class AppController extends GetxController {
  //#region MARK: Super
  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
    fetchLanguages();
    fetchTimezones();
    fetchDateTimeFormats();
    fetchThemes();
    checkFlags();
    final t = Box.getString(key: Keys.selectedTheme);
    _selectedTheme.value = t.isEmpty ? StaticProvider.getThemeList.first : t;
    _idleTimeout.value =
        Box.getInt(key: Keys.idleTimerInSeconds, defaultVal: 60);
    _slideShowTime.value = Box.getInt(key: Keys.slideShowTimer, defaultVal: 10);
    update();
  }

  @override
  void onReady() {
    loadAppUserList();
    super.onReady();
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

  final RxBool _didSettingsFetched = false.obs;
  bool get didSettingsFetched => _didSettingsFetched.value;

  final RxBool _didLanguageSelected = false.obs;
  bool get didLanguageSelected => _didLanguageSelected.value;

  final RxBool _didTimezoneSelected = false.obs;
  bool get didTimezoneSelected => _didTimezoneSelected.value;

  final RxBool _didDateFormatSelected = false.obs;
  bool get didDateFormatSelected => _didDateFormatSelected.value;

  final RxBool _didThemeSelected = false.obs;
  bool get didThemeSelected => _didThemeSelected.value;

  final RxBool _didDeviceInfoCreated = false.obs;
  bool get didDeviceInfoCreated => _didDeviceInfoCreated.value;

  final RxBool _didDeviceRegistered = false.obs;
  bool get didDeviceRegistered => _didDeviceRegistered.value;

  final RxBool _didSignedIn = false.obs;
  bool get didSignedIn => _didSignedIn.value;

  final RxBool _didActivated = false.obs;
  bool get didActivated => _didActivated.value;

  final RxBool _didSubscriptionResultReceived = false.obs;
  bool get didSubscriptionResultReceived =>
      _didSubscriptionResultReceived.value;

  final RxBool _didAppUsersLoaded = false.obs;
  bool get didAppUsersLoaded => _didAppUsersLoaded.value;

  bool get hasAdminUser =>
      appUserList.where((e) => e.level == AppUserLevel.admin).isNotEmpty;

  bool setupCompleted() {
    final SetupController setupController = Get.find();
    final list = setupController.setupSequenceList;
    return list.where((e) => !e.isCompleted).isEmpty;
  }

  void checkFlags() {
    _didLanguageSelected.value = Box.getBool(key: Keys.didLanguageSelected);
    _didTimezoneSelected.value = Box.getBool(key: Keys.didTimezoneSelected);
    _didDateFormatSelected.value = Box.getBool(key: Keys.didDateFormatSelected);
    _didThemeSelected.value = Box.getBool(key: Keys.didThemeSelected);
    _didDeviceInfoCreated.value = deviceInfo != null;
    _didDeviceRegistered.value = Box.getString(key: Keys.deviceId).isNotEmpty;
    _didSignedIn.value = Box.account != null && Box.account!.id.isNotEmpty;
    _didActivated.value = Box.getString(key: Keys.activationId).isNotEmpty;
    _didSubscriptionResultReceived.value = Box.accountSubscription != null &&
        Box.accountSubscription!.id.isNotEmpty;
    update();
  }

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
  //#endregion

  //#region MARK: Session
  final RxString _sessionKey = ''.obs;
  String get sessionKey => _sessionKey.value;

  void startSession() {
    _sessionKey.value = Guid.newGuid.toString();
    update();
  }
  //#endregion

  //#region MARK: Users
  final RxList<AppUser> _appUserList = <AppUser>[].obs;
  List<AppUser> get appUserList => _appUserList;

  Future<void> loadAppUserList() async {
    final users = await DbProvider.db.getUsers();
    _appUserList.assignAll(users);
    _didAppUsersLoaded.value = true;
    final isDeveloperUserExists = _appUserList.any((user) =>
        user.username.toLowerCase() == 'developer' &&
        user.level == AppUserLevel.developer);
    if (_appUserList.isEmpty || !isDeveloperUserExists) {
      await DbProvider.db.addUser(AppUser(
        id: -1,
        username: 'Developer',
        pin: '111111',
        level: AppUserLevel.developer,
      ));
      final updatedUsers = await DbProvider.db.getUsers();
      _appUserList.assignAll(updatedUsers);
    }

    update();
  }

  final Rxn<AppUser> _loggedInAppUser = Rxn();
  AppUser? get loggedInAppUser => _loggedInAppUser.value;

  void setLoggedInAppUser(AppUser? user) {
    _loggedInAppUser.value = user;
    update();
  }

  Future<bool> loginUser({
    required String username,
    required String pin,
  }) async {
    final user = appUserList
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

  void logoutUser() {
    _loggedInAppUser.value = null;
    update();
  }

  Future<bool> updateUser({required AppUser user}) async {
    final result = await DbProvider.db.updateUser(user);
    await loadAppUserList();
    return result > 0;
  }

  Future<bool> deleteUser({required AppUser user}) async {
    final result = await DbProvider.db.deleteUser(user);
    await loadAppUserList();
    return result > 0;
  }

  Future<GenericResponse> addUser({required AppUser user}) async {
    final result = await DbProvider.db.addUser(user);
    await loadAppUserList();
    switch (result) {
      case -3:
        return GenericResponse.error(message: 'Username already exists'.tr);
      case -2:
        return GenericResponse.error(message: 'Couldnot read database'.tr);
      case -1:
        return GenericResponse.error(message: 'Database exception'.tr);
      case 0:
        return GenericResponse.error(message: 'Unknown error'.tr);
      default:
        return GenericResponse.success(user);
    }
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
  //#endregion

  //#region MARK: Device Info

  final Rxn<ChcDevice> _deviceInfo = Rxn();
  ChcDevice? get deviceInfo => _deviceInfo.value;

  Future<void> readDevice() async {
    ChcDevice device = await DeviceUtils.createDeviceInfo();
    _deviceInfo.value = device;
    _didDeviceInfoCreated.value = true;
    update();
  }
  //#endregion

  //#region MARK: AppSettings
  final Rxn<AppSettings> _appSettings = Rxn();
  AppSettings? get appSettings => _appSettings.value;

  Future<void> fetchAppSettings() async {
    final data = Box.getString(key: Keys.appSettings);
    if (didConnected && data.isEmpty) {
      final result = await AppProvider.fetchAppSettings();
      if (result.success && result.data != null) {
        await Box.setString(
            key: Keys.appSettings, value: result.data!.toJson());
        _appSettings.value = result.data;
      }
      _didSettingsFetched.value = true;
      update();
    } else {
      if (data.isEmpty) return;
      _appSettings.value = AppSettings.fromJson(data);
      update();
    }
  }
  //#endregion

  //#region MARK: Languages
  final RxList<LanguageDefinition> _languages = <LanguageDefinition>[].obs;
  List<LanguageDefinition> get languages => _languages;

  void fetchLanguages() {
    final list = <LanguageDefinition>[];
    const data = StaticProvider.getLanguageList;
    for (final map in data) {
      list.add(LanguageDefinition.fromMap(map));
    }
    _languages.assignAll(list);
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

  //#region MARK: Timezones
  final RxList<TimezoneDefinition> _timezones = <TimezoneDefinition>[].obs;
  List<TimezoneDefinition> get timezones => _timezones;

  void fetchTimezones() {
    final list = <TimezoneDefinition>[];
    const data = StaticProvider.getTimezoneList;
    for (final map in data) {
      list.add(TimezoneDefinition.fromMap(map));
    }
    _timezones.assignAll(list);
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

  //#region MARK: DateTime Formats
  final RxList<String> _dateFormats = <String>[].obs;
  List<String> get dateFormats => _dateFormats;

  final RxList<String> _timeFormats = <String>[].obs;
  List<String> get timeFormats => _timeFormats;

  void fetchDateTimeFormats() {
    _dateFormats.assignAll(StaticProvider.getDateFormatList);
    _timeFormats.assignAll(StaticProvider.getTimeFormatList);
    update();
  }
  //#endregion

  //#region MARK: Themes
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;
  ThemeMode get themeMode => _themeMode.value;

  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  Future<void> nextThemeMode() async {
    int index = ThemeMode.values.indexOf(themeMode);
    final nextTheme = ThemeMode.values[(index + 1) % ThemeMode.values.length];
    await setThemeMode(nextTheme);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await Box.setInt(key: Keys.themeMode, value: mode.index);
    Get.changeThemeMode(mode);
    _themeMode.value = mode;
    _isDarkMode.value = Get.isDarkMode;
    update();
    _isDarkMode.value = Get.isDarkMode;
    update();
  }

  final RxList<String> _themes = <String>[].obs;
  List<String> get themes => _themes;

  final Rx<String> _selectedTheme = ''.obs;
  String get selectedTheme => _selectedTheme.value;

  void fetchThemes() {
    _themes.assignAll(StaticProvider.getThemeList);
    update();
  }

  Future<void> setSelectedTheme(String value) async {
    _selectedTheme.value = value;
    _didThemeSelected.value = true;
    update();
    await Box.setString(key: Keys.selectedTheme, value: value);
  }

  //#endregion

  //#region MARK: Account
  final Rxn<String> _token = Rxn();
  String? get token => _token.value;
  void deleteToken() {
    _token.value = null;
    update();
  }

  Future<GenericResponse<String?>> registerDevice(ChcDevice device) async {
    final response = await AppProvider.registerChcDevice(request: device);
    String deviceId = response.data?.id ?? '';
    await Box.setString(key: Keys.deviceId, value: deviceId);
    _deviceInfo.value?.id = deviceId;
    _didDeviceRegistered.value = true;
    update();
    await Box.setBool(key: Keys.didRegisteredDevice, value: true);
    return GenericResponse(
      success: response.success,
      statusCode: response.statusCode,
      message: response.message,
      data: response.data?.id,
    );
  }

  Future<GenericResponse<Account?>> accountSignin({
    required String email,
    required String password,
  }) async {
    final response = await AppProvider.accountSignin(
      request: SigninRequest(
        email: email,
        password: password,
      ),
    );
    if (response.success && response.data != null) {
      Account account = response.data!;
      await Box.setString(key: Keys.account, value: account.toJson());
      _didSignedIn.value = true;
    } else {
      _didSignedIn.value = false;
    }
    update();
    return response;
  }

  Future<GenericResponse> accountForgotPassword({required String email}) async {
    final response = await AppProvider.accountForgotPassword(
      request: ForgotPasswordRequest(
        email: email,
      ),
    );
    return response;
  }

  Future<GenericResponse> accountRegister({
    required String email,
    required String fullName,
    required String password,
  }) async {
    final response = await AppProvider.accountRegister(
      request: RegisterRequest(
        email: email,
        fullName: fullName,
        password: password,
      ),
    );
    if (response.success && response.data != null) {
      Account account = response.data!;
      await Box.setString(key: Keys.account, value: account.toJson());
      _didSignedIn.value = true;
    } else {
      _didSignedIn.value = false;
    }
    update();
    return response;
  }

  Future<GenericResponse<ActivationResult?>> performActivation({
    required String deviceId,
    required String accountId,
  }) async {
    // final response = await AppProvider.activateDevice(
    //   request: ActivationRequest(
    //     userId: accountId,
    //     chcDeviceId: deviceId,
    //   ),
    // );
    await Future.delayed(const Duration(seconds: 3));

    // if (response.success && response.data != null) {
    // ActivationResult activationResult = response.data!;
    ActivationResult activationResult = ActivationResult(
      id: Guid.newGuid.toString(),
      createdAt: DateTime.now().toIso8601String(),
      chcDeviceId: deviceId,
      userId: accountId,
      status: 1,
      activationTime: DateTime.now().toIso8601String(),
    );
    await Box.setString(
        key: Keys.activationResult, value: activationResult.toJson());
    await Box.setBool(key: Keys.didActivated, value: true);
    _didActivated.value = true;
    // } else {
    //   await Box.setBool(key: Keys.didActivated, value: false);
    //   _didActivated.value = false;
    // }
    update();
    return GenericResponse.success(activationResult);
  }

  Future<GenericResponse<SubscriptionResult?>> requestSubscription({
    required String activationId,
  }) async {
    final response =
        await AppProvider.requestSubscription(activationId: activationId);
    if (response.success && response.data != null) {
      SubscriptionResult subscriptionResult = response.data!;
      await Box.setString(
          key: Keys.subscriptionResult, value: subscriptionResult.toJson());
      _didSubscriptionResultReceived.value = true;
    } else {
      _didSubscriptionResultReceived.value = false;
    }
    update();
    return response;
  }

  //#endregion

  //#region MARK: Pin Reset
  final Rxn<Account> _pinResetAccount = Rxn();
  Account? get pinResetAccount => _pinResetAccount.value;
  //#endregion

  //#region MARK: Terms-Privacy

  //#endregion

  //#region MARK: Idle Timeout / Screen Saver
  final Rx<int> _idleTimeout = 500.obs;
  int get idleTimeout => _idleTimeout.value;

  final Rx<int> _slideShowTime = 10.obs;
  int get slideShowTime => _slideShowTime.value;

  void setIdleTime(value) {
    _idleTimeout.value = value;
    update();
  }

  void setSlideTime(value) {
    _slideShowTime.value = value;
    update();
  }
  //#endregion
}
