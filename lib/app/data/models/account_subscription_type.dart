import 'dart:convert';

class AccountSubscription {
  String id;
  String name;
  String type;
  String expiresIn;
  String status;
  String createdAt;
  String accountId;
  String deviceId;
  String activationId;
  AccountSubscription({
    required this.id,
    required this.name,
    required this.type,
    required this.expiresIn,
    required this.status,
    required this.createdAt,
    required this.accountId,
    required this.deviceId,
    required this.activationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'expiresIn': expiresIn,
      'status': status,
      'createdAt': createdAt,
      'accountId': accountId,
      'deviceId': deviceId,
      'activationId': activationId,
    };
  }

  factory AccountSubscription.fromMap(Map<String, dynamic> map) {
    return AccountSubscription(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      expiresIn: map['expiresIn'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'] ?? '',
      accountId: map['accountId'] ?? '',
      deviceId: map['deviceId'] ?? '',
      activationId: map['activationId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountSubscription.fromJson(String source) => AccountSubscription.fromMap(json.decode(source));
}
