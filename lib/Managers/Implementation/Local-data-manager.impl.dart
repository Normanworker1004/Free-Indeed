import 'dart:async';

import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataManagerImpl implements LocalDataManager {
  static late SharedPreferences _sharedPreferencesInstance;

  static Future<SharedPreferences> get _instance async =>
      _sharedPreferencesInstance = await SharedPreferences.getInstance();

  static Future<SharedPreferences> init() async {
    _sharedPreferencesInstance = await _instance;
    return _sharedPreferencesInstance;
  }

  @override
  Future<bool> removeData(CachingKey key) {
    return _sharedPreferencesInstance.remove(key.value);
  }

  @override
  Future<bool> writeData(CachingKey key, value) {
    print(
        "saving this value $value into local preference with key ${key.value}");
    Future returnedValue;
    if (value is String) {
      returnedValue = _sharedPreferencesInstance.setString(key.value, value);
    } else if (value is int) {
      returnedValue = _sharedPreferencesInstance.setInt(key.value, value);
    } else if (value is bool) {
      returnedValue = _sharedPreferencesInstance.setBool(key.value, value);
    } else if (value is double) {
      returnedValue = _sharedPreferencesInstance.setDouble(key.value, value);
    } else {
      return Future.error(NotValidCacheTypeException());
    }
    return returnedValue as Future<bool>;
  }

  @override
  bool readBoolean(CachingKey key) {
    return _sharedPreferencesInstance.getBool(key.value) ?? false;
  }

  @override
  double readDouble(CachingKey key) {
    return _sharedPreferencesInstance.getDouble(key.value) ?? 0.0;
  }

  @override
  int readInteger(CachingKey key) {
    return _sharedPreferencesInstance.getInt(key.value) ?? 0;
  }

  @override
  String readString(CachingKey key) {
    return _sharedPreferencesInstance.getString(key.value) ?? "";
  }
}

class NotValidCacheTypeException implements Exception {
  String message() => "Not a valid caching type";
}
