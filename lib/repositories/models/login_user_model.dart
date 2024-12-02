import 'dart:convert';

class LoginUserModel {
  String email;
  String password;

  LoginUserModel({
    required this.email,
    required this.password,
  });

  factory LoginUserModel.fromRawJson(String str) =>
      LoginUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginUserModel.fromJson(Map<String, dynamic> json) => LoginUserModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
