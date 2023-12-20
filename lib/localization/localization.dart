
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  Locale _locale;
  static Map<String, Map<dynamic, dynamic>?> _localizationValue =
      <String, Map?>{};
  static TextDirection? layoutDirection;

  String get currentLanguage => _locale.languageCode;

  Locale get currentLocale => _locale;

  AppLocalization._internal(this._locale);

  String getLocalizedText(String? key, [Locale? locale]) {
    locale = locale ?? _locale;
    if (_localizationValue[locale.languageCode] != null) {
      return _localizationValue[locale.languageCode]![key] ??
          '** $key not found';
    }
    return "";
  }

  static Future<AppLocalization> load(Locale locale, String? localAssetsPath,
      List<String> supportedLanguageList) async {
    AppLocalization appLocalization = AppLocalization._internal(locale);
    await loadLocalizationForSupportedLanguage(
        localAssetsPath, supportedLanguageList);
    _setLayoutDirection(locale);
    return appLocalization;
  }

  static Future<void> loadLocalizationForSupportedLanguage(
      String? localAssetsPath, List<String> supportedLanguageList) async {
    for (String supportedLanguage in supportedLanguageList) {
      String jsonLocalizedValues = await rootBundle
          .loadString(localAssetsPath! + "$supportedLanguage.json");
      _localizationValue[supportedLanguage] = json.decode(jsonLocalizedValues);
    }
  }

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static void _setLayoutDirection(Locale locale) {
    if (locale.languageCode == 'ar') {
      layoutDirection = TextDirection.rtl;
    } else {
      layoutDirection = TextDirection.ltr;
    }
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  String? localizationPath;
  List<String>? supportedLanguages;

  AppLocalizationDelegate({this.localizationPath, this.supportedLanguages});

  @override
  bool isSupported(Locale locale) =>
      supportedLanguages!.contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) =>
      AppLocalization.load(locale, localizationPath, supportedLanguages!);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
