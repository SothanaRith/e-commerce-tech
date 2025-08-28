import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/home_controller.dart';
import 'package:e_commerce_tech/controllers/product_controller.dart';
import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/models/wishlist_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/login_page/login_screen.dart';

class WishlistController extends GetxController {
  late final ApiRepository apiRepository;
  bool isLoading = false;
  List<WishlistModel> wishlistData = [];
  final SearchingController searchController = Get.put(SearchingController());
  final HomeController homeController = Get.put(HomeController());
  final ProductController productController = Get.put(ProductController());
  var user = UserStorage.currentUser;
  WishlistController() {
    apiRepository = ApiRepository();
  }

  Future<List<WishlistModel>> getAllWishlist({required BuildContext context, required String userId}) async {
    isLoading = true;
    update();
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

      wishlistData = wishlist;
      isLoading = false;
      update();
      return wishlist;
    } else {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Error: ${response.error}",
      );
      return []; // Return empty list if error
    }
  }

  Future<void> createWishlist({
    required BuildContext context,
    required String userId,
    required String productId,
  }) async {
    if (userId.isEmpty || (user?.id == null)) {
      showCustomDialog(
        context: context,
        type: CustomDialogType.info,
        title: 'Please login to add items to your wishlist',
        okOnPress: () {
          Get.to(() => const LoginScreen());
        },
      );
      return;
    }

    final response = await apiRepository.postData(
      '$mainPoint/api/product/wishlist',
      body: {"userId": userId, "productId": productId},
      headers: {'Content-Type': 'application/json'},
      context: context,
    );

    if (response.data == null) {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }


  Future<void> deleteWishlist(
      {required String productId,
        required String userId,
        required BuildContext context }) async {
    final response = await apiRepository.postData(
        '$mainPoint/api/product/wishlist/delete/$userId/$productId',
        headers: {'Content-Type': 'application/json'}, context: context
    );
    if (response.data != null) {
    } else {
      var jsonData = jsonDecode(response.error!);
      showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "${jsonData["message"]}");
    }
  }
}
