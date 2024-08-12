import 'dart:convert';

class RegisterRequest {
  String email;
  String fullName;
  String password;  
  RegisterRequest({
    required this.email,
    required this.fullName,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'password': password,
    };
  }

  factory RegisterRequest.fromMap(Map<String, dynamic> map) {
    return RegisterRequest(
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterRequest.fromJson(String source) => RegisterRequest.fromMap(json.decode(source));
}
