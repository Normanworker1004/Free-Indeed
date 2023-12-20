import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/configs/app_language.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FreeIndeedAppModel extends Model {
  Locale _appLocale = Locale(AppLanguage.ENGLISH.code);

  Locale get appLocal => _appLocale;

  FreeIndeedAppModel() {
    String appLanguage =
        LocalDataManagerImpl().readString(CachingKey.APP_LANGUAGE);
    if (appLanguage.isEmpty) {
      appLanguage = AppLanguage.ENGLISH.code;
    }
    _appLocale = Locale(appLanguage, '');
    notifyListeners();
  }

  void changeAppLanguage({required String languageCode}) async {
    await LocalDataManagerImpl()
        .writeData(CachingKey.APP_LANGUAGE, languageCode);
    _appLocale = Locale(languageCode, '');
    notifyListeners();
  }
}
