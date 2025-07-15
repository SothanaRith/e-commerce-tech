import 'dart:convert';
import 'dart:ffi';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/home_controller.dart';
import 'package:e_commerce_tech/controllers/product_controller.dart';
import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/models/cart_model.dart';
import 'package:e_commerce_tech/models/product_model.dart';
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
  int totalItemsInCart = 0;
  int dialogQuantity = 1;
  Variants? selectedVariant;
  final WishlistController wishlistController = Get.put(WishlistController());
  final SearchingController searchController = Get.put(SearchingController());
  final HomeController homeController = Get.put(HomeController());
  final ProductController productController = Get.put(ProductController());

  Future<void> fetchTotalItemsInCart({required BuildContext context}) async {
    try {
      isLoadingProducts.value = true;
      update();

      final response = await apiRepository.fetchData(
        '$mainPoint/api/product/cart/total-items/${UserStorage.currentUser?.id}',
        headers: {'Content-Type': 'application/json'},
        context: context,
      );

      if (response.data != null) {
        var jsonData = jsonDecode(response.data!);
        totalItemsInCart = jsonData["totalItems"];
      } else {
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Unexpected error",
        desc: e.toString(),
      );
    } finally {
      isLoadingProducts.value = false;
      update();
    }
  }

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
          type: CustomDialogType.error,
          title: "Error: ${response.error}",
        );
        throw Exception('Failed to fetch product');
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
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
        required Variants variant,
        required String productId,
        required String quantity,
      }) async {

    if (int.parse(variant.stock ?? "0") < int.parse(quantity)) {
      showCustomDialog(
          context: context,
          type: CustomDialogType.info,
          title: "product is out of stock or have no enough",
          okOnPress: () async {
          });
      return;
    }
    final response = await apiRepository.postData(
        '$mainPoint/api/product/cart/add',
        body: {
          "userId": userId,
          "productId": productId,
          "variantId": variant.id,
          "quantity": quantity,
        },
        headers: {'Content-Type': 'application/json'}, context: context
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      showCustomDialog(
          context: context,
          type: CustomDialogType.success,
          title: "${jsonData["message"]}",
          okOnPress: () async {
            await fetchAllCart(context: context, userId: UserStorage.currentUser?.id ?? '');
          });
    } else {
      showCustomDialog(
          context: context,
          type: CustomDialogType.error,
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
          type: CustomDialogType.success,
          title: "${jsonData["message"]}",
          okOnPress: () async {
            fetchAllCart(context: context, userId: UserStorage.currentUser?.id ?? '');
          });
    } else {
      var jsonData = jsonDecode(response.error!);
      showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "${jsonData["message"]}");
    }
  }

}
