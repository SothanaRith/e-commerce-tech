import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/screen/forget_password_page/reset_password_screen.dart';
import 'package:e_commerce_tech/screen/home_page/home_screen.dart';
import 'package:e_commerce_tech/screen/location_page/location_screen.dart';
import 'package:e_commerce_tech/screen/login_page/login_screen.dart';
import 'package:e_commerce_tech/screen/verify_code_page/verify_code_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  late final ApiRepository apiRepository;

  // late final String mainPoint = "http://192.168.1.6:6000";
  AuthController() {
    apiRepository = ApiRepository();
  }

  Future<void> getUser({required BuildContext context}) async {
    final response = await apiRepository.fetchData(
      '$mainPoint/api/users/getProfile',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      }, context: context,
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> signup(
      {required String name,
      required String email,
      required String password,
      required String phone,
      required String role,
      required BuildContext context}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/register',
      body: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "role": role
      },
      headers: {'Content-Type': 'application/json'}, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      TokenStorage.saveToken(jsonData["accessToken"]).then(
        (value) {
          showCustomDialog(
              context: context,
              type: DialogType.success,
              title: "${jsonData["message"]}",
              okOnPress: () {
                goOff(
                    this,
                    OtpScreen(
                      type: ScreenVerifyType.signup,
                    ));
              });
        },
      );
    } else {
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/login',
      body: {"email": email, "password": password},
      headers: {'Content-Type': 'application/json'}, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      TokenStorage.saveToken(jsonData["accessToken"]).then(
        (value) {
          showCustomDialog(
              context: context,
              type: DialogType.success,
              title: "${jsonData["message"]}",
              okOnPress: () {
                goOff(
                    this,
                    OtpScreen(
                      type: ScreenVerifyType.signinPhoneNumber,
                    ));
              });
        },
      );
    } else {
      var jsonData = jsonDecode(response.error!);
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "${jsonData["message"]}");
    }
  }

  Future<void> checkMail(
      {required String email, required BuildContext context}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/check-mail',
      body: {"email": email},
      headers: {'Content-Type': 'application/json'}, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print(jsonData["accessToken"]);
      if (jsonData["accessToken"] == "") {

      }
      TokenStorage.saveToken(jsonData["accessToken"]).then(
        (value) {
          showCustomDialog(
              context: context,
              type: DialogType.success,
              title: "${jsonData["message"]}",
              okOnPress: () {
                goOff(
                    this,
                    OtpScreen(
                      type: ScreenVerifyType.forgetPassword,
                    ));
              });
        },
      );
    } else {
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> verifyOTP(
      {required String otp,
      required ScreenVerifyType type,
      required BuildContext context}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/verify-otp',
      body: {"otp": otp},
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      }, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      TokenStorage.saveToken(jsonData["accessToken"]).then(
        (value) async {
          if (type == ScreenVerifyType.signup) {
            showCustomDialog(
                context: context,
                type: DialogType.success,
                title: "${jsonData["message"]}",
                okOnPress: () {
                  goOff(this, LocationScreen());
                });
          } else if (type == ScreenVerifyType.signinPhoneNumber) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            showCustomDialog(
                context: context,
                type: DialogType.success,
                title: "${jsonData["message"]}",
                okOnPress: () {
                  goOff(this, HomeScreen());
                });
          } else if (type == ScreenVerifyType.forgetPassword) {
            showCustomDialog(
                context: context,
                type: DialogType.success,
                title: "${jsonData["message"]}",
                okOnPress: () {
                  goOff(this, ResetPasswordScreen());
                });
          }
        },
      );
    } else {
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> sendOTP({required BuildContext context}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/send-otp',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      }, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> resetPassword(
      {required String newPassword,
      required BuildContext context}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/reset-password',
      body: {"newPassword": newPassword},
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      }, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      showCustomDialog(
          context: context,
          type: DialogType.success,
          title: "${jsonData["message"]}",
          okOnPress: () {
            goOff(this, LoginScreen());
          });
    } else {
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}");
    }
  }
}
