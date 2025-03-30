import 'dart:convert';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/screen/location_page/location_screen.dart';
import 'package:e_commerce_tech/screen/verify_code_page/verify_code_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late final ApiRepository apiRepository;

  late final String mainPoint = "https://3f79-58-97-220-188.ngrok-free.app";
  AuthController() {
    apiRepository = ApiRepository();
  }

  Future<void> getUser() async {
    final response = await apiRepository.fetchData(
      '$mainPoint/api/users/getProfile',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      },
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      print('Error: ${response.error}');
    }
  }

  Future<void> signup(
      {required String name,
      required String email,
      required String password,
      required String phone,
      required String role}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/register',
      body: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "role": role
      },
      headers: {'Content-Type': 'application/json'},
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      TokenStorage.saveToken(jsonData["accessToken"]).then(
        (value) {
          goOff(this, OtpScreen());
        },
      );
    } else {
      print('Error: ${response.error}');
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/login',
      body: {"email": email, "password": password},
      headers: {'Content-Type': 'application/json'},
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      TokenStorage.saveToken(jsonData["accessToken"]).then(
        (value) {
          goOff(this, OtpScreen());
        },
      );
    } else {
      print('Error: ${response.error}');
    }
  }

  Future<void> verifyOTP({required String otp}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/verify-otp',
      body: {"otp": otp},
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      },
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      TokenStorage.saveToken(jsonData["accessToken"]).then(
        (value) {
          goOff(this, LocationScreen());
        },
      );
    } else {
      print('Error: ${response.error}');
    }
  }

  Future<void> sendOTP() async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/send-otp',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      },
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      print('Error: ${response.error}');
    }
  }

  Future<void> resentPassword(
      {required String email, required String newPassword}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/reset-password',
      body: {"email": email, "newPassword": newPassword},
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      },
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      print('Error: ${response.error}');
    }
  }
}
