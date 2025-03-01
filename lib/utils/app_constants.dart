import 'package:e_commerce_tech/models/language_model.dart';

class AppConstants{
  static const String COUNTRY_CODE = "country_code";
  static const String LANGUAGE_CODE = "language_code";

  static List<LanguageModel> language =[
    LanguageModel(imageUrl: "en.png", languageName: "English", languageCode: "en", countryCode: "US"),
    LanguageModel(imageUrl: "kh.png", languageName: "ខ្មែរ", languageCode: "kh", countryCode: "KH"),
    LanguageModel(imageUrl: "ja.png", languageName: "日本", languageCode: "ja", countryCode: "JA"),
  ];
}