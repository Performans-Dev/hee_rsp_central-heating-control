import 'dart:convert';

class ActivationResult {
  String id;
  String createdAt;
  String chcDeviceId;
  String userId;
  int status;
  String activationTime;
  ActivationResult({
    required this.id,
    required this.createdAt,
    required this.chcDeviceId,
    required this.userId,
    required this.status,
    required this.activationTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt,
      'chc_device_id': chcDeviceId,
      'user_id': userId,
      'status': status,
      'activation_time': activationTime,
    };
  }

  factory ActivationResult.fromMap(Map<String, dynamic> map) {
    return ActivationResult(
      id: map['id'] ?? '',
      createdAt: map['created_at'] ?? '',
      chcDeviceId: map['chc_device_id'] ?? '',
      userId: map['user_id'] ?? '',
      status: map['status']?.toInt() ?? 0,
      activationTime: map['activation_time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivationResult.fromJson(String source) =>
      ActivationResult.fromMap(json.decode(source));
}
