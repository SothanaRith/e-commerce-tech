import 'dart:convert';
import 'package:e_commerce_tech/controllers/home_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/models/poster_model.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosterController extends GetxController {
  late final ApiRepository apiRepository;
  bool isLoading = false;
  List<PosterModel> posterData = []; // Poster data storage
  final HomeController homeController = Get.put(HomeController());

  PosterController() {
    apiRepository = ApiRepository();
  }

  // Fetch all posters
  Future<List<PosterModel>> getAllPosters({required BuildContext context}) async {
    isLoading = true;
    update();
    final response = await apiRepository.fetchData(
      '$mainPoint/api/home/posters?activeOnly=true',
      headers: {
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Posters Data: ${jsonData["data"]}");

      // Assuming the data is a list of posters
      List<PosterModel> posters = await (jsonData["data"] as List)
          .map((item) => PosterModel.fromJson(item))
          .toList();

      print("Fetched Posters Data: $posters");
      posterData = posters;
      isLoading = false;
      update();
      return posters;
    } else {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Error: ${response.error}",
      );
      return []; // Return empty list if error
    }
  }
}
