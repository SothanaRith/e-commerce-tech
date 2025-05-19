import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchingController extends GetxController {
  late final ApiRepository apiRepository;

  List<ProductModel> searchResults = [];

  SearchingController() {
    apiRepository = ApiRepository();
  }

  Future<void> searchProduct({
    required BuildContext context,
    String search = '',
    String? categoryId,
    required String userId,
    double? minPrice,
    double? maxPrice, double? minRating,
  }) async {
    final Map<String, String> queryParameters = {
      'query': search,
    };

    if (categoryId != null && categoryId.isNotEmpty) {
      queryParameters['categoryId'] = categoryId;
    }
    if (minPrice != null) {
      queryParameters['minPrice'] = minPrice.toString();
    }
    if (maxPrice != null) {
      queryParameters['maxPrice'] = maxPrice.toString();
    }

    final queryString = Uri(queryParameters: queryParameters).query;

    final response = await apiRepository.fetchData(
      '$mainPoint/api/product/search/$userId?$queryString',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json'
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      List<ProductModel> products = (jsonData as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();

      searchResults = products;
      update();  // notify GetBuilder widgets to rebuild
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }

  void clearResults() {
    searchResults = [];
    update();
  }
}
