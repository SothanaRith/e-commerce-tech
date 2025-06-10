import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/home_controller.dart';
import 'package:e_commerce_tech/controllers/product_controller.dart';
import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/models/cart_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/global.dart';
import '../helper/rest_api_helper.dart';
import '../widgets/custom_dialog.dart';

class CartController extends GetxController {

  final apiRepository = ApiRepository();
  RxBool isLoadingProducts = false.obs;
  List<CartModel> cartList = [];
  final WishlistController wishlistController = Get.put(WishlistController());
  final SearchingController searchController = Get.put(SearchingController());
  final HomeController homeController = Get.put(HomeController());
  final ProductController productController = Get.put(ProductController());
  Future<List<CartModel>?> fetchAllCart({required BuildContext context, required String userId}) async {
    try {
      isLoadingProducts.value = true;
      update();

      final response = await apiRepository.fetchData(
        '$mainPoint/api/product/cart/$userId',
        headers: {'Content-Type': 'application/json'},
        context: context,
      );

      if (response.data != null) {
        var jsonData = jsonDecode(response.data!);
        print("Fetched Data: $jsonData");

        List<CartModel> carts = (jsonData as List)
            .map((item) => CartModel.fromJson(item))
            .toList();
        cartList = carts;
        update();
        return carts;
      } else {
        showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}",
        );
        throw Exception('Failed to fetch product');
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Unexpected error",
        desc: e.toString(),
      );
    } finally {
      isLoadingProducts.value = false;
      update();
    }
    return null;
  }
  Future<void> addItemToCart(
      {required BuildContext context,
        required String userId,
        required String productId,
        required String quantity,
      }) async {
    final response = await apiRepository.postData(
        '$mainPoint/api/product/cart/add',
        body: {
          "userId": userId,
          "productId": productId,
          "quantity": quantity,
        },
        headers: {'Content-Type': 'application/json'}, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      showCustomDialog(
          context: context,
          type: DialogType.success,
          title: "${jsonData["message"]}",
          okOnPress: () async {
            await fetchAllCart(context: context, userId: UserStorage.currentUser?.id ?? '');
          });
    } else {
      showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}");
    }
  }

  Future<void> removeItemToCart(
      {required String productId,
        required String userId,
        required BuildContext context }) async {
    final response = await apiRepository.postData(
        '$mainPoint/api/product/cart/$userId/$productId/delete',
        headers: {'Content-Type': 'application/json'}, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      showCustomDialog(
          context: context,
          type: DialogType.success,
          title: "${jsonData["message"]}",
          okOnPress: () async {
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
