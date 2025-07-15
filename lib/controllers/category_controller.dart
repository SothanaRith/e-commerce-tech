import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/models/category_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/global.dart';
import '../helper/rest_api_helper.dart';
import '../models/product_by_category.dart';
import '../models/product_model.dart';
import '../widgets/custom_dialog.dart';

class CategoryController extends GetxController {

  final apiRepository = ApiRepository();
  List<ProductModel> productByCategories = [];
  CategoryResponse? category;
  bool isLoadingProducts = false;

  Future<void> fetchAllCategory({required BuildContext context}) async {
    try {
      isLoadingProducts = true;
      update();

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
          type: CustomDialogType.error,
          title: "Error: ${response.error}",
        );
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Unexpected error",
        desc: e.toString(),
      );
    } finally {
      isLoadingProducts = false;
      update();
    }
  }

  Future<void> listProByCategory({required String categoryId, required BuildContext context}) async {
    try {
      isLoadingProducts = true;
      update();

      // Fetch products by category
      final response = await apiRepository.fetchData(
        '$mainPoint/api/category/categories/$categoryId/userId/${UserStorage.currentUser?.id}',  // Ensure this endpoint returns products and user-specific data like Cart and Wishlist
        headers: {'Content-Type': 'application/json'},
        context: context,
      );

      if (response.data != null) {
        final jsonData = jsonDecode(response.data!);
        final productResponse = ProductsResponse.fromJson(jsonData);

        // Assuming productResponse.data is a list of product objects
        productByCategories.assignAll(productResponse.data);
        update();
      } else {
        showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Error: ${response.error}",
        );
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Unexpected error",
        desc: e.toString(),
      );
    } finally {
      isLoadingProducts = false;
      update();
    }
  }
}
