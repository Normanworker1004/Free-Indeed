import 'package:free_indeed/configs/base.bloc.dart';

class AppLanguage extends Enum<String> {
  final String symbol;
  final String name;
  final String code;

  const AppLanguage({required this.symbol,required  this.name,required  this.code}) : super(code);

  static const AppLanguage ENGLISH =
      AppLanguage(symbol: 'A', name: 'English', code: 'en');
  static const AppLanguage ARABIC =
      AppLanguage(symbol: 'ض', name: 'العربية', code: 'ar');

  static List<AppLanguage> supportedAppLanguageList = [ENGLISH, ARABIC];
}
