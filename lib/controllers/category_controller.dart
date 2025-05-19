import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/global.dart';
import '../helper/rest_api_helper.dart';
import '../models/product_by_category.dart';
import '../models/product_model.dart';
import '../widgets/custom_dialog.dart';

class CategoryController extends GetxController {
  final String categoryId;
  final BuildContext context;

  CategoryController({required this.categoryId, required this.context});

  final apiRepository = ApiRepository();
  RxList<ProductModel> productByCategories = <ProductModel>[].obs;
  RxBool isLoadingProducts = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, listProByCategory); // Safe async call after init
  }

  Future<void> listProByCategory() async {
    try {
      isLoadingProducts.value = true;

      final response = await apiRepository.fetchData(
        '$mainPoint/api/category/categories/$categoryId',
        headers: {'Content-Type': 'application/json'},
        context: context,
      );

      if (response.data != null) {
        final jsonData = jsonDecode(response.data!);
        final productResponse = ProductsResponse.fromJson(jsonData);
        productByCategories.assignAll(productResponse.data);
        print("product::::::${productByCategories.length}");
      } else {
        showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error: ${response.error}",
        );
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
    }
  }
}
