import 'dart:convert';

class Device {
  final int id;
  final int? groupId;
  final String? icon;
  final String name;
  final int type;
  final int levelCount;
  final int outputCount;
  final int inputCount;
  final List<DeviceInput> deviceInputs;
  final List<DeviceOutput> deviceOutputs;
  final List<DeviceLevel> levels;
  final List<DeviceState> states;
  final int createdOn;
  final int modifiedOn;
  final String? groupName;

  Device({
    required this.id,
    this.groupId,
    this.icon,
    required this.name,
    required this.type,
    required this.levelCount,
    required this.outputCount,
    required this.inputCount,
    required this.deviceInputs,
    required this.deviceOutputs,
    required this.levels,
    required this.states,
    this.createdOn = 0,
    this.modifiedOn = 0,
    this.groupName,
  });

  Device copyWith({
    int? id,
    int? groupId,
    String? icon,
    String? name,
    int? type,
    int? levelCount,
    int? outputCount,
    int? inputCount,
    List<DeviceInput>? deviceInputs,
    List<DeviceOutput>? deviceOutputs,
    List<DeviceLevel>? levels,
    List<DeviceState>? states,
    int? createdOn,
    int? modifiedOn,
    String? groupName,
  }) {
    return Device(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      type: type ?? this.type,
      levelCount: levelCount ?? this.levelCount,
      outputCount: outputCount ?? this.outputCount,
      inputCount: inputCount ?? this.inputCount,
      deviceInputs: deviceInputs ?? this.deviceInputs,
      deviceOutputs: deviceOutputs ?? this.deviceOutputs,
      levels: levels ?? this.levels,
      states: states ?? this.states,
      createdOn: createdOn ?? this.createdOn,
      modifiedOn: modifiedOn ?? this.modifiedOn,
      groupName: groupName ?? this.groupName,
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
            'levelCount': levelCount,
            'outputCount': outputCount,
            'inputCount': inputCount,
            'deviceInputs':
                jsonEncode(deviceInputs.map((e) => e.toMap()).toList()),
            'deviceOutputs':
                jsonEncode(deviceOutputs.map((e) => e.toMap()).toList()),
            'levels': jsonEncode(levels.map((e) => e.toMap()).toList()),
            'states': jsonEncode(states.map((e) => e.toMap()).toList()),
            'createdOn': createdOn,
            'modifiedOn': modifiedOn,
          }
        : {
            'groupId': groupId,
            'icon': icon,
            'name': name,
            'type': type,
            'levelCount': levelCount,
            'outputCount': outputCount,
            'inputCount': inputCount,
            'deviceInputs':
                jsonEncode(deviceInputs.map((e) => e.toMap()).toList()),
            'deviceOutputs':
                jsonEncode(deviceOutputs.map((e) => e.toMap()).toList()),
            'levels': jsonEncode(levels.map((e) => e.toMap()).toList()),
            'states': jsonEncode(states.map((e) => e.toMap()).toList()),
            'createdOn': createdOn,
            'modifiedOn': modifiedOn,
          };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id']?.toInt() ?? 0,
      groupId: map['groupId']?.toInt(),
      icon: map['icon'],
      name: map['name'] ?? '',
      type: map['type']?.toInt() ?? 0,
      levelCount: map['levelCount']?.toInt() ?? 0,
      outputCount: map['outputCount']?.toInt() ?? 0,
      inputCount: map['inputCount']?.toInt() ?? 0,
      deviceInputs: map['deviceInputs']
              ?.map<DeviceInput>((x) => DeviceInput.fromMap(x))
              ?.toList() ??
          [],
      deviceOutputs: map['deviceOutputs']
              ?.map<DeviceOutput>((x) => DeviceOutput.fromMap(x))
              ?.toList() ??
          [],
      levels: map['levels']
              ?.map<DeviceLevel>((x) => DeviceLevel.fromMap(x))
              ?.toList() ??
          [],
      states: map['states']
              ?.map<DeviceState>((x) => DeviceState.fromMap(x))
              ?.toList() ??
          [],
      createdOn: map['createdOn']?.toInt() ?? 0,
      modifiedOn: map['modifiedOn']?.toInt() ?? 0,
    );
  }

  factory Device.empty() => Device(
        id: -1,
        groupId: null,
        icon: null,
        name: '',
        type: 0,
        levelCount: 1,
        outputCount: 1,
        inputCount: 0,
        deviceInputs: [
          DeviceInput(id: -1, deviceId: -1, inputId: 0, priority: 0)
        ],
        deviceOutputs: [
          DeviceOutput(id: -1, deviceId: -1, outputId: 0, priority: 0)
        ],
        levels: [
          DeviceLevel(level: 0, name: 'OFF'),
          DeviceLevel(level: 1, name: 'ON'),
        ],
        states: [],
        createdOn: DateTime.now().millisecondsSinceEpoch,
        modifiedOn: DateTime.now().millisecondsSinceEpoch,
      );

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) => Device.fromMap(json.decode(source));
}

