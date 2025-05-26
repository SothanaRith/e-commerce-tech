import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/global.dart';
import '../helper/rest_api_helper.dart';
import '../widgets/custom_dialog.dart';

class OrderController extends GetxController {
  final apiRepository = ApiRepository();
  RxBool isPlacingOrder = false.obs;

  Future<bool> placeOrder({
    required BuildContext context,
    required String userId,
    required List<Map<String, dynamic>> items,
    required String paymentType,
  }) async {
    try {
      isPlacingOrder.value = true;
      update();

      final body = {
        "userId": userId,
        "items": items,
        "paymentType": paymentType,
      };

      final response = await apiRepository.postData(
        '$mainPoint/api/product/place-order',
        body: body,
        headers: {'Content-Type': 'application/json'},
        context: context,
      );

      if (response.data != null) {
        var jsonData = jsonDecode(response.data!);
        showCustomDialog(
          context: context,
          type: DialogType.success,
          title: "Success",
          desc: jsonData["message"] ?? "Order placed successfully",
          okOnPress: () {},
        );
        return true;
      } else {
        showCustomDialog(
          context: context,
          type: DialogType.error,
          title: "Error",
          desc: response.error ?? "Failed to place order",
        );
        return false;
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Unexpected Error",
        desc: e.toString(),
      );
      return false;
    } finally {
      isPlacingOrder.value = false;
      update();
    }
  }

  Future<List<Map<String, String>>> fetchPaymentMethods() async {
    // Example placeholder - replace with your real API call and data parsing
    await Future.delayed(Duration(seconds: 1)); // simulate network delay

    return [
      {
        "imageUrl": "https://cdn6.aptoide.com/imgs/2/a/6/2a6b391e2053870eac06539bd99d51a6_icon.png",
        "bankName": "ABA",
        "subtitle": "23776 ** 1324",
      },
      {
        "imageUrl": "https://cdn6.aptoide.com/imgs/c/f/f/cffec3f2fc237b5e9baefcff21783b7c_icon.png",
        "bankName": "Wing",
        "subtitle": "",
      },
      {
        "imageUrl": "https://www.acledasecurities.com.kh/as/assets/listed_company/ABC/logo.png",
        "bankName": "Acleda",
        "subtitle": "",
      },
    ];
  }
}
