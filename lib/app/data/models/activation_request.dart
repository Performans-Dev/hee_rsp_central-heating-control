import 'dart:convert';

class ActivationRequest {
  String userId;
  String chcDeviceId;
  ActivationRequest({
    required this.userId,
    required this.chcDeviceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'chc_device_id': chcDeviceId,
    };
  }

  factory ActivationRequest.fromMap(Map<String, dynamic> map) {
    return ActivationRequest(
      userId: map['user_id'] ?? '',
      chcDeviceId: map['chc_device_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivationRequest.fromJson(String source) =>
      ActivationRequest.fromMap(json.decode(source));
}