class DeviceInput {
  final int id;
  final int deviceId;
  final int inputId;
  final int priority;
  final String? description;
  DeviceInput({
    required this.id,
    required this.deviceId,
    required this.inputId,
    required this.priority,
    this.description,
  });

  DeviceInput copyWith({
    int? id,
    int? deviceId,
    int? inputId,
    int? priority,
    String? description,
  }) {
    return DeviceInput(
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

  factory DeviceInput.fromMap(Map<String, dynamic> map) {
    return DeviceInput(
      id: map['id']?.toInt() ?? 0,
      deviceId: map['deviceId']?.toInt() ?? 0,
      inputId: map['inputId']?.toInt() ?? 0,
      priority: map['priority']?.toInt() ?? 0,
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceInput.fromJson(String source) =>
      DeviceInput.fromMap(json.decode(source));
}

class DeviceOutput {
  final int id;
  final int deviceId;
  final int outputId;
  final int priority;
  final String? description;
  DeviceOutput({
    required this.id,
    required this.deviceId,
    required this.outputId,
    required this.priority,
    this.description,
  });

  DeviceOutput copyWith({
    int? id,
    int? deviceId,
    int? outputId,
    int? priority,
    String? description,
  }) {
    return DeviceOutput(
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

  factory DeviceOutput.fromMap(Map<String, dynamic> map) {
    return DeviceOutput(
      id: map['id']?.toInt() ?? 0,
      deviceId: map['deviceId']?.toInt() ?? 0,
      outputId: map['outputId']?.toInt() ?? 0,
      priority: map['priority']?.toInt() ?? 0,
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceOutput.fromJson(String source) =>
      DeviceOutput.fromMap(json.decode(source));
}

class DeviceState {
  final int id;
  final int deviceId;
  final int level;
  final int? doId;
  final int? diId;
  final bool value;
  final bool isFeedback;
  DeviceState({
    required this.id,
    required this.deviceId,
    required this.level,
    this.doId,
    this.diId,
    required this.value,
    required this.isFeedback,
  });

  DeviceState copyWith({
    int? id,
    int? deviceId,
    int? level,
    int? doId,
    int? diId,
    bool? value,
    bool? isFeedback,
  }) {
    return DeviceState(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      level: level ?? this.level,
      doId: doId ?? this.doId,
      diId: diId ?? this.diId,
      value: value ?? this.value,
      isFeedback: isFeedback ?? this.isFeedback,
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
          }
        : {
            'deviceId': deviceId,
            'level': level,
            'doId': doId,
            'diId': diId,
            'value': value ? 1 : 0,
            'isFeedback': isFeedback ? 1 : 0,
          };
  }

  factory DeviceState.fromMap(Map<String, dynamic> map) {
    return DeviceState(
      id: map['id']?.toInt() ?? 0,
      deviceId: map['deviceId']?.toInt() ?? 0,
      level: map['level']?.toInt() ?? 0,
      doId: map['doId']?.toInt(),
      diId: map['diId']?.toInt(),
      value: map['value'] == 1 ? true : false,
      isFeedback: map['isFeedback'] == 1 ? true : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceState.fromJson(String source) =>
      DeviceState.fromMap(json.decode(source));
}

class DeviceLevel {
  final int level;
  final String name;
  DeviceLevel({
    required this.level,
    required this.name,
  });

  DeviceLevel copyWith({
    int? level,
    String? name,
  }) {
    return DeviceLevel(
      level: level ?? this.level,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'name': name,
    };
  }

  factory DeviceLevel.fromMap(Map<String, dynamic> map) {
    return DeviceLevel(
      level: map['level']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceLevel.fromJson(String source) =>
      DeviceLevel.fromMap(json.decode(source));
}
