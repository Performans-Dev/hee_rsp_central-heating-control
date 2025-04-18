import 'dart:convert';

class PlatformInfo {
  final String? id;
  final String manufacturer;
  final String model;
  final String board;
  final String brand;
  final String os;
  final String osVersion;
  final String osVersionSdk;
  final String serialNumber;
  final String appName;
  final String packageName;
  final int appBuild;
  final String appVersion;
  final String installationId;
  PlatformInfo({
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
    required this.appBuild,
    required this.appVersion,
    required this.installationId,
  });

  PlatformInfo copyWith({
    String? id,
    String? manufacturer,
    String? model,
    String? board,
    String? brand,
    String? os,
    String? osVersion,
    String? osVersionSdk,
    String? serialNumber,
    String? appName,
    String? packageName,
    int? appBuild,
    String? appVersion,
    String? installationId,
  }) {
    return PlatformInfo(
      id: id ?? this.id,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      board: board ?? this.board,
      brand: brand ?? this.brand,
      os: os ?? this.os,
      osVersion: osVersion ?? this.osVersion,
      osVersionSdk: osVersionSdk ?? this.osVersionSdk,
      serialNumber: serialNumber ?? this.serialNumber,
      appName: appName ?? this.appName,
      packageName: packageName ?? this.packageName,
      appBuild: appBuild ?? this.appBuild,
      appVersion: appVersion ?? this.appVersion,
      installationId: installationId ?? this.installationId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'manufacturer': manufacturer,
      'model': model,
      'board': board,
      'brand': brand,
      'os': os,
      'osVersion': osVersion,
      'osVersionSdk': osVersionSdk,
      'serialNumber': serialNumber,
      'appName': appName,
      'packageName': packageName,
      'appBuild': appBuild,
      'appVersion': appVersion,
      'installationId': installationId,
    };
  }

  factory PlatformInfo.fromMap(Map<String, dynamic> map) {
    return PlatformInfo(
      id: map['id'],
      manufacturer: map['manufacturer'] ?? '',
      model: map['model'] ?? '',
      board: map['board'] ?? '',
      brand: map['brand'] ?? '',
      os: map['os'] ?? '',
      osVersion: map['osVersion'] ?? '',
      osVersionSdk: map['osVersionSdk'] ?? '',
      serialNumber: map['serialNumber'] ?? '',
      appName: map['appName'] ?? '',
      packageName: map['packageName'] ?? '',
      appBuild: map['appBuild']?.toInt() ?? 0,
      appVersion: map['appVersion'] ?? '',
      installationId: map['installationId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PlatformInfo.fromJson(String source) =>
      PlatformInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlatformInfo(id: $id, manufacturer: $manufacturer, model: $model, board: $board, brand: $brand, os: $os, osVersion: $osVersion, osVersionSdk: $osVersionSdk, serialNumber: $serialNumber, appName: $appName, packageName: $packageName, appBuild: $appBuild, appVersion: $appVersion, installationId: $installationId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlatformInfo &&
        other.id == id &&
        other.manufacturer == manufacturer &&
        other.model == model &&
        other.board == board &&
        other.brand == brand &&
        other.os == os &&
        other.osVersion == osVersion &&
        other.osVersionSdk == osVersionSdk &&
        other.serialNumber == serialNumber &&
        other.appName == appName &&
        other.packageName == packageName &&
        other.appBuild == appBuild &&
        other.appVersion == appVersion &&
        other.installationId == installationId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        manufacturer.hashCode ^
        model.hashCode ^
        board.hashCode ^
        brand.hashCode ^
        os.hashCode ^
        osVersion.hashCode ^
        osVersionSdk.hashCode ^
        serialNumber.hashCode ^
        appName.hashCode ^
        packageName.hashCode ^
        appBuild.hashCode ^
        appVersion.hashCode ^
        installationId.hashCode;
  }
}
