import 'dart:ui';

import 'package:get/get.dart';
import 'package:e_commerce_tech/models/language_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxController implements GetxService{
  final SharedPreferences sharedPreferences;
  LocalizationController({required this.sharedPreferences}){
    loadCurrentLanguage();
  }
  int selectedIndex = 0;
  Locale _locale = Locale(AppConstants.language[0].countryCode);
  List<LanguageModel> _language = [];
  Locale get locale => _locale;
  List<LanguageModel> get language => _language;

  void loadCurrentLanguage() async{
    _locale = Locale(sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ??
        AppConstants.language[0].languageCode,sharedPreferences.getString(AppConstants.COUNTRY_CODE) ??
        AppConstants.language[0].countryCode);
  for(int index = 0; index < AppConstants.language.length; index++){
    if(AppConstants.language[index].languageCode == _locale.languageCode){
      selectedIndex = index;
      break;
    }
  }
  _language = [];
  _language.addAll(AppConstants.language);
  update();
}
void setSelectIndex(int index){
  selectedIndex = index;
  update();
}
  void setLanguage(Locale locale){
    Get.updateLocale(locale);
    _locale = locale;
    saveLanguage(_locale);
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.LANGUAGE_CODE, locale.languageCode);
    sharedPreferences.setString(AppConstants.COUNTRY_CODE, locale.countryCode!);

  }
}
