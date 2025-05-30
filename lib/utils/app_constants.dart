import 'dart:convert';

import 'package:e_commerce_tech/models/language_model.dart';
import 'package:e_commerce_tech/models/user_model.dart';
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

  static Future<void> clearToken() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  static Future<void> saveToken(String newToken) async {
    token = "Bearer $newToken";
    (await SharedPreferences.getInstance()).setString('access_token', newToken);
  }
}

class UserStorage {
  static User? currentUser;

  static Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      final Map<String, dynamic> parsed = jsonDecode(userJson);
      currentUser = User.fromJson(parsed);
    }
  }

  static Future<void> saveUser(User user) async {
    currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(_userToJson(user)));
  }

  static Future<void> clearUser() async {
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }

  static Map<String, dynamic> _userToJson(User user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'isVerify': user.isVerify,
      'isMuted': user.isMuted,
      'hasStory': user.hasStory,
      'isFriend': user.isFriend,
      'isFollowing': user.isFollowing,
      'isFollower': user.isFollower,
      'isBlock': user.isBlock,
      'phone': user.phone,
      'role': user.role,
      'status': user.status,
      'createdAt': user.createdAt,
      'updatedAt': user.updatedAt,
    };
  }
}