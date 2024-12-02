import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';

class ArgumentsMitra {
  dynamic venueId;
  dynamic venue;
  dynamic lapangan;
  dynamic selectedDateIndex;
  List<Lapangan>? listLapangan;
  List<JadwalLapanganModel>? listJadwal;

  ArgumentsMitra({
    required this.venueId,
    required this.venue,
    required this.lapangan,
    required this.selectedDateIndex,
    required this.listLapangan,
    required this.listJadwal,
  });

  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
      'venue': venue,
      'lapangan': lapangan,
      'selectedDateIndex': selectedDateIndex,
      'listLapangan': listLapangan == null
          ? []
          : List<dynamic>.from(listLapangan!.map((x) => x.toJson())),
      'ListJadwal': listJadwal == null
          ? []
          : List<dynamic>.from(listJadwal!.map((x) => x.toJson())),
    };
  }
}

class ArgumentsUser {
  dynamic venue;
  dynamic lapangan;
  List<JadwalLapanganModel>? listJadwal;

  ArgumentsUser({
    required this.venue,
    required this.lapangan,
    required this.listJadwal,
  });

  Map<String, dynamic> toJson() {
    return {
      'venue': venue,
      'lapangan': lapangan,
      'ListJadwal': listJadwal == null
          ? []
          : List<dynamic>.from(listJadwal!.map((x) => x.toJson())),
    };
  }
}
