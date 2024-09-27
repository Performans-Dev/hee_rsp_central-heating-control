import 'dart:convert';

enum HwConnectionType {
  uartSerial,
  wifi,
  ethernet,
  ble,
}

class HardwareExtension {
  int id;
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
      'uartProfile': uartProfile?.toMap(),
      'wifiProfile': wifiProfile?.toMap(),
      'ethernetProfile': ethernetProfile?.toMap(),
      'bleProfile': bleProfile?.toMap(),
    };
  }

  Map<String, dynamic> toDb() {
    return id > 0
        ? {
            'id': id,
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
            'uartProfile': uartProfile?.toJson(),
            'wifiProfile': wifiProfile?.toJson(),
            'ethernetProfile': ethernetProfile?.toJson(),
            'bleProfile': bleProfile?.toJson(),
          }
        : {
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
            'uartProfile': uartProfile?.toJson(),
            'wifiProfile': wifiProfile?.toJson(),
            'ethernetProfile': ethernetProfile?.toJson(),
            'bleProfile': bleProfile?.toJson(),
          };
  }

  factory HardwareExtension.fromMap(Map<String, dynamic> map) {
    return HardwareExtension(
      id: map['id']?.toInt() ?? 0,
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
      connectionType: List<HwConnectionType>.from(map['connectionType']?.map(
          (x) => HwConnectionType
              .values[HwConnectionType.values.indexWhere((e) => e.name == x)])),
      uartProfile: map['uartProfile'] != null
          ? HwProfileUart.fromMap(map['uartProfile'])
          : null,
      wifiProfile: map['wifiProfile'] != null
          ? HwProfileWifi.fromMap(map['wifiProfile'])
          : null,
      ethernetProfile: map['ethernetProfile'] != null
          ? HwProfileEthernet.fromMap(map['ethernetProfile'])
          : null,
      bleProfile: map['bleProfile'] != null
          ? HwProfileBle.fromMap(map['bleProfile'])
          : null,
    );
  }

  factory HardwareExtension.fromDb(Map<String, dynamic> map) {
    return HardwareExtension(
      id: map['id']?.toInt() ?? 0,
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
      connectionType: List<HwConnectionType>.from(map['connectionType']?.map(
          (x) => HwConnectionType
              .values[HwConnectionType.values.indexWhere((e) => e.name == x)])),
      uartProfile: map['uartProfile'] != null
          ? HwProfileUart.fromJson(map['uartProfile'])
          : null,
      wifiProfile: map['wifiProfile'] != null
          ? HwProfileWifi.fromJson(map['wifiProfile'])
          : null,
      ethernetProfile: map['ethernetProfile'] != null
          ? HwProfileEthernet.fromJson(map['ethernetProfile'])
          : null,
      bleProfile: map['bleProfile'] != null
          ? HwProfileBle.fromJson(map['bleProfile'])
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
