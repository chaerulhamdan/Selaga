import 'dart:convert';
import 'dart:io';

class VenueModel {
  int? id;
  String? nameVenue;
  String? lokasiVenue;
  String? descVenue;
  String? fasilitasVenue;
  String? rating;
  String? price;
  String? image;
  dynamic mitraId;
  Owner? owner;
  List<Lapangan>? lapangans;

  VenueModel({
    this.id,
    this.nameVenue,
    this.lokasiVenue,
    this.descVenue,
    this.fasilitasVenue,
    this.rating,
    this.price,
    this.image,
    this.mitraId,
    this.owner,
    this.lapangans,
  });

  factory VenueModel.fromRawJson(String str) =>
      VenueModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VenueModel.fromJson(Map<String, dynamic> json) => VenueModel(
        id: json["id"],
        nameVenue: json["nameVenue"],
        lokasiVenue: json["lokasiVenue"],
        descVenue: json["descVenue"],
        fasilitasVenue: json["fasilitasVenue"],
        rating: json["rating"],
        price: json["price"],
        image: json["image"],
        mitraId: json["mitraId"],
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        lapangans: json["lapangans"] == null
            ? []
            : List<Lapangan>.from(
                json["lapangans"]!.map((x) => Lapangan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameVenue": nameVenue,
        "lokasiVenue": lokasiVenue,
        "descVenue": descVenue,
        "fasilitasVenue": fasilitasVenue,
        "rating": rating,
        "price": price,
        "image": image,
        "mitraId": mitraId,
        "owner": owner?.toJson(),
        "lapangans": lapangans == null
            ? []
            : List<dynamic>.from(lapangans!.map((x) => x.toJson())),
      };
}

class Lapangan {
  int? id;
  String? nameLapangan;
  DateTime? days;
  String? hour;
  dynamic venueId;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  // dynamic deletedAt;

  Lapangan({
    this.id,
    this.nameLapangan,
    this.days,
    this.hour,
    this.venueId,
    // this.createdAt,
    // this.updatedAt,
    // this.deletedAt,
  });

  factory Lapangan.fromRawJson(String str) =>
      Lapangan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Lapangan.fromJson(Map<String, dynamic> json) => Lapangan(
        id: json["id"],
        nameLapangan: json["nameLapangan"],
        days: json["days"] == null ? null : DateTime.parse(json["days"]),
        hour: json["hour"],
        venueId: json["venueId"],
        // createdAt: json["created_at"] == null
        //     ? null
        //     : DateTime.parse(json["created_at"]),
        // updatedAt: json["updated_at"] == null
        //     ? null
        //     : DateTime.parse(json["updated_at"]),
        // deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameLapangan": nameLapangan,
        "days":
            "${days!.year.toString().padLeft(4, '0')}-${days!.month.toString().padLeft(2, '0')}-${days!.day.toString().padLeft(2, '0')}",
        "hour": hour,
        "venueId": venueId,
        // "created_at": createdAt?.toIso8601String(),
        // "updated_at": updatedAt?.toIso8601String(),
        // "deleted_at": deletedAt,
      };
}

class Owner {
  int? id;
  String? name;
  String? email;
  String? phone;

  Owner({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory Owner.fromRawJson(String str) => Owner.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
      };
}

class RegisterVenue {
  String nameVenue;
  String lokasiVenue;
  String descVenue;
  String price;
  String rating = "0";
  List<String> fasilitas;
  List<File> img;

  RegisterVenue(
      {required this.nameVenue,
      required this.lokasiVenue,
      required this.descVenue,
      required this.price,
      required this.fasilitas,
      required this.img});
}
