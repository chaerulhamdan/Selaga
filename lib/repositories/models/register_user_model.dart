import 'dart:convert';

class RegisterMitraModel {
  String name;
  String email;
  String phone;
  String password;

  RegisterMitraModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  factory RegisterMitraModel.fromRawJson(String str) =>
      RegisterMitraModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterMitraModel.fromJson(Map<String, dynamic> json) =>
      RegisterMitraModel(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
      };
}

class RegisterUserModel {
  String name;
  String email;
  String phone;
  String password;
  String status;

  RegisterUserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.status,
  });

  factory RegisterUserModel.fromRawJson(String str) =>
      RegisterUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) =>
      RegisterUserModel(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        status: json["STATUS"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "STATUS": status,
      };
}
