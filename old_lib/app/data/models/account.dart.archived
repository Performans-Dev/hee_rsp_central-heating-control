import 'dart:convert';

class Account {
  String id;
  String createdAt;
  String email;
  String displayName;
  int status;
  String token;
  Account({
    required this.id,
    required this.createdAt,
    required this.email,
    required this.displayName,
    required this.status,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'email': email,
      'display_name': displayName,
      'status': status,
      'token': token
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] ?? '',
      createdAt: map['createdAt'] ?? '',
      email: map['email'] ?? '',
      displayName: map['display_name'] ?? '',
      status: map['status']?.toInt() ?? 0,
      token: map['token'] ?? '',
    );
  }

  factory Account.empty() {
    return Account(
      id: '',
      createdAt: '',
      email: '',
      displayName: '',
      status: 0,
      token: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));
}
