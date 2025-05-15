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
  List<ProductModel> searchResults = []; // ✅ normal list

  SearchingController() {
    apiRepository = ApiRepository();
  }

  Future<void> searchProduct({required BuildContext context, String search = ''}) async {
    final response = await apiRepository.fetchData(
      '$mainPoint/api/product/search?query=$search',
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
      searchResults = products; // ✅ update result
      update(); // ✅ notify GetBuilder to rebuild
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }
}
