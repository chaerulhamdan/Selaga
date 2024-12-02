import 'dart:convert';

import 'package:selaga_ver1/repositories/models/venue_model.dart';

class BookingModel {
  int id;
  String orderName;
  DateTime date;
  String hours;
  String payment;
  dynamic orderId;
  dynamic bookingId;
  Order order;
  Timetable timetable;
  String image;
  String confirmation;
  String ratingStatus;

  BookingModel(
      {required this.id,
      required this.orderName,
      required this.date,
      required this.hours,
      required this.payment,
      required this.orderId,
      required this.bookingId,
      required this.order,
      required this.timetable,
      required this.image,
      required this.confirmation,
      required this.ratingStatus});

  factory BookingModel.fromRawJson(String str) =>
      BookingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json["id"],
        orderName: json["orderName"],
        date: DateTime.parse(json["date"]),
        hours: json["hours"],
        payment: json["payment"],
        orderId: json["orderId"],
        bookingId: json["bookingId"],
        order: Order.fromJson(json["order"]),
        timetable: Timetable.fromJson(json["timetable"]),
        image: json["image"],
        confirmation: json["confirmation"],
        ratingStatus: json['ratingStatus'] ?? 'PENDING',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderName": orderName,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "hours": hours,
        "payment": payment,
        "orderId": orderId,
        "bookingId": bookingId,
        "order": order.toJson(),
        "timetable": timetable.toJson(),
        "image": image,
        "confirmation": confirmation,
        "ratingStatus": ratingStatus
      };
}

class Order {
  int id;
  String name;
  String email;
  String phone;

  Order({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
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

class Timetable {
  int id;
  String nameVenue;
  String nameLapangan;
  DateTime days;
  String availableHour;
  String unavailableHour;
  dynamic lapanganId;
  LapanganBooking lapanganBooking;

  Timetable({
    required this.id,
    required this.nameVenue,
    required this.nameLapangan,
    required this.days,
    required this.availableHour,
    required this.unavailableHour,
    required this.lapanganId,
    required this.lapanganBooking,
  });

  factory Timetable.fromRawJson(String str) =>
      Timetable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Timetable.fromJson(Map<String, dynamic> json) => Timetable(
        id: json["id"],
        nameVenue: json["nameVenue"],
        nameLapangan: json["nameLapangan"],
        days: DateTime.parse(json["days"]),
        availableHour: json["availableHour"],
        unavailableHour: json["unavailableHour"],
        lapanganId: json["lapanganId"],
        lapanganBooking: LapanganBooking.fromJson(json["lapangan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameVenue": nameVenue,
        "nameLapangan": nameLapangan,
        "days":
            "${days.year.toString().padLeft(4, '0')}-${days.month.toString().padLeft(2, '0')}-${days.day.toString().padLeft(2, '0')}",
        "availableHour": availableHour,
        "unavailableHour": unavailableHour,
        "lapanganId": lapanganId,
        "lapangan": lapanganBooking.toJson(),
      };
}

class LapanganBooking {
  int id;
  String nameLapangan;
  DateTime days;
  String hour;
  dynamic venueId;
  VenueModel venueBooking;

  LapanganBooking({
    required this.id,
    required this.nameLapangan,
    required this.days,
    required this.hour,
    required this.venueId,
    required this.venueBooking,
  });

  factory LapanganBooking.fromRawJson(String str) =>
      LapanganBooking.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LapanganBooking.fromJson(Map<String, dynamic> json) =>
      LapanganBooking(
        id: json["id"],
        nameLapangan: json["nameLapangan"],
        days: DateTime.parse(json["days"]),
        hour: json["hour"],
        venueId: json["venueId"],
        venueBooking: VenueModel.fromJson(json["venue"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameLapangan": nameLapangan,
        "days":
            "${days.year.toString().padLeft(4, '0')}-${days.month.toString().padLeft(2, '0')}-${days.day.toString().padLeft(2, '0')}",
        "hour": hour,
        "venueId": venueId,
        "venue": venueBooking.toJson(),
      };
}

class VenueBooking {
  int id;
  String nameVenue;
  String lokasiVenue;
  String descVenue;
  String fasilitasVenue;
  String price;
  String rating;
  String image;
  dynamic mitraId;

  VenueBooking({
    required this.id,
    required this.nameVenue,
    required this.lokasiVenue,
    required this.descVenue,
    required this.fasilitasVenue,
    required this.price,
    required this.rating,
    required this.image,
    required this.mitraId,
  });

  factory VenueBooking.fromRawJson(String str) =>
      VenueBooking.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VenueBooking.fromJson(Map<String, dynamic> json) => VenueBooking(
        id: json["id"],
        nameVenue: json["nameVenue"],
        lokasiVenue: json["lokasiVenue"],
        descVenue: json["descVenue"],
        fasilitasVenue: json["fasilitasVenue"],
        price: json["price"],
        rating: json["rating"],
        image: json["image"],
        mitraId: json["mitraId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameVenue": nameVenue,
        "lokasiVenue": lokasiVenue,
        "descVenue": descVenue,
        "fasilitasVenue": fasilitasVenue,
        "price": price,
        "rating": rating,
        "image": image,
        "mitraId": mitraId,
      };
}
