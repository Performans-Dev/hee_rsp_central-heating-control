// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/platform_utils.dart';
import 'package:central_heating_control/app/data/models/app_user/app_user.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/data/models/group/group.dart';
import 'package:central_heating_control/app/data/models/input_outputs/analog_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_output.dart';
import 'package:central_heating_control/app/data/models/input_outputs/hw_button.dart';
import 'package:central_heating_control/app/data/models/platform/platform_info.dart';
import 'package:central_heating_control/app/data/models/preferences/icon.dart';
import 'package:central_heating_control/app/data/models/preferences/preferences.dart';
import 'package:central_heating_control/app/data/providers/api_provider.dart';
import 'package:central_heating_control/app/data/providers/db_provider.dart';
import 'package:central_heating_control/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';

class AppController extends GetxController {
  //#region MARK: Def
  int kMainBoardId = 0x00;
  int startByte = 0x3A;
  List<int> stopBytes = [0x0D, 0x0A];
  String serialKey = '/dev/ttyS0';
  int kSerialAcknowledgementDelay = 700;
  int kSerialLoopDelay = 100;

  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;
  final Connectivity _connecivity = Connectivity();
  //#endregion

  //#region MARK: Super
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

    loadData();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> loadData() async {
    await _loadInputOutputs();
    await _loadAppUsers();
    await _loadGroups();
    await _loadDevices();
    Future.delayed(const Duration(seconds: 3), () {
      loadIcons();
    });
    initGpioPins();
    Future.delayed(const Duration(seconds: 4), () => pollGpio());
  }
  //#endregion

  //#region MARK: Flags
  final RxBool _didReadPlatformInfoCompleted = false.obs;
  bool get didReadPlatformInfoCompleted => _didReadPlatformInfoCompleted.value;

  //#endregion

  //#region MARK: Preferences
  final _preferences = Preferences.empty().obs;
  Preferences get preferences => _preferences.value;
  void setPreferences(Preferences p) {
    _preferences.value = p;
    update();
    savePreferencesToBox();
  }

  Future<void> savePreferencesToBox() async {
    await Box.setString(
      key: Keys.preferences,
      value: _preferences.value.toJson(),
    );
  }

  void loadPreferencesFromBox() {
    try {
      final json = Box.getString(key: Keys.preferences);
      if (json.isNotEmpty) {
        _preferences.value = Preferences.fromJson(json);
        update();
      } else {
        // If no preferences found, use default values
        _preferences.value = Preferences.empty();
        update();
      }
    } catch (e) {
      print('Error loading preferences from box: $e');
      // Fallback to default preferences
      _preferences.value = Preferences.empty();
      update();
    }
  }
  //#endregion

  //#region MARK: Icons
  final RxList<IconDefinition> _iconList = <IconDefinition>[].obs;
  List<IconDefinition> get iconList => _iconList;

