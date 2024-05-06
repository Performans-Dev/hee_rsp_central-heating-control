import 'dart:async';

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/models/language_definition.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:central_heating_control/app/data/providers/app_provider.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  //#region SUPER
  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
    checkFlags();
  }

  @override
  void onReady() {
    populateUserList();
    fetchSettings();
    logoutUser();
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

  void checkFlags() async {
    _didLanguageSelected.value = Box.getBool(key: Keys.didLanguageSelected);
    _didTimezoneSelected.value = Box.getBool(key: Keys.didTimezoneSelected);
    _didActivated.value = Box.getBool(key: Keys.didActivated);
    _hasAdminUser.value = (await DbProvider.db.getAdminUsers()).isNotEmpty;
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
          case ConnectivityResult.ethernet:
          case ConnectivityResult.vpn:
          case ConnectivityResult.mobile:
          case ConnectivityResult.bluetooth:
            connected = true;
            break;
          default:
            connected = false;
            break;
        }
      }
    }
    _didConnected.value = connected;
    update();
  }
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
    await populateLanguages();
    await populateTimezones();
    _didSettingsFetched.value = true;
    update();
    Get.offAllNamed(Routes.home);
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
    //TODO: remove this comment
    // await Box.setBool(key: Keys.didLanguageSelected, value: true);
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
    update();
  }

  Future<void> onTimezoneSelected(int index) async {
    final selectedTimezone = timezones[index];
    // TODO: remove this comment
    // await Box.setString(
    //   key: Keys.selectedTimezone,
    //   value: selectedTimezone.toJson(),
    // );
    _didTimezoneSelected.value = true;
    update();

    //TODO: inform OS to selected timezone
  }
  //#endregion
}
