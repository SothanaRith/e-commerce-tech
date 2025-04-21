import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/screen/location_page/location_screen.dart';
import 'package:e_commerce_tech/screen/verify_code_page/verify_code_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late final ApiRepository apiRepository;

  late final String mainPoint = "http://localhost:3000";
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
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}");
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
        (value) {
          if (type == ScreenVerifyType.signup) {
            showCustomDialog(
                context: context,
                type: DialogType.success,
                title: "${jsonData["message"]}",
                okOnPress: () {
                  goOff(this, LocationScreen());
                });
          } else if (type == ScreenVerifyType.signinPhoneNumber) {
            showCustomDialog(
                context: context,
                type: DialogType.success,
                title: "${jsonData["message"]}",
                okOnPress: () {
                  goOff(this, LocationScreen());
                });
          } else if (type == ScreenVerifyType.forgetPassword) {}
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

  Future<void> resentPassword(
      {required String email,
      required String newPassword,
      required BuildContext context}) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/auth/reset-password',
      body: {"email": email, "newPassword": newPassword},
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
}