  Future<void> loadIcons() async {
    final icons = await ApiProvider.fetchIconIndex();
    _iconList.assignAll(icons);
    update();
    debugPrint('Icons loaded: ${_iconList.length}');
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

  //#region MARK: PlatformInfo
  final Rxn<PlatformInfo> _platformInfo = Rxn();
  PlatformInfo? get platformInfo => _platformInfo.value;

  Future<void> getPlatformInfo() async {
    PlatformInfo platformInfo = await PlatformUtils.getPlatformInfo();
    _platformInfo.value = platformInfo;
    _didReadPlatformInfoCompleted.value = true;
    update();
  }
  //#endregion

  //#region MARK: AppUsers

  final RxList<AppUser> _appUsers = <AppUser>[].obs;
  List<AppUser> get appUsers => _appUsers;

  Future<void> _loadAppUsers() async {
    final data = await DbProvider.db.getAppUsers();
    _appUsers.assignAll(data);
    update();
  }

  Future<void> saveAppUser(AppUser appUser) async {
    final response = await DbProvider.db.saveAppUser(appUser);
    if (response > 0) {
      _loadAppUsers();
    }
  }

  Future<void> insertUser(AppUser appUser) async {
    final response = await DbProvider.db.insertUser(appUser);
    if (response > 0) {
      _loadAppUsers();
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await DbProvider.db.deleteUser(id);
    if (response > 0) {
      _loadAppUsers();
    }
  }
  //#endregion

  //#region MARK: InputOutput

  final RxList<AnalogInput> _analogInputs = <AnalogInput>[].obs;
  List<AnalogInput> get analogInputs => _analogInputs;
  final RxList<DigitalInput> _digitalInputs = <DigitalInput>[].obs;
  List<DigitalInput> get digitalInputs => _digitalInputs;
  final RxList<DigitalOutput> _digitalOutputs = <DigitalOutput>[].obs;
  List<DigitalOutput> get digitalOutputs => _digitalOutputs;
  final RxList<HwButton> _hwButtons = <HwButton>[].obs;
  List<HwButton> get hwButtons => _hwButtons;

  Future<void> _loadInputOutputs() async {
    final analogInputs = await DbProvider.db.getAnalogInputs();
    final digitalInputs = await DbProvider.db.getDigitalInputs();
    final digitalOutputs = await DbProvider.db.getDigitalOutputs();

    _analogInputs.assignAll(analogInputs);
    _digitalInputs.assignAll(digitalInputs);
    _digitalOutputs.assignAll(digitalOutputs);

    _hwButtons.assignAll(List.generate(
        4, (e) => HwButton(deviceId: 0x00, index: e, value: false)));
    update();
  }

  Future<void> saveAnalogInput(AnalogInput analogInput) async {
    final response = await DbProvider.db.saveAnalogInput(analogInput);
    if (response > 0) {
      _loadInputOutputs();
    }
  }

  Future<void> saveDigitalInput(DigitalInput digitalInput) async {
    final response = await DbProvider.db.saveDigitalInput(digitalInput);
    if (response > 0) {
      _loadInputOutputs();
    }
  }

  Future<void> saveDigitalOutput(DigitalOutput digitalOutput) async {
    final response = await DbProvider.db.saveDigitalOutput(digitalOutput);
    if (response > 0) {
      _loadInputOutputs();
    }
  }
  //#endregion

  //#region MARK: GPIO
  late GPIO uartModeTx;
  late GPIO btn1;
  late GPIO btn2;
  late GPIO btn3;
  late GPIO btn4;
  late GPIO outPinSER;
  late GPIO outPinSRCLK;
  late GPIO outPinRCLK;
  late GPIO buzzer;
  late GPIO fanPin;
  late GPIO in1;
  late GPIO in2;
  late GPIO in3;
  late GPIO in4;
  late GPIO in5;
  late GPIO in6;
  late GPIO in7;
  late GPIO in8;
  late GPIO txEnablePin;

  final RxBool _pinSerState = false.obs;
  final RxBool _pinSrclkState = false.obs;
  final RxBool _pinRclkState = false.obs;
  final RxBool _pinBuzzerState = false.obs;
  final RxBool _pinTxEnableState = false.obs;
  final RxBool _fanPinState = false.obs;
  final RxBool _pinUartModeTxState = false.obs;

  bool get pinSerState => _pinSerState.value;
  bool get pinSrclkState => _pinSrclkState.value;
  bool get pinRclkState => _pinRclkState.value;
  bool get pinBuzzerState => _pinBuzzerState.value;
  bool get pinTxEnableState => _pinTxEnableState.value;
  bool get fanPinState => _fanPinState.value;
  bool get pinUartModeTxState => _pinUartModeTxState.value;

  void initGpioPins() {
    try {
      if (!isPi) {
        return;
      }

      uartModeTx = GPIO(4, GPIOdirection.gpioDirOut);
      btn1 = GPIO(17, GPIOdirection.gpioDirIn);
      btn2 = GPIO(18, GPIOdirection.gpioDirIn);
      btn3 = GPIO(27, GPIOdirection.gpioDirIn);
      btn4 = GPIO(22, GPIOdirection.gpioDirIn);
      outPinSER = GPIO(23, GPIOdirection.gpioDirOut);
      outPinSRCLK = GPIO(24, GPIOdirection.gpioDirOut);
      outPinRCLK = GPIO(25, GPIOdirection.gpioDirOut);
      buzzer = GPIO(0, GPIOdirection.gpioDirOut);
      in1 = GPIO(5, GPIOdirection.gpioDirIn);
      in2 = GPIO(6, GPIOdirection.gpioDirIn);
      in3 = GPIO(12, GPIOdirection.gpioDirIn);
      in4 = GPIO(13, GPIOdirection.gpioDirIn);
      in5 = GPIO(19, GPIOdirection.gpioDirIn);
      in6 = GPIO(16, GPIOdirection.gpioDirIn);
      in7 = GPIO(26, GPIOdirection.gpioDirIn);
      in8 = GPIO(20, GPIOdirection.gpioDirIn);
      txEnablePin = GPIO(21, GPIOdirection.gpioDirOut);
      txEnablePin.write(true);
      print("GPIO pins initialized");
    } catch (e) {
      print('Error initializing GPIO pins: $e');
    }
  }
  //#endregion

  //#region MARK: Gpio Polling
  void pollGpio() async {
    if (!isPi) return;
    // TODO: check if any package is waiting, if so, send it with await

    // read inputs with for loop
    try {
      _digitalInputs
          .firstWhere((e) => e.hwId == 0x00 && e.pinIndex == 1)
          .value = in1.read();
      _digitalInputs
          .firstWhere((e) => e.hwId == 0x00 && e.pinIndex == 2)
          .value = in2.read();
      _digitalInputs
          .firstWhere((e) => e.hwId == 0x00 && e.pinIndex == 3)
          .value = in3.read();
      _digitalInputs
          .firstWhere((e) => e.hwId == 0x00 && e.pinIndex == 4)
          .value = in4.read();
      _digitalInputs
          .firstWhere((e) => e.hwId == 0x00 && e.pinIndex == 5)
          .value = in5.read();
      _digitalInputs
          .firstWhere((e) => e.hwId == 0x00 && e.pinIndex == 6)
          .value = in6.read();
      _digitalInputs
          .firstWhere((e) => e.hwId == 0x00 && e.pinIndex == 7)
          .value = in7.read();
      _digitalInputs
          .firstWhere((e) => e.hwId == 0x00 && e.pinIndex == 8)
          .value = in8.read();
      // read buttons with for loop
      _hwButtons[0].value = !btn1.read();
      _hwButtons[1].value = !btn2.read();
      _hwButtons[2].value = !btn3.read();
      _hwButtons[3].value = !btn4.read();

      // update variables with respective states
      update();
    } on Exception catch (e) {
      print(e.toString());
    }

    Future.delayed(const Duration(milliseconds: 100), () => pollGpio());
  }
  //#endregion

  //#region MARK: Group
  final RxList<GroupDefinition> _groups = <GroupDefinition>[].obs;
  List<GroupDefinition> get groups => _groups;

  void setGroup(GroupDefinition g) {
    final index = groups.indexWhere((e) => e.id == g.id);

    if (index == -1) {
      return;
    }
    _groups[index] = g;
    update();

    for (final g in groups) {
      print('A Group: ${g.toJson()}');
    }
  }

  Future<void> _loadGroups() async {
    final result = await DbProvider.db.getGroupList();
    _groups.assignAll(result);
    update();
  }

  Future<void> saveGroup(GroupDefinition g) async {
    final response = await DbProvider.db.saveGroup(g);
    if (response > 0) {
      _loadGroups();
    }
  }

  Future<void> insertGroup(GroupDefinition g) async {
    final response = await DbProvider.db.insertGroup(g);
    if (response > 0) {
      _loadGroups();
    }
  }

  Future<void> deleteGroup(int id) async {
    final response = await DbProvider.db.deleteGroup(id);
    // update all devices group id to null
    final devices = await DbProvider.db.getDevices();
    for (final device in devices) {
      if (device.groupId == id) {
        await DbProvider.db.updateDevice(device.copyWith(groupId: null));
      }
    }
    if (response > 0) {
      _loadGroups();
      _loadDevices();
    }
  }
  //#endregion

  //#region MARK: Devices
  final RxList<Device> _devices = <Device>[].obs;
  List<Device> get devices => _devices;

  Future<void> _loadDevices() async {
    final result = await DbProvider.db.getDevices();
    List<Device> deviceList = [];
    for (final device in result) {
      deviceList.add(device.copyWith(
        groupName: device.groupId == null
            ? '-'
            : groups.firstWhereOrNull((e) => e.id == device.groupId)?.name,
      ));
    }
    _devices.assignAll(deviceList);
    update();
  }

  Future<void> saveDevice(Device device) async {
    final response = await DbProvider.db.updateDevice(device);
    if (response > 0) {
      _loadDevices();
    }
  }

  Future<void> insertDevice(Device device) async {
    final response = await DbProvider.db.insertDevice(device);
    if (response > 0) {
      _loadDevices();
    }
  }

  Future<void> deleteDevice(int id) async {
    final response = await DbProvider.db.deleteDevice(id);
    if (response > 0) {
      _loadDevices();
    }
  }
  //#endregion
}
