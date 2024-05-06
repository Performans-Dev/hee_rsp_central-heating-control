import 'dart:convert';

class ChcDevice {
  String? id;
  String manufacturer;
  String model;
  String board;
  String brand;
  String os;
  String osVersion;
  String osVersionSdk;
  String serialNumber;
  String appName;
  String packageName;
  String appVersion;
  String appBuild;
  String installationId;
  ChcDevice({
    this.id,
    required this.manufacturer,
    required this.model,
    required this.board,
    required this.brand,
    required this.os,
    required this.osVersion,
    required this.osVersionSdk,
    required this.serialNumber,
    required this.appName,
    required this.packageName,
    required this.appVersion,
    required this.appBuild,
    required this.installationId,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'manufacturer': manufacturer,
        'model': model,
        'board': board,
        'brand': brand,
        'os': os,
        'os_version': osVersion,
        'os_version_sdk': osVersionSdk,
        'serial_number': serialNumber,
        'app_name': appName,
        'package_name': packageName,
        'app_version': appVersion,
        'app_build': appBuild,
        'installation_id': installationId,
      };

  Map<String, dynamic> toPostgres() => id == null
      ? {
          'manufacturer': manufacturer,
          'model': model,
          'board': board,
          'brand': brand,
          'os': os,
          'os_version': osVersion,
          'os_version_sdk': osVersionSdk,
          'serial_number': serialNumber,
          'app_name': appName,
          'package_name': packageName,
          'app_version': appVersion,
          'app_build': appBuild,
          'installation_id': installationId,
        }
      : {
          'id': id,
          'manufacturer': manufacturer,
          'model': model,
          'board': board,
          'brand': brand,
          'os': os,
          'os_version': osVersion,
          'os_version_sdk': osVersionSdk,
          'serial_number': serialNumber,
          'app_name': appName,
          'package_name': packageName,
          'app_version': appVersion,
          'app_build': appBuild,
          'installation_id': installationId,
        };

  factory ChcDevice.fromMap(Map<String, dynamic> map) => ChcDevice(
        id: map['id'],
        manufacturer: map['manufacturer'] ?? '',
        model: map['model'] ?? '',
        board: (map['board'] is List)
            ? map['board'].first.toString()
            : map['board'] ?? '',
        brand: map['brand'] ?? '',
        os: map['os'] ?? '',
        osVersion: map['os_version'] ?? '',
        osVersionSdk: (map['os_version_sdk'] ?? '').toString(),
        serialNumber: map['serial_number'] ?? '',
        appName: map['app_name'] ?? '',
        packageName: map['package_name'] ?? '',
        appVersion: map['app_version'] ?? '',
        appBuild: map['app_build'] ?? '',
        installationId: map['installation_id'] ?? '',
      );

  String toJson() => json.encode(toMap());

  factory ChcDevice.fromJson(String source) =>
      ChcDevice.fromMap(json.decode(source));
}
