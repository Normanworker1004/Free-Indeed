import 'dart:core';

import 'package:free_indeed/configs/base.bloc.dart';

abstract class LocalDataManager {
  Future<bool> writeData(CachingKey key, dynamic value);

  Future<bool> removeData(CachingKey key);

  String readString(CachingKey key);

  int readInteger(CachingKey key);

  bool readBoolean(CachingKey key);

  double readDouble(CachingKey key);
}

class CachingKey extends Enum<String> {
  const CachingKey(String val) : super(val);
  static const CachingKey APP_LANGUAGE = CachingKey('APP_LANGUAGE');
  static const CachingKey OLD_USER = CachingKey('OLD_USER');
  static const CachingKey ACCESS_TOKEN = CachingKey('ACCESS_TOKEN');
  static const CachingKey REFRESH_TOKEN = CachingKey('REFRESH_TOKEN');
  static const CachingKey ID_TOKEN = CachingKey('ID_TOKEN');
  static const CachingKey LAST_TOKEN_UPDATE = CachingKey('LAST_TOKEN_UPDATE');
  static const CachingKey USERNAME = CachingKey('USERNAME');
  static const CachingKey EMAIL = CachingKey('EMAIL');
  static const CachingKey FIREBASE_ID = CachingKey('FIREBASE_ID');
  static const CachingKey FRIEND_ID = CachingKey('FRIEND_ID');
  static const CachingKey FRIEND_DISPLAY_NAME =
      CachingKey('FRIEND_DISPLAY_NAME');
  static const CachingKey USER_NAME = CachingKey('USER_NAME');
  static const CachingKey USER_COGNITO_ID = CachingKey('USER_COGNITO_ID');
  static const CachingKey USER_ID = CachingKey('USER_ID');
  static const CachingKey IS_USER_SUBSCRIBED = CachingKey('IS_USER_SUBSCRIBED');
  static const CachingKey IS_USER_HAS_NOTIFICATIONS =
      CachingKey('IS_USER_HAS_NOTIFICATIONS');
  static const CachingKey TEMP_PASSWORD = CachingKey('TEMP_PASSWORD');
}
