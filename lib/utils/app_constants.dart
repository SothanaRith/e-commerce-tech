import 'package:e_commerce_tech/models/language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstants{
  static const String COUNTRY_CODE = "country_code";
  static const String LANGUAGE_CODE = "language_code";

  static List<LanguageModel> language =[
    LanguageModel(imageUrl: "en.png", languageName: "English", languageCode: "en", countryCode: "US"),
    LanguageModel(imageUrl: "kh.png", languageName: "ខ្មែរ", languageCode: "kh", countryCode: "KH"),
    LanguageModel(imageUrl: "ja.png", languageName: "日本", languageCode: "ja", countryCode: "JA"),
  ];
}

class TokenStorage {
  static String? token; // Global variable to store the token

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = "Bearer ${prefs.getString('access_token')}"; // Load token once at app start
  }

  static Future<void> saveToken(String newToken) async {
    token = "Bearer $newToken";
    (await SharedPreferences.getInstance()).setString('access_token', newToken);
  }
}
