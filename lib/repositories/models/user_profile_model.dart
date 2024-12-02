import 'dart:convert';

class UserProfileMitraModel {
  int id;
  String name;
  String email;
  String phone;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  UserProfileMitraModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory UserProfileMitraModel.fromRawJson(String str) =>
      UserProfileMitraModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfileMitraModel.fromJson(Map<String, dynamic> json) =>
      UserProfileMitraModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}

class UserProfileModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  UserProfileModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory UserProfileModel.fromRawJson(String str) =>
      UserProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        status: json["STATUS"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "STATUS": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class LapanganDetailModel {
  int? id;
  String? nameLapangan;
  DateTime? days;
  String? hour;
  int? venueId;
  DataVenue? dataVenue;

  LapanganDetailModel({
    this.id,
    this.nameLapangan,
    this.days,
    this.hour,
    this.venueId,
    this.dataVenue,
  });

  factory LapanganDetailModel.fromRawJson(String str) =>
      LapanganDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LapanganDetailModel.fromJson(Map<String, dynamic> json) =>
      LapanganDetailModel(
        id: json["id"],
        nameLapangan: json["nameLapangan"],
        days: json["days"] == null ? null : DateTime.parse(json["days"]),
        hour: json["hour"],
        venueId: json["venueId"],
        dataVenue: json["dataVenue"] == null
            ? null
            : DataVenue.fromJson(json["dataVenue"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameLapangan": nameLapangan,
        "days":
            "${days!.year.toString().padLeft(4, '0')}-${days!.month.toString().padLeft(2, '0')}-${days!.day.toString().padLeft(2, '0')}",
        "hour": hour,
        "venueId": venueId,
        "dataVenue": dataVenue?.toJson(),
      };
}

class DataVenue {
  int? id;
  String? nameVenue;
  String? lokasiVenue;
  String? descVenue;
  String? fasilitasVenue;
  String? rating;

  DataVenue({
    this.id,
    this.nameVenue,
    this.lokasiVenue,
    this.descVenue,
    this.fasilitasVenue,
    this.rating,
  });

  factory DataVenue.fromRawJson(String str) =>
      DataVenue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataVenue.fromJson(Map<String, dynamic> json) => DataVenue(
        id: json["id"],
        nameVenue: json["nameVenue"],
        lokasiVenue: json["lokasiVenue"],
        descVenue: json["descVenue"],
        fasilitasVenue: json["fasilitasVenue"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameVenue": nameVenue,
        "lokasiVenue": lokasiVenue,
        "descVenue": descVenue,
        "fasilitasVenue": fasilitasVenue,
        "rating": rating,
      };
}
