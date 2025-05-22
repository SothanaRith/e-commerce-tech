import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/global.dart';
import '../helper/rest_api_helper.dart';
import '../models/product_by_category.dart';
import '../models/product_model.dart';
import '../widgets/custom_dialog.dart';

class CategoryController extends GetxController {

  final apiRepository = ApiRepository();
  RxList<ProductModel> productByCategories = <ProductModel>[].obs;
  CategoryResponse? category;
  RxBool isLoadingProducts = false.obs;

  Future<void> fetchAllCategory({required BuildContext context}) async {
    try {
      isLoadingProducts.value = true;

      final response = await apiRepository.fetchData(
        '$mainPoint/api/category/get-all-categories',
        headers: {'Content-Type': 'application/json'},
        context: context,
      );

      if (response.data != null) {
        final jsonData = jsonDecode(response.data!);
        final productResponse = CategoryResponse.fromJson(jsonData);
        category = productResponse;
        update();
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

  Future<void> listProByCategory({required String categoryId, required BuildContext context}) async {
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
