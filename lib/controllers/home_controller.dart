import 'dart:convert';
import 'dart:developer';

import 'package:e_commerce_tech/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../helper/rest_api_helper.dart';
import '../utils/app_constants.dart';

class HomeController extends GetxController {
  final String mainPoint = "http://192.168.1.6:6000";
  final apiRepository = ApiRepository();  // instantiate it
  RxList<Category> categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Delay to make sure context is available
    Future.delayed(Duration.zero, () {
      loadHome(context: Get.context!);
      loadCategory(context: Get.context!);
    });
  }

  Future<void> loadHome({required BuildContext context}) async {
    final response = await apiRepository.fetchData(
      "$mainPoint/api/product/get-product/63",
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      log("✅ Product Data: $jsonData"); // using Dart's log() is better for large objects
    } else if (response.error != null) {
      log("❌ Error: ${response.error}");
    }
  }

  Future<void> loadCategory({required BuildContext context}) async {
    final response = await apiRepository.fetchData(
      "$mainPoint/api/category/get-all-categories",
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);

      log("✅ Categories Data: $jsonData");

      // Parse to CategoryResponse
      final categoryResponse = CategoryResponse.fromJson(jsonData);

      // Clear old and add new
      categories.clear();
      categories.addAll(categoryResponse.categories);

      log("✅ Loaded ${categories.length} categories");
    } else if (response.error != null) {
      log("❌ Error: ${response.error}");
    }
  }

}
