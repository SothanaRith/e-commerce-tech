import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/models/wishlist_model.dart';
import 'package:e_commerce_tech/screen/verify_code_page/verify_code_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  late final ApiRepository apiRepository;
  bool isLoading = false;

  // late final String mainPoint = "http://192.168.1.6:6000";
  WishlistController() {
    apiRepository = ApiRepository();
  }

  Future<List<WishlistModel>> getAllWishlist({required BuildContext context, required String userId}) async {
    final response = await apiRepository.fetchData(
      '$mainPoint/api/product/wishlist/$userId',
      headers: {
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");

      // Assuming the data is a list of wishlist
      List<WishlistModel> wishlist = (jsonData as List)
          .map((item) => WishlistModel.fromJson(item))
          .toList();

      return wishlist;
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
      return []; // Return empty list if error
    }
  }

  Future<void> createWishlist(
      {required BuildContext context,
        required String userId,
        required String productId,
      }) async {
    final response = await apiRepository.postData(
        '$mainPoint/api/wishlist/create-wishlist',
        body: {
          "userId": userId,
          "productId": productId,
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

  Future<void> deleteWishlist(
      {required String productId,
        required String userId,
        required BuildContext context }) async {
    final response = await apiRepository.postData(
        '$mainPoint/api/wishlist/delete/$userId/$productId',
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
}
