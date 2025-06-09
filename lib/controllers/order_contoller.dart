import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/models/Transaction_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/rest_api_helper.dart';
import '../widgets/custom_dialog.dart';

class OrderController extends GetxController {
  final ApiRepository apiRepository = ApiRepository();

  bool isLoading = false;

  // Store transactions keyed by status
  Map<String, List<TransactionModel>> transactionsByStatus = {};

  /// Fetch transactions by status and userId, store them by status key.
  Future<List<TransactionModel>> getTransactionById({
    required BuildContext context,
    required String status,
    required String userId,
  }) async {
    isLoading = true;
    update();

    final response = await apiRepository.fetchData(
      '$mainPoint/api/product/transactions/$status/$userId',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    isLoading = false;
    update();

    if (response.data != null) {
      final List<dynamic> jsonData = jsonDecode(response.data!);

      List<TransactionModel> transactions = jsonData
          .map((item) => TransactionModel.fromJson(item))
          .toList();
      // Save transactions for this status
      transactionsByStatus[status] = transactions;
      update();

      return transactions;
    } else {
      // Show error dialog on failure
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error ?? 'Failed to fetch transactions'}",
      );
      throw Exception('Failed to fetch transactions');
    }
  }

  /// Place an order method updated to include addressId
  RxBool isPlacingOrder = false.obs;

  Future<bool> placeOrder({
    required BuildContext context,
    required String userId,
    required List<Map<String, dynamic>> items,
    required String paymentType,
    required String addressId,  // Added addressId parameter
  }) async {
    try {
      isPlacingOrder.value = true;
      update();

      final body = {
        "userId": userId,
        "items": items,
        "paymentType": paymentType,
        "deliveryAddressId": addressId,  // Add addressId to the request body
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

