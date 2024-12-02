import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceRepositoryImpl implements SharedPreferenceRepository {
  SharedPreferences? _preferences;

  SharedPreferenceRepositoryImpl({SharedPreferences? prefs})
      : _preferences = prefs;

  Future<SharedPreferences> getPrefs() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!;
  }

  @override
  Future<bool> clearValue(String key) async {
    final prefs = await getPrefs();
    return await prefs.remove(key);
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getPrefs();
    dynamic value;

    try {
      value = prefs.getBool(key.toString());
      if (value != null) {
        return value;
      }
    } catch (_) {}

    try {
      value = prefs.getString(key.toString());
      if (value != null) {
        return value;
      }
    } catch (_) {}

    try {
      value = prefs.getInt(key.toString());
      if (value != null) {
        return value;
      }
    } catch (_) {}

    try {
      value = prefs.getDouble(key.toString());
      if (value != null) {
        return value;
      }
    } catch (_) {}

    try {
      value = prefs.getStringList(key.toString());
      if (value != null) {
        return value;
      }
    } catch (_) {}

    return null;
  }

  @override
  Future<bool> setValue<T>(String key, T value) async {
    final prefs = await getPrefs();
    if (value is String) {
      return await prefs.setString(key.toString(), value);
    } else if (value is double) {
      return await prefs.setDouble(key.toString(), value);
    } else if (value is bool) {
      return await prefs.setBool(key.toString(), value);
    } else if (value is int) {
      return await prefs.setInt(key.toString(), value);
    } else if (value is List<String>) {
      return await prefs.setStringList(key.toString(), value);
    } else if (value is Map<String, dynamic>) {
      return await prefs.setString(key.toString(), jsonEncode(value));
    } else {
      throw "Unsupported type";
    }
  }
}

abstract class SharedPreferenceRepository {
  Future<T?> getValue<T>(String key);

  Future<bool> clearValue(String key);

  Future<bool> setValue<T>(String key, T value);
}
