import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/screen/forget_password_page/reset_password_screen.dart';
import 'package:e_commerce_tech/screen/home_page/home_screen.dart';
import 'package:e_commerce_tech/screen/location_page/location_screen.dart';
import 'package:e_commerce_tech/screen/verify_code_page/verify_code_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  late final ApiRepository apiRepository;
  bool isLoading = false;

  late final String mainPoint = "http://localhost:3000";
  // late final String mainPoint = "http://192.168.1.6:6000";
  ProductController() {
    apiRepository = ApiRepository();
  }

  Future<List<ProductModel>> getAllProduct({required BuildContext context}) async {
    final response = await apiRepository.fetchData(
      '$mainPoint/api/product/get-all',
      headers: {
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");

      // Assuming the data is a list of products
      List<ProductModel> products = (jsonData as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();

      return products;
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
      return []; // Return empty list if error
    }
  }

  Future<ProductModel> getProductById({
    required BuildContext context,
    required String id,
  }) async {
    isLoading = true;
    update();
    final response = await apiRepository.fetchData(
      '$mainPoint/api/product/get-product/$id',
      headers: {
        'Content-Type': 'application/json',
      },
      context: context,
    );

    isLoading = false;
    update();
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");

      // Convert JSON to ProductModel
      ProductModel product = ProductModel.fromJson(jsonData);
      return product;
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
      // Optionally throw or return a default
      throw Exception('Failed to fetch product');
    }
  }

  Future<void> createProduct(
      {required String categoryId,
        required String name,
        required String description,
        required String price,
        required List<String> images,
        required List<String> review,
        required List<String> variants,
        required BuildContext context}) async {
    final response = await apiRepository.postData(
        '$mainPoint/api/product/create-product',
        body: {
          "categoryId": categoryId,
          "name": name,
          "description": description,
          "price": price,
          "images": images,
          "review": review,
          "variants": variants
        },
        headers: {'Content-Type': 'application/json'}, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      showCustomDialog(
          context: context,
          type: DialogType.success,
          title: "${jsonData["message"]}",
          okOnPress: () {

          });
    } else {
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> deleteProduct(
      {required String productId,
        required BuildContext context}) async {
    final response = await apiRepository.postData(
        '$mainPoint/api/product/delete/${productId}',
        headers: {'Content-Type': 'application/json'}, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
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
    } else {
      var jsonData = jsonDecode(response.error!);
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "${jsonData["message"]}");
    }
  }


  Future<void> updateProduct(
      { required String productId,
        required String categoryId,
        required String name,
        required String description,
        required String price,
        required List<String> images,
        required List<String> review,
        required List<String> variants,
        required BuildContext context}) async {
    final response = await apiRepository.postData(
        '$mainPoint/api/product/update-product/${productId}',
        body: {
          "categoryId": categoryId,
          "name": name,
          "description": description,
          "price": price,
          "images": images,
          "review": review,
          "variants": variants
        },
        headers: {'Content-Type': 'application/json'}, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      showCustomDialog(
          context: context,
          type: DialogType.success,
          title: "${jsonData["message"]}",
          okOnPress: () {

          });
    } else {
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> checkOut(
      {required String otp,
        required ScreenVerifyType type,
        required BuildContext context}) async {
    final response = await apiRepository.postData(
        '$mainPoint/api/product/verify-otp',
        body: {"otp": otp},
        headers: {
          'Productorization': TokenStorage.token ?? "",
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
}
