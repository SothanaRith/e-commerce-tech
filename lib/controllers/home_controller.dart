import 'dart:convert';
import 'dart:developer';

import 'package:e_commerce_tech/models/category_model.dart';
import 'package:e_commerce_tech/models/home_model.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../helper/rest_api_helper.dart';
import '../utils/app_constants.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final String mainPoint = "http://192.168.1.2:6000";
  final apiRepository = ApiRepository();

  int currentPage = 1;
  final int pageSize = 10;

  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;

  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<ProductModel> products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      loadHome(page: currentPage, context: Get.context!);
      // loadCategory(context: Get.context!);

      scrollController.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          if (!isLoading.value && hasMore.value) {
            currentPage++;
            loadHome(page: currentPage, context: Get.context!);
          }
        }
      });
    });
  }

  Future<void> loadHome({required int page, required BuildContext context}) async {
    isLoading.value = true;

    final response = await apiRepository.fetchData(
      "$mainPoint/api/home/loadHome?page=$page&size=$pageSize",
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      final homeResponse = HomeModel.fromJson(jsonData['data']);

      if (page == 1) {
        products.assignAll(homeResponse.products);
      } else {
        if (homeResponse.products.isEmpty) {
          hasMore.value = false;
        } else {
          products.addAll(homeResponse.products);
        }
      }

      if (categories.isEmpty) {
        categories.addAll(homeResponse.categories);
      }
    } else {
      hasMore.value = false;
    }

    isLoading.value = false;
  }

  // Future<void> loadCategory({required BuildContext context}) async {
  //   final response = await apiRepository.fetchData(
  //     "$mainPoint/api/category/get-all-categories",
  //     headers: {
  //       'Authorization': TokenStorage.token ?? "",
  //       'Content-Type': 'application/json',
  //     },
  //     context: context,
  //   );
  //
  //   if (response.data != null) {
  //     final categoryResponse = CategoryResponse.fromJson(jsonDecode(response.data!));
  //     categories.assignAll(categoryResponse.categories);
  //   }
  // }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

