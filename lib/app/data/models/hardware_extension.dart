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
  List<HwConnectionType> connectionType;
  HwProfileUart? uartProfile;
  HwProfileWifi? wifiProfile;
  HwProfileEthernet? ethernetProfile;
  HwProfileBle? bleProfile;
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
    required this.connectionType,
    this.uartProfile,
    this.wifiProfile,
    this.ethernetProfile,
    this.bleProfile,
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
      'connectionType': connectionType.map((x) => x.name).toList(),
      'hwProfileUart': uartProfile?.toMap(),
      'hwProfileWifi': wifiProfile?.toMap(),
      'hwProfileEthernet': ethernetProfile?.toMap(),
      'hwProfileBle': bleProfile?.toMap(),
    };
  }

  Map<String, dynamic> toDb() {
    List<String> conType = [];
    for (final item in connectionType) {
      conType.add(item.name);
    }
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
            'connectionType': json.encode(conType),
            'hwProfileUart': uartProfile?.toJson(),
            'hwProfileWifi': wifiProfile?.toJson(),
            'hwProfileEthernet': ethernetProfile?.toJson(),
            'hwProfileBle': bleProfile?.toJson(),
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
            'connectionType': json.encode(conType),
            'hwProfileUart': uartProfile?.toJson(),
            'hwProfileWifi': wifiProfile?.toJson(),
            'hwProfileEthernet': ethernetProfile?.toJson(),
            'hwProfileBle': bleProfile?.toJson(),
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
      connectionType: conTypes,
      uartProfile: map['hwProfileUart'] != null
          ? HwProfileUart.fromMap(map['hwProfileUart'])
          : null,
      wifiProfile: map['hwProfileWifi'] != null
          ? HwProfileWifi.fromMap(map['hwProfileWifi'])
          : null,
      ethernetProfile: map['hwProfileEthernet'] != null
          ? HwProfileEthernet.fromMap(map['hwProfileEthernet'])
          : null,
      bleProfile: map['hwProfileBle'] != null
          ? HwProfileBle.fromMap(map['hwProfileBle'])
          : null,
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
      connectionType: conTypes,
      uartProfile: map['hwProfileUart'] != null
          ? HwProfileUart.fromJson(map['hwProfileUart'])
          : null,
      wifiProfile: map['hwProfileWifi'] != null
          ? HwProfileWifi.fromJson(map['hwProfileWifi'])
          : null,
      ethernetProfile: map['hwProfileEthernet'] != null
          ? HwProfileEthernet.fromJson(map['hwProfileEthernet'])
          : null,
      bleProfile: map['hwProfileBle'] != null
          ? HwProfileBle.fromJson(map['hwProfileBle'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HardwareExtension.fromJson(String source) =>
      HardwareExtension.fromMap(json.decode(source));
}

class HwProfileUart {
  int baudrate;
  int bits;
  int stopBits;
  int parity;
  int xonXoff;
  int rts;
  int cts;
  int dsr;
  int dtr;
  HwProfileUart({
    required this.baudrate,
    required this.bits,
    required this.stopBits,
    required this.parity,
    required this.xonXoff,
    required this.rts,
    required this.cts,
    required this.dsr,
    required this.dtr,
  });

  Map<String, dynamic> toMap() {
    return {
      'baudrate': baudrate,
      'bits': bits,
      'stopBits': stopBits,
      'parity': parity,
      'xonXoff': xonXoff,
      'rts': rts,
      'cts': cts,
      'dsr': dsr,
      'dtr': dtr,
    };
  }

  factory HwProfileUart.fromMap(Map<String, dynamic> map) {
    return HwProfileUart(
      baudrate: map['baudrate']?.toInt() ?? 9600,
      bits: map['bits']?.toInt() ?? 8,
      stopBits: map['stopBits']?.toInt() ?? 1,
      parity: map['parity']?.toInt() ?? 0,
      xonXoff: map['xonXoff']?.toInt() ?? 0,
      rts: map['rts']?.toInt() ?? 1,
      cts: map['cts']?.toInt() ?? 0,
      dsr: map['dsr']?.toInt() ?? 0,
      dtr: map['dtr']?.toInt() ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory HwProfileUart.fromJson(String source) =>
      HwProfileUart.fromMap(json.decode(source));
}

class HwProfileWifi {
  String ssid;
  String password;
  int security;
  String macAddress;
  String ipAddress;
  HwProfileWifi({
    required this.ssid,
    required this.password,
    required this.security,
    required this.macAddress,
    required this.ipAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'ssid': ssid,
      'password': password,
      'security': security,
      'macAddress': macAddress,
      'ipAddress': ipAddress,
    };
  }

  factory HwProfileWifi.fromMap(Map<String, dynamic> map) {
    return HwProfileWifi(
      ssid: map['ssid'] ?? '',
      password: map['password'] ?? '',
      security: map['security']?.toInt() ?? 0,
      macAddress: map['macAddress'] ?? '',
      ipAddress: map['ipAddress'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HwProfileWifi.fromJson(String source) =>
      HwProfileWifi.fromMap(json.decode(source));
}

class HwProfileEthernet {
  String macAddress;
  String ipAddress;
  HwProfileEthernet({
    required this.macAddress,
    required this.ipAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'macAddress': macAddress,
      'ipAddress': ipAddress,
    };
  }

  factory HwProfileEthernet.fromMap(Map<String, dynamic> map) {
    return HwProfileEthernet(
      macAddress: map['macAddress'] ?? '',
      ipAddress: map['ipAddress'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HwProfileEthernet.fromJson(String source) =>
      HwProfileEthernet.fromMap(json.decode(source));
}

class HwProfileBle {
  String macAddress;
  String advertisementId;
  HwProfileBle({
    required this.macAddress,
    required this.advertisementId,
  });

  Map<String, dynamic> toMap() {
    return {
      'macAddress': macAddress,
      'advertisementId': advertisementId,
    };
  }

  factory HwProfileBle.fromMap(Map<String, dynamic> map) {
    return HwProfileBle(
      macAddress: map['macAddress'] ?? '',
      advertisementId: map['advertisementId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HwProfileBle.fromJson(String source) =>
      HwProfileBle.fromMap(json.decode(source));
}
