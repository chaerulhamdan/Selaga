import 'dart:convert';

class JadwalLapanganModel {
  int? id;
  String? nameVenue;
  String? nameLapangan;
  DateTime? days;
  String? availableHour;
  String? unavailableHour;
  dynamic lapanganId;
  LapanganInfo? lapangan;

  JadwalLapanganModel({
    this.id,
    this.nameVenue,
    this.nameLapangan,
    this.days,
    this.availableHour,
    this.unavailableHour,
    this.lapanganId,
    this.lapangan,
  });

  factory JadwalLapanganModel.fromRawJson(String str) =>
      JadwalLapanganModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JadwalLapanganModel.fromJson(Map<String, dynamic> json) =>
      JadwalLapanganModel(
        id: json["id"],
        nameVenue: json["nameVenue"],
        nameLapangan: json["nameLapangan"],
        days: json["days"] == null ? null : DateTime.parse(json["days"]),
        availableHour: json["availableHour"],
        unavailableHour: json["unavailableHour"],
        lapanganId: json["lapanganId"],
        lapangan: json["lapangan"] == null
            ? null
            : LapanganInfo.fromJson(json["lapangan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameVenue": nameVenue,
        "nameLapangan": nameLapangan,
        "days":
            "${days!.year.toString().padLeft(4, '0')}-${days!.month.toString().padLeft(2, '0')}-${days!.day.toString().padLeft(2, '0')}",
        "availableHour": availableHour,
        "unavailableHour": unavailableHour,
        "lapanganId": lapanganId,
        "lapangan": lapangan?.toJson(),
      };
}

class LapanganInfo {
  int? id;
  String? nameLapangan;
  DateTime? days;
  String? hour;
  dynamic venueId;

  LapanganInfo({
    this.id,
    this.nameLapangan,
    this.days,
    this.hour,
    this.venueId,
  });

  factory LapanganInfo.fromRawJson(String str) =>
      LapanganInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LapanganInfo.fromJson(Map<String, dynamic> json) => LapanganInfo(
        id: json["id"],
        nameLapangan: json["nameLapangan"],
        days: json["days"] == null ? null : DateTime.parse(json["days"]),
        hour: json["hour"],
        venueId: json["venueId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameLapangan": nameLapangan,
        "days":
            "${days!.year.toString().padLeft(4, '0')}-${days!.month.toString().padLeft(2, '0')}-${days!.day.toString().padLeft(2, '0')}",
        "hour": hour,
        "venueId": venueId,
      };
}
