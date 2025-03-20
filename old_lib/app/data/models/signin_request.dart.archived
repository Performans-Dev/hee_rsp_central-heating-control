import 'dart:convert';

class SigninRequest {
  String email;
  String password;
  SigninRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory SigninRequest.fromMap(Map<String, dynamic> map) {
    return SigninRequest(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SigninRequest.fromJson(String source) => SigninRequest.fromMap(json.decode(source));
}
