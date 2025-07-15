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
  int currentPage = 1;
  int pageSize = 10;
  int totalPages = 1;
  bool isLoading = false;

  SearchingController() {
    apiRepository = ApiRepository();
  }

  Future<void> searchProduct({
    required BuildContext context,
    String search = '',
    String? categoryId,
    required String userId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    int page = 1,
    int size = 10,
    bool append = false, // New param to control appending results
  }) async {
    if (isLoading) return; // Prevent concurrent calls
    isLoading = true;
    update();

    final Map<String, String> queryParameters = {
      'query': search,
      'page': page.toString(),
      'size': size.toString(),
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
    if (minRating != null && minRating > 0) {
      queryParameters['minRating'] = minRating.toString();
    }

    final queryString = Uri(queryParameters: queryParameters).query;

    final response = await apiRepository.fetchData(
      '$mainPoint/api/product/search/$userId?$queryString',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      final jsonData = jsonDecode(response.data!);
      final List<dynamic> dataList = jsonData["data"] ?? [];

      List<ProductModel> products = dataList
          .map((item) => ProductModel.fromJson(item))
          .toList();

      if (append) {
        searchResults.addAll(products);
      } else {
        searchResults = products;
      }
      currentPage = page;
      pageSize = size;
      totalPages = jsonData["pagination"]?["totalPages"] ?? 1;

      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();

      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }

  void clearResults() {
    searchResults = [];
    currentPage = 1;
    totalPages = 1;
    update();
  }
}