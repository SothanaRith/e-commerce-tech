import 'dart:convert';
import 'dart:developer';

import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/models/category_model.dart';
import 'package:e_commerce_tech/models/home_model.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../helper/rest_api_helper.dart';
import '../utils/app_constants.dart';

class HomeController extends GetxController {
  final apiRepository = ApiRepository();

  int currentPage = 1;
  final int pageSize = 10;
  bool isLoading = false;
  bool hasMore = true;

  List<CategoryModel> categories = [];
  List<ProductModel> products = [];

  Future<void> loadHome({required int page, required String userId, required BuildContext context}) async {
    if (isLoading) return; // Prevent reloading while data is being fetched
    isLoading = true;
    update();

    log('Loading page: $page'); // Debugging line: Check page being loaded
    final response = await apiRepository.fetchData(
      "$mainPoint/api/home/loadHome/?page=${page}&size=$pageSize&userId=$userId",
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      final homeResponse = HomeModel.fromJson(jsonData['data']);

      // Debugging: Check the response data structure
      log('Home response: ${jsonData['data']}');

      if (page == 1) {
        products = homeResponse.products;
      } else {
        if (homeResponse.products.isEmpty) {
          hasMore = false; // No more data to load
        } else {
          products.addAll(homeResponse.products); // Append new products
        }
      }

      if (categories.isEmpty) {
        categories = homeResponse.categories;
      }

      // Debugging: Check if hasMore flag is set correctly
      log('Has more data: $hasMore');
    } else {
      hasMore = false; // If no data, mark as no more data
      log('No data received, hasMore set to false');
    }

    isLoading = false;
    update();
  }
}
