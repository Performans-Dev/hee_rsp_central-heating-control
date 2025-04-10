import 'dart:convert';

class Device {
  final int id;
  final int? groupId;
  final String? icon;
  final String name;
  final int type;
  Device({
    required this.id,
    this.groupId,
    this.icon,
    required this.name,
    required this.type,
  });

  Device copyWith({
    int? id,
    int? groupId,
    String? icon,
    String? name,
    int? type,
  }) {
    return Device(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return id > 0
        ? {
            'id': id,
            'groupId': groupId,
            'icon': icon,
            'name': name,
            'type': type,
          }
        : {
            'groupId': groupId,
            'icon': icon,
            'name': name,
            'type': type,
          };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id']?.toInt() ?? 0,
      groupId: map['groupId']?.toInt(),
      icon: map['icon'],
      name: map['name'] ?? '',
      type: map['type']?.toInt() ?? 0,
    );
  }

  factory Device.empty() => Device(
        id: -1,
        groupId: null,
        icon: null,
        name: '',
        type: 0,
      );

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) => Device.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Device(id: $id, groupId: $groupId, icon: $icon, name: $name, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Device &&
        other.id == id &&
        other.groupId == groupId &&
        other.icon == icon &&
        other.name == name &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        groupId.hashCode ^
        icon.hashCode ^
        name.hashCode ^
        type.hashCode;
  }
}

class DeviceInputs {
  final int id;
  final int deviceId;
  final int inputId;
  final int priority;
  final String? description;
  DeviceInputs({
    required this.id,
    required this.deviceId,
    required this.inputId,
    required this.priority,
    this.description,
  });

  DeviceInputs copyWith({
    int? id,
    int? deviceId,
    int? inputId,
    int? priority,
    String? description,
  }) {
    return DeviceInputs(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      inputId: inputId ?? this.inputId,
      priority: priority ?? this.priority,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return id > 0
        ? {
            'id': id,
            'deviceId': deviceId,
            'inputId': inputId,
            'priority': priority,
            'description': description,
          }
        : {
            'deviceId': deviceId,
            'inputId': inputId,
            'priority': priority,
            'description': description,
          };
  }

  factory DeviceInputs.fromMap(Map<String, dynamic> map) {
    return DeviceInputs(
      id: map['id']?.toInt() ?? 0,
      deviceId: map['deviceId']?.toInt() ?? 0,
      inputId: map['inputId']?.toInt() ?? 0,
      priority: map['priority']?.toInt() ?? 0,
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceInputs.fromJson(String source) =>
      DeviceInputs.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeviceInputs(id: $id, deviceId: $deviceId, inputId: $inputId, priority: $priority, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeviceInputs &&
        other.id == id &&
        other.deviceId == deviceId &&
        other.inputId == inputId &&
        other.priority == priority &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        deviceId.hashCode ^
        inputId.hashCode ^
        priority.hashCode ^
        description.hashCode;
  }
}

class DeviceOutputs {
  final int id;
  final int deviceId;
  final int outputId;
  final int priority;
  final String? description;
  DeviceOutputs({
    required this.id,
    required this.deviceId,
    required this.outputId,
    required this.priority,
    this.description,
  });

  DeviceOutputs copyWith({
    int? id,
    int? deviceId,
    int? outputId,
    int? priority,
    String? description,
  }) {
    return DeviceOutputs(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      outputId: outputId ?? this.outputId,
      priority: priority ?? this.priority,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return id > 0
        ? {
            'id': id,
            'deviceId': deviceId,
            'outputId': outputId,
            'priority': priority,
            'description': description,
          }
        : {
            'deviceId': deviceId,
            'outputId': outputId,
            'priority': priority,
            'description': description,
          };
  }

  factory DeviceOutputs.fromMap(Map<String, dynamic> map) {
    return DeviceOutputs(
      id: map['id']?.toInt() ?? 0,
      deviceId: map['deviceId']?.toInt() ?? 0,
      outputId: map['outputId']?.toInt() ?? 0,
      priority: map['priority']?.toInt() ?? 0,
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceOutputs.fromJson(String source) =>
      DeviceOutputs.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeviceOutputs(id: $id, deviceId: $deviceId, outputId: $outputId, priority: $priority, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeviceOutputs &&
        other.id == id &&
        other.deviceId == deviceId &&
        other.outputId == outputId &&
        other.priority == priority &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        deviceId.hashCode ^
        outputId.hashCode ^
        priority.hashCode ^
        description.hashCode;
  }
}

class DeviceStates {
  final int id;
  final int deviceId;
  final int level;
  final int? doId;
  final int? diId;
  final bool value;
  final bool isFeedback;
  final String? name;
  DeviceStates({
    required this.id,
    required this.deviceId,
    required this.level,
    this.doId,
    this.diId,
    required this.value,
    required this.isFeedback,
    this.name,
  });

  DeviceStates copyWith({
    int? id,
    int? deviceId,
    int? level,
    int? doId,
    int? diId,
    bool? value,
    bool? isFeedback,
    String? name,
  }) {
    return DeviceStates(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      level: level ?? this.level,
      doId: doId ?? this.doId,
      diId: diId ?? this.diId,
      value: value ?? this.value,
      isFeedback: isFeedback ?? this.isFeedback,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return id > 0
        ? {
            'id': id,
            'deviceId': deviceId,
            'level': level,
            'doId': doId,
            'diId': diId,
            'value': value ? 1 : 0,
            'isFeedback': isFeedback ? 1 : 0,
            'name': name,
          }
        : {
            'deviceId': deviceId,
            'level': level,
            'doId': doId,
            'diId': diId,
            'value': value ? 1 : 0,
            'isFeedback': isFeedback ? 1 : 0,
            'name': name,
          };
  }

  factory DeviceStates.fromMap(Map<String, dynamic> map) {
    return DeviceStates(
      id: map['id']?.toInt() ?? 0,
      deviceId: map['deviceId']?.toInt() ?? 0,
      level: map['level']?.toInt() ?? 0,
      doId: map['doId']?.toInt(),
      diId: map['diId']?.toInt(),
      value: map['value'] == 1 ? true : false,
      isFeedback: map['isFeedback'] == 1 ? true : false,
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceStates.fromJson(String source) =>
      DeviceStates.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DeviceStates(id: $id, deviceId: $deviceId, level: $level, doId: $doId, diId: $diId, value: $value, isFeedback: $isFeedback, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeviceStates &&
        other.id == id &&
        other.deviceId == deviceId &&
        other.level == level &&
        other.doId == doId &&
        other.diId == diId &&
        other.value == value &&
        other.isFeedback == isFeedback &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        deviceId.hashCode ^
        level.hashCode ^
        doId.hashCode ^
        diId.hashCode ^
        value.hashCode ^
        isFeedback.hashCode ^
        name.hashCode;
  }
}
