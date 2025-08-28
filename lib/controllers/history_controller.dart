import 'dart:convert';
import 'dart:ffi';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/home_controller.dart';
import 'package:e_commerce_tech/controllers/product_controller.dart';
import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/models/cart_model.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/models/user_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/global.dart';
import '../helper/rest_api_helper.dart';
import '../widgets/custom_dialog.dart';

class HistoryController extends GetxController {

  bool isLoading = false;
  final apiRepository = ApiRepository();
  List<ProductModel> historyProducts = [];

  Future<void> postUserVisitProduct({required BuildContext context, required int productId}) async {
    try {
      isLoading = true;
      update();

      final response = await apiRepository.postData(
        '$mainPoint/api/history/product-visit',
        headers: {'Content-Type': 'application/json'},
        body: {
          "userId": UserStorage.currentUser?.id,
          "productId": productId
        },
        context: context,
      );

      if (response.data != null) {
        var jsonData = jsonDecode(response.data!);

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
      isLoading = false;
      update();
    }
  }

  Future<void> postUserSearchHistory({required BuildContext context, required int query}) async {
    try {
      isLoading = true;
      update();

      final response = await apiRepository.postData(
        '$mainPoint/api/history/search',
        headers: {'Content-Type': 'application/json'},
        body: {
          "userId": UserStorage.currentUser?.id,
          "query": query
        },
        context: context,
      );

      if (response.data != null) {
        var jsonData = jsonDecode(response.data!);

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
      isLoading = false;
      update();
    }
  }

  Future<void> fetchVisitHistoryByUser({required BuildContext context}) async {
    try {
      isLoading = true;
      update();

      final response = await apiRepository.fetchData(
        '$mainPoint/api/history/product-visit/${UserStorage.currentUser?.id}',
        headers: {'Content-Type': 'application/json'},
        context: context,
      );

      if (response.data != null) {
        var jsonData = jsonDecode(response.data!);
        print("Fetched Data: ${jsonData['history']}");

        // Convert JSON list into ProductModel list
        final history = (jsonData["history"] as List)
            .map((item) => ProductModel.fromJson(item['product']))
            .toList();

        print("Fetched Data:2 ${history[0].name}");

        historyProducts = history;

        update();
      } else {
        showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "${response.error}",
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
      isLoading = false;
      update();
    }
    return null;
  }

  Future<void> fetchSearchHistory({required BuildContext context}) async {
    try {
      isLoading = true;
      update();

      final response = await apiRepository.fetchData(
        '$mainPoint/api/history/search-history/${UserStorage.currentUser?.id}',
        headers: {'Content-Type': 'application/json'},
        context: context,
      );

      if (response.data != null) {
        var jsonData = jsonDecode(response.data!);
        print("Fetched Data: $jsonData");

        update();
      } else {
        showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "${response.error}",
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
      isLoading = false;
      update();
    }
    return null;
  }
}
