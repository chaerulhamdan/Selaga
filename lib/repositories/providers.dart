import 'package:flutter/material.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';

class Token with ChangeNotifier {
  String _token = '';

  String get token => _token;

  void getToken(String token) {
    _token = token;
    notifyListeners();
  }
}

class UserId with ChangeNotifier {
  int _id = 0;

  int get id => _id;

  void getUserId(int id) {
    _id = id;
    notifyListeners();
  }
}

class MyVenue with ChangeNotifier {
  final List<VenueModel> _venue = [];

  List<VenueModel> get venue => _venue;

  void add(List<VenueModel> venue, int id) {
    venue = _venue.where((e) => e.mitraId == id).toList();
    notifyListeners();
  }
}

class SelectedDate with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void getSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

class LapanganId with ChangeNotifier {
  int _id = 0;

  int get id => _id;

  void getLapanganId(int id) {
    _id = id;
    notifyListeners();
  }
}

class BookingId with ChangeNotifier {
  int _id = 0;

  int get id => _id;

  void updateBookingId(int id) {
    _id = id;
    notifyListeners();
  }
}

class HourAvailable with ChangeNotifier {
  final List<String> _hour = [];

  List<String> get hour => _hour;

  void add(List<String> hour) {
    List<int> tempHour = [];
    for (var e in hour) {
      tempHour.add(int.parse(e));
    }
    tempHour.sort();
    for (var e in tempHour) {
      _hour.add(e.toString());
    }
    notifyListeners();
  }

  void clear() {
    _hour.clear();
    notifyListeners();
  }
}

class HourUnAvailable with ChangeNotifier {
  final List<String> _hour = [];

  List<String> get hour => _hour;

  void add(List<String> hour) {
    List<int> tempHour = [];
    for (var e in hour) {
      tempHour.add(int.parse(e));
    }
    tempHour.sort();
    for (var e in tempHour) {
      _hour.add(e.toString());
    }
    notifyListeners();
  }

  void clear() {
    _hour.clear();
    notifyListeners();
  }
}

class SelectedHour with ChangeNotifier {
  final List<String> _selectedHour = [];

  List<String> get selectedHour => _selectedHour;

  void add(List<String> hour) {
    List<int> tempHour = [];
    for (var e in hour) {
      tempHour.add(int.parse(e));
    }
    tempHour.sort();
    for (var e in tempHour) {
      _selectedHour.add(e.toString());
    }
    notifyListeners();
  }

  void clear() {
    _selectedHour.clear();
    notifyListeners();
  }
}

class PaymentMethod with ChangeNotifier {
  String _payment = 'no payment';

  String get getPayment => _payment;

  void update(String payment) {
    _payment = payment;
    notifyListeners();
  }
}

class OrderName with ChangeNotifier {
  String _name = 'no name';

  String get getOrdername => _name;

  void update(String name) {
    _name = name;
    notifyListeners();
  }
}
