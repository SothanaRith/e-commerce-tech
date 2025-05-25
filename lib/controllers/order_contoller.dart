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
    required List<Map<String, dynamic>> items, // [{productId, variantId?, quantity}]
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
        '$mainPoint/api/order/place',
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
}
