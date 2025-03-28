import 'dart:io';

import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/chc_device.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceUtils {
  static Future<String> cpuSerialNumber() async {
    final serialNumberResult = await Process.run(
        'cat', ['/sys/firmware/devicetree/base/serial-number']);
    return serialNumberResult.stdout.toString();
  }

  static Future<ChcDevice> createDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var deviceData = <String, dynamic>{};
    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = switch (defaultTargetPlatform) {
          TargetPlatform.android =>
            _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
          TargetPlatform.iOS =>
            _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
          TargetPlatform.linux =>
            _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
          TargetPlatform.windows =>
            _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
          TargetPlatform.macOS =>
            _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
          TargetPlatform.fuchsia => <String, dynamic>{
              'Error:': 'Fuchsia platform isn\'t supported'
            },
        };
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final cpuSerial = await cpuSerialNumber();

    deviceData['appName'] = packageInfo.appName;
    deviceData['packageName'] = packageInfo.packageName;
    deviceData['appVersion'] = packageInfo.version;
    deviceData['appBuild'] = packageInfo.buildNumber;
    deviceData['installationId'] = Box.deviceId;
    return ChcDevice(
      manufacturer: deviceData['manufacturer'],
      model: deviceData['model'],
      board: (deviceData['board'] is List
              ? deviceData['board']?.first
              : deviceData['board']) ??
          '',
      brand: deviceData['brand'],
      os: deviceData['os'],
      osVersion: deviceData['osVersion'],
      osVersionSdk: deviceData['osVersionSdk'].toString(),
      serialNumber: cpuSerial, //deviceData['serialNumber'],
      appName: deviceData['appName'],
      packageName: deviceData['packageName'],
      appVersion: deviceData['appVersion'],
      appBuild: int.parse(deviceData['appBuild'] ?? '0'),
      installationId: deviceData['installationId'],
    );
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'manufacturer': build.manufacturer,
      'model': build.model,
      'board': build.board,
      'brand': build.brand,
      'os': 'android',
      'osVersion': build.version.release,
      'osVersionSdk': build.version.sdkInt,
      'serialNumber': build.serialNumber,
    };
  }

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'manufacturer': 'apple',
      'model': data.model,
      'board': data.utsname.machine,
      'brand': data.name,
      'os': data.systemName,
      'osVersion': data.systemVersion,
      'osVersionSdk': data.utsname.release,
      'serialNumber': data.identifierForVendor,
    };
  }

  static Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'manufacturer': data.name,
      'model': data.prettyName,
      'board': data.idLike,
      'brand': data.id,
      'os': data.name,
      'osVersion': data.version,
      'osVersionSdk': data.versionCodename,
      'serialNumber': data.machineId,
    };
  }

  static Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'manufacturer': data.browserName.name,
      'board': data.platform,
      'model': '${data.appCodeName} ${data.product}',
      'brand': data.vendor,
      'os': 'web',
      'osVersion': data.productSub,
      'osVersionSdk': data.userAgent,
      'serialNumber': 'unknown',
    };
  }

  static Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'manufacturer': 'apple',
      'model': data.model,
      'board': '${data.hostName}-${data.arch}',
      'brand': data.computerName,
      'os': 'macOS',
      'osVersionSdk': data.osRelease,
      'osVersion':
          '${data.majorVersion}.${data.minorVersion}.${data.patchVersion}',
      'serialNumber': data.systemGUID,
    };
  }

  static Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'manufacturer': 'microsoft',
      'model': data.editionId,
      'board': '${data.computerName}-${data.registeredOwner}',
      'brand': data.displayVersion,
      'os': data.productName,
      'osVersion': '${data.majorVersion}',
      'osVersionSdk':
          '${data.majorVersion}.${data.minorVersion}.${data.buildNumber}',
      'serialNumber': data.deviceId,
    };
  }
}
