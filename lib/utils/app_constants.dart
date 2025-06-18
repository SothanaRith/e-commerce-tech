import 'dart:convert';

import 'package:e_commerce_tech/models/cart_model.dart';
import 'package:e_commerce_tech/models/language_model.dart';
import 'package:e_commerce_tech/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstants{
  static const String COUNTRY_CODE = "country_code";
  static const String LANGUAGE_CODE = "language_code";

  static List<LanguageModel> language =[
    LanguageModel(imageUrl: "en.png", languageName: "English", languageCode: "en", countryCode: "US"),
    LanguageModel(imageUrl: "kh.png", languageName: "ខ្មែរ", languageCode: "kh", countryCode: "KH"),
    LanguageModel(imageUrl: "cn.png", languageName: "中文", languageCode: "zh", countryCode: "ZH"),
    LanguageModel(imageUrl: "fr.png", languageName: "Français", languageCode: "fr", countryCode: "FR"),
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

class PaymentStorage {

  static String? qrCode;
  static String? md5;
  static bool? isPaymentCompleted;

  static List<String>? listProductId;
  static List<String>? quantity;
  static String? paymentType;
  static String? addressId;
  static String? billingNumber;


  static Future<void> loadCheckPayment() async {
    final prefs = await SharedPreferences.getInstance();
    qrCode = prefs.getString('qr_code');
    md5 = prefs.getString('md5');
    isPaymentCompleted = prefs.getBool('is_payment_completed');

    paymentType = prefs.getString('payment_type');
    listProductId = prefs.getStringList('list_product_id');
    quantity = prefs.getStringList('quantity');
    addressId = prefs.getString('address_id');
    billingNumber = prefs.getString('billing_number');
  }

  static Future<void> clearCheckPayment() async {
    qrCode = null;
    md5 = null;
    isPaymentCompleted = null;

    paymentType = null;
    listProductId = null;
    quantity = null;
    addressId = null;
    billingNumber = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('qr_code');
    await prefs.remove('md5');
    await prefs.remove('is_payment_completed');

    await prefs.remove('payment_type');
    await prefs.remove('list_product_id');
    await prefs.remove('quantity');
    await prefs.remove('address_id');
    await prefs.remove('billing_number');

  }

  static Future<void> saveQrCode(String newQR) async {
    qrCode = newQR;
    (await SharedPreferences.getInstance()).setString('qr_code', newQR);
  }

  static Future<void> saveMd5(String NewMd5) async {
    md5 = NewMd5;
    (await SharedPreferences.getInstance()).setString('md5', NewMd5);
  }

  static Future<void> saveIsPaymentCompleted(bool isCompleted) async {
    isPaymentCompleted = isCompleted;
    (await SharedPreferences.getInstance()).setBool('is_payment_completed', isCompleted);
  }

  static Future<void> savePaymentType(String NewPaymentType) async {
    paymentType = NewPaymentType;
    (await SharedPreferences.getInstance()).setString('payment_type', NewPaymentType);
  }

  static Future<void> saveListProductId(List<String> NewListProductId) async {
    listProductId = NewListProductId;
    (await SharedPreferences.getInstance()).setStringList('list_product_id', NewListProductId);
  }

  static Future<void> saveListQuantity(List<String> newListQuantity) async {
    quantity = newListQuantity;
    (await SharedPreferences.getInstance()).setStringList('quantity', newListQuantity);
  }

  static Future<void> saveAddressId(String NewAddressId) async {
    addressId = NewAddressId;
    (await SharedPreferences.getInstance()).setString('address_id', NewAddressId);
  }

  static Future<void> saveBillingNumber(String NewBillingNumber) async {
    billingNumber = NewBillingNumber;
    (await SharedPreferences.getInstance()).setString('billing_number', NewBillingNumber);
  }

  static Future<List<String>> convertListProductId (List<CartModel> items) async {
    List<String> listProductId = [];
    for (CartModel item in items) {
      listProductId.add(item.productId ?? '');
    }
    return listProductId;
  }

  static Future<List<String>> convertListQuantity (List<CartModel> items) async {
    List<String> listQuantity = [];
    for (CartModel item in items) {
      listQuantity.add(item.quantity ?? "0");
    }
    return listQuantity;
  }

  static Future<void> saveOrder({required String newBillingNumber, required String newAddressId, required List<CartModel> items, required String newPaymentType}) async {

    await saveBillingNumber(newBillingNumber);
    await saveAddressId(newAddressId);

    List<String> listProductId = await convertListProductId(items);
    List<String> listQuantity = await convertListQuantity(items);

    await saveListProductId(listProductId);
    await saveListQuantity(listQuantity);
    await savePaymentType(newPaymentType);
    await loadCheckPayment();
  }

  static Future<void> savePayment({required String qrCode, required String md5, required bool isPaymentCompleted}) async {
    await saveQrCode(qrCode);
    await saveMd5(md5);
    await saveIsPaymentCompleted(isPaymentCompleted);
    await loadCheckPayment();
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
      'coverImage': user.coverImage,
      'role': user.role,
      'status': user.status,
      'createdAt': user.createdAt,
      'updatedAt': user.updatedAt,
    };
  }
}