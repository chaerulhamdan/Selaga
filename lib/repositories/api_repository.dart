import 'dart:io';

import 'package:dio/dio.dart';
import 'package:selaga_ver1/repositories/models/api_response.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/login_user_model.dart';
import 'package:selaga_ver1/repositories/models/register_user_model.dart';
import 'package:selaga_ver1/repositories/models/user_profile_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/shared_preference/shared_preference_repository.dart';

class ApiRepository {
  final Dio api;

  ApiRepository({Dio? dio}) : api = dio ?? Dio() {
    api.options.baseUrl = "https://selaga.my.id/api";
    api.options.receiveDataWhenStatusError = true;
  }

  // ApiRepository({Dio? dio}) : api = dio ?? Dio() {
  //   api.options.baseUrl = "http://192.168.0.106/skripsi-selaga/public/api";
  //   api.options.receiveDataWhenStatusError = true;
  // }

  // https://selaga.my.id/api
  // http://192.168.0.106/skripsi-selaga/public/api

  Future<ApiResponse<UserProfileMitraModel>> getMyMitraProfile(
      String token) async {
    try {
      final result = await api.get("/profileMitra",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return ApiResponse(
          result: UserProfileMitraModel.fromJson(result.data['data']));
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<UserProfileModel>> getMyProfile(String token) async {
    try {
      final result = await api.get("/profile",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return ApiResponse(
          result: UserProfileModel.fromJson(result.data['data']));
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> userLogin(LoginUserModel user) async {
    final SharedPreferenceRepository sharedPreferenceRepository;
    sharedPreferenceRepository = SharedPreferenceRepositoryImpl();

    try {
      final result = await api.post("/login", data: user.toRawJson());
      sharedPreferenceRepository.setValue(
          "token", result.data['token'].toString());
      sharedPreferenceRepository.setValue("user", "penyewa");
      return ApiResponse(result: result.data['token'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> userRegister(RegisterUserModel user) async {
    try {
      final result = await api.post("/register", data: user.toRawJson());
      return ApiResponse(result: result.data['token'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.message?.toString());
    }
  }

  Future<ApiResponse<String>> userLogout(String token) async {
    final SharedPreferenceRepository sharedPreferenceRepository;
    sharedPreferenceRepository = SharedPreferenceRepositoryImpl();
    try {
      final result = await api.get("/logout",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      sharedPreferenceRepository.clearValue("token");
      sharedPreferenceRepository.clearValue("user");
      return ApiResponse(result: result.data['message'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.error.toString());
    }
  }

  Future<ApiResponse<String>> daftarVenue(
      String token, RegisterVenue venue) async {
    var formData = FormData.fromMap({
      "nameVenue": venue.nameVenue,
      "lokasiVenue": venue.lokasiVenue,
      "descVenue": venue.descVenue,
      "price": venue.price,
      "rating": venue.rating,
    }, ListFormat.multiCompatible);

    for (var e in venue.fasilitas) {
      formData.fields.addAll([MapEntry('fasilitasVenue[]', e)]);
    }

    for (var file in venue.img) {
      formData.files.addAll([
        MapEntry(
            "file[]",
            await MultipartFile.fromFile(file.path,
                filename: file.path.split('/').last)),
      ]);
    }
    try {
      final result = await api.post("/venue",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: formData);
      return ApiResponse(result: result.data['message'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> editVenue(String token, VenueModel venue) async {
    var formData = FormData.fromMap({
      "nameVenue": venue.nameVenue,
      "lokasiVenue": venue.lokasiVenue,
      "descVenue": venue.descVenue,
      "price": venue.price,
    }, ListFormat.multiCompatible);

    final fasilitas = venue.fasilitasVenue!.split(',');
    for (var e in fasilitas) {
      formData.fields.addAll([MapEntry('fasilitasVenue[]', e)]);
    }

    try {
      final result = await api.post("/venuenoimage/${venue.id}?_method=PATCH",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: formData);
      return ApiResponse(result: result.data['message'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> updateVenueRating(
      String token, VenueModel venue, String rating) async {
    var formData = FormData.fromMap({
      "rating": rating,
    }, ListFormat.multiCompatible);

    try {
      final result = await api.post("/venuerating/${venue.id}?_method=PATCH",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: formData);
      return ApiResponse(result: result.data['message'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> mitraLogin(LoginUserModel user) async {
    final SharedPreferenceRepository sharedPreferenceRepository;
    sharedPreferenceRepository = SharedPreferenceRepositoryImpl();
    try {
      final result = await api.post("/loginMitra", data: user.toRawJson());
      sharedPreferenceRepository.setValue(
          "token", result.data['token'].toString());
      sharedPreferenceRepository.setValue("user", "mitra");
      return ApiResponse(result: result.data['token'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> mitraRegister(RegisterMitraModel user) async {
    try {
      final result = await api.post("/registerMitra", data: user.toRawJson());
      return ApiResponse(result: result.data['token'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> mitraLogout(String token) async {
    final SharedPreferenceRepository sharedPreferenceRepository;
    sharedPreferenceRepository = SharedPreferenceRepositoryImpl();
    try {
      final result = await api.get("/logoutMitra",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      sharedPreferenceRepository.clearValue("token");
      sharedPreferenceRepository.clearValue("user");
      return ApiResponse(result: result.data['message'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.error.toString());
    }
  }

  Future<ApiResponse<List<VenueModel>>> getAllVenue(String token) async {
    try {
      final result = await api.get("/venue",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      final List<dynamic> data = result.data['data'];
      final response =
          data.map<VenueModel>((e) => VenueModel.fromJson(e)).toList();
      return ApiResponse(result: response);
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<VenueModel>> getVenueDetail(String token, int id) async {
    try {
      final result = await api.get("/venue/$id",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return ApiResponse(result: VenueModel.fromJson(result.data['data']));
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> deleteVenue(String token, int id) async {
    try {
      final result = await api.delete("/venue/$id",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return ApiResponse(result: result.data['message']);
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<List<Lapangan>>> getMyLapangan(
      String token, int id) async {
    try {
      final result = await api.get("/venue/$id",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      final List<dynamic> lapangan = result.data['data']['lapangans'];
      final response = lapangan
          .map<Lapangan>((lapangan) => Lapangan.fromJson(lapangan))
          .toList();
      return ApiResponse(result: response);
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> deleteLapangan(String token, int id) async {
    try {
      final result = await api.delete("/lapangan/$id",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return ApiResponse(result: result.data['message']);
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> daftarLapangan(
      String token, String nama, int id, String hour) async {
    var formData = FormData.fromMap({
      "nameLapangan": nama,
      "days": '1111-11-11',
      "hour": hour,
      "venueId": '$id',
    }, ListFormat.multiCompatible);

    try {
      final result = await api.post("/lapangan",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: formData);
      return ApiResponse(result: result.data['message'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> updateLapangan(
      String token, String hour, Lapangan data) async {
    var formData = FormData.fromMap({
      "nameLapangan": data.nameLapangan,
      "days": data.days,
      "hour": hour,
    }, ListFormat.multiCompatible);

    try {
      final result = await api.post("/lapangan/${data.id}?_method=PATCH",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: formData);
      return ApiResponse(result: result.data['message'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<List<JadwalLapanganModel>>> getJadwalLapangan(
      String token) async {
    try {
      final result = await api.get("/timetable",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      final List<dynamic> data = result.data['data'];
      final response = data
          .map<JadwalLapanganModel>((e) => JadwalLapanganModel.fromJson(e))
          .toList();
      return ApiResponse(result: response);
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<LapanganInfo>> getLapanganDetail(
      String token, int id) async {
    try {
      final result = await api.get("/lapangan/$id",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return ApiResponse(result: LapanganInfo.fromJson(result.data['data']));
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> postTambahJadwal({
    required String token,
    required String nameVenue,
    required String nameLapangan,
    required DateTime date,
    required String hour,
    required int lapanganId,
  }) async {
    var formData = FormData.fromMap({
      "nameVenue": nameVenue,
      "nameLapangan": nameLapangan,
      "days": date,
      "availableHour": hour,
      "unavailableHour": '0',
      "lapanganId": lapanganId,
    }, ListFormat.multiCompatible);

    try {
      final result = await api.post("/timetable",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: formData);
      return ApiResponse(
          result: result.data['data']['lapangan']['hour'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> postEditJadwal({
    required String token,
    required String id,
    required String lapanganId,
    required String nameVenue,
    required String nameLapangan,
    required DateTime date,
    required String availableHour,
    required String unavailableHour,
  }) async {
    var formData = FormData.fromMap({
      "nameVenue": nameVenue,
      "nameLapangan": nameLapangan,
      "days": date,
      "availableHour": availableHour,
      "unavailableHour": unavailableHour,
      "lapanganId": lapanganId,
    }, ListFormat.multiCompatible);

    try {
      final result = await api.post("/timetable/$id?_method=PATCH",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: formData);
      return ApiResponse(
          result: result.data['data']['lapangan']['hour'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<List<BookingModel>>> getBooking(String token) async {
    try {
      final result = await api.get("/booking",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      final List<dynamic> data = result.data['data'];
      final response =
          data.map<BookingModel>((e) => BookingModel.fromJson(e)).toList();
      return ApiResponse(result: response);
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['error'].toString());
    }
  }

  Future<ApiResponse<BookingModel>> getBookingDetail(
      String token, int id) async {
    try {
      final result = await api.get("/booking/$id",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return ApiResponse(result: BookingModel.fromJson(result.data['data']));
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['error'].toString());
    }
  }

  Future<ApiResponse<String>> postBooking(
      {required String token,
      required JadwalLapanganModel jadwal,
      required File img,
      required String name,
      required String hour,
      required String payment}) async {
    var formData = FormData.fromMap({
      "orderName": name,
      "date": jadwal.days,
      "hours": hour,
      "payment": payment,
      "bookingId": jadwal.id,
      "confirmation": "PENDING",
      "ratingStatus": "PENDING",
    }, ListFormat.multiCompatible);

    formData.files.addAll([
      MapEntry(
          "file",
          await MultipartFile.fromFile(img.path,
              filename: img.path.split('/').last)),
    ]);
    try {
      final result = await api.post("/booking",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: formData);
      return ApiResponse(result: result.data['message'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> updateBooking({
    required String token,
    required int id,
    required String confirmation,
  }) async {
    var formData = FormData.fromMap(
        {"confirmation": confirmation}, ListFormat.multiCompatible);
    try {
      final result = await api.post("/booking/$id?_method=PATCH",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: formData);
      return ApiResponse(result: result.data['message'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }

  Future<ApiResponse<String>> updateBookingRating({
    required String token,
    required int id,
  }) async {
    var formData =
        FormData.fromMap({"ratingStatus": "DONE"}, ListFormat.multiCompatible);
    try {
      final result = await api.post("/bookingratingstatus/$id?_method=PATCH",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          data: formData);
      return ApiResponse(result: result.data['message'].toString());
    } on DioException catch (e) {
      return ApiResponse(error: e.response?.data['message'].toString());
    }
  }
}
