import 'dart:convert';

enum HwConnectionType {
  uartSerial,
  wifi,
  ethernet,
  ble,
}

class HardwareExtension {
  int id;
  int deviceId;
  String modelName;
  int diCount;
  int doCount;
  int adcCount;
  int dacCount;
  String hardwareVersion;
  String firmwareVersion;
  String serialNumber;
  String manufacturer;
  String description;

  HardwareExtension({
    required this.id,
    required this.deviceId,
    required this.modelName,
    required this.diCount,
    required this.doCount,
    required this.adcCount,
    required this.dacCount,
    required this.hardwareVersion,
    required this.firmwareVersion,
    required this.serialNumber,
    required this.manufacturer,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceId': deviceId,
      'modelName': modelName,
      'diCount': diCount,
      'doCount': doCount,
      'adcCount': adcCount,
      'dacCount': dacCount,
      'hardwareVersion': hardwareVersion,
      'firmwareVersion': firmwareVersion,
      'serialNumber': serialNumber,
      'manufacturer': manufacturer,
      'description': description,
    };
  }

  Map<String, dynamic> toDb() {
    return id > 0
        ? {
            'id': id,
            'deviceId': deviceId,
            'modelName': modelName,
            'diCount': diCount,
            'doCount': doCount,
            'adcCount': adcCount,
            'dacCount': dacCount,
            'hardwareVersion': hardwareVersion,
            'firmwareVersion': firmwareVersion,
            'serialNumber': serialNumber,
            'manufacturer': manufacturer,
            'description': description,
          }
        : {
            'deviceId': deviceId,
            'modelName': modelName,
            'diCount': diCount,
            'doCount': doCount,
            'adcCount': adcCount,
            'dacCount': dacCount,
            'hardwareVersion': hardwareVersion,
            'firmwareVersion': firmwareVersion,
            'serialNumber': serialNumber,
            'manufacturer': manufacturer,
            'description': description,
          };
  }

  factory HardwareExtension.fromMap(Map<String, dynamic> map) {
    var conTypeStr = map['connectionType'];
    late List<dynamic> conTypeList;
    if (conTypeStr != null) {
      conTypeList = json.decode(conTypeStr) as List;
    }
    List<HwConnectionType> conTypes = [];
    for (final item in conTypeList) {
      final conType = HwConnectionType
          .values[HwConnectionType.values.indexWhere((e) => e.name == item)];

      conTypes.add(conType);
    }
    return HardwareExtension(
      id: map['id']?.toInt() ?? 0,
      deviceId: map['deviceId']?.toInt() ?? 0,
      modelName: map['modelName'] ?? '',
      diCount: map['diCount']?.toInt() ?? 0,
      doCount: map['doCount']?.toInt() ?? 0,
      adcCount: map['adcCount']?.toInt() ?? 0,
      dacCount: map['dacCount']?.toInt() ?? 0,
      hardwareVersion: map['hardwareVersion'] ?? '',
      firmwareVersion: map['firmwareVersion'] ?? '',
      serialNumber: map['serialNumber'] ?? '',
      manufacturer: map['manufacturer'] ?? '',
      description: map['description'] ?? '',
    );
  }

  factory HardwareExtension.fromDb(Map<String, dynamic> map) {
    var conTypeStr = map['connectionType'];
    late List<dynamic> conTypeList;
    if (conTypeStr != null) {
      conTypeList = json.decode(conTypeStr) as List;
    }
    List<HwConnectionType> conTypes = [];
    for (final item in conTypeList) {
      final conType = HwConnectionType
          .values[HwConnectionType.values.indexWhere((e) => e.name == item)];

      conTypes.add(conType);
    }
    return HardwareExtension(
      id: map['id']?.toInt() ?? 0,
      deviceId: map['deviceId']?.toInt() ?? 0,
      modelName: map['modelName'] ?? '',
      diCount: map['diCount']?.toInt() ?? 0,
      doCount: map['doCount']?.toInt() ?? 0,
      adcCount: map['adcCount']?.toInt() ?? 0,
      dacCount: map['dacCount']?.toInt() ?? 0,
      hardwareVersion: map['hardwareVersion'] ?? '',
      firmwareVersion: map['firmwareVersion'] ?? '',
      serialNumber: map['serialNumber'] ?? '',
      manufacturer: map['manufacturer'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HardwareExtension.fromJson(String source) =>
      HardwareExtension.fromMap(json.decode(source));
}
