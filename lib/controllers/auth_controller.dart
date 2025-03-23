import 'dart:convert';

import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/models/user_model.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late final ApiRepository apiRepository;

  AuthController() {
    apiRepository = ApiRepository();
  }

  Future<void> getUser() async {
    final response = await apiRepository.fetchData(
      'https://2fac-58-97-228-121.ngrok-free.app/api/users/getProfile',
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNzQyNzEzNDM4LCJleHAiOjE3NDMzMTgyMzh9.fsgucNyx_FVMXmfdBefq2KlRJYbifFydYFe-SCiMohI',
        'Content-Type': 'application/json'
      },
    );
    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Data: $jsonData");
    } else {
      print('Error: ${response.error}');
    }
  }
}