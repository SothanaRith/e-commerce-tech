import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/models/Transaction_model.dart';
import 'package:e_commerce_tech/models/user_model.dart';
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

  // /// Fetch transactions by status and userId, store them by status key.
  // Future<List<TransactionModel>> getTransactionById({
  //   required BuildContext context,
  //   required String status,
  //   required String userId,
  // }) async {
  //   isLoading = true;
  //   update();
  //
  //   final response = await apiRepository.fetchData(
  //     '$mainPoint/api/product/transactions/$status/$userId',
  //     headers: {
  //       'Authorization': TokenStorage.token ?? "",
  //       'Content-Type': 'application/json',
  //     },
  //     context: context,
  //   );
  //
  //   isLoading = false;
  //   update();
  //
  //   if (response.data != null) {
  //     final List<dynamic> jsonData = jsonDecode(response.data!);
  //
  //     List<TransactionModel> transactions = jsonData
  //         .map((item) => TransactionModel.fromJson(item))
  //         .toList();
  //     // Save transactions for this status
  //     transactionsByStatus[status] = transactions;
  //     update();
  //
  //     return transactions;
  //   } else {
  //     // Show error dialog on failure
  //     showCustomDialog(
  //       context: context,
  //       type: CustomDialogType.error,
  //       title: "Error: ${response.error ?? 'Failed to fetch transactions'}",
  //     );
  //     throw Exception('Failed to fetch transactions');
  //   }
  // }

  /// Fetch transactions by status and userId, store them by status key.
  Future<List<TransactionModel>> getOrderById({
    required BuildContext context,
    required String status,
    required String userId,
  }) async {
    isLoading = true;
    update();

    final response = await apiRepository.fetchData(
      '$mainPoint/api/product/orders/processed-by-user/$userId?status=$status',
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
        type: CustomDialogType.error,
        title: "Error: ${response.error ?? 'Failed to fetch transactions'}",
      );
      throw Exception('Failed to fetch transactions');
    }
  }

  Future<OrderModel> getLastOrder({
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      update();

      // Fetch the last order of the user from the API
      final response = await apiRepository.fetchData(
        '$mainPoint/api/product/orders/last/${UserStorage.currentUser?.id ?? ''}',
        headers: {
          'Authorization': TokenStorage.token ?? "",
          'Content-Type': 'application/json',
        },
        context: context,
      );

      isLoading = false;
      update();

      if (response.data != null) {
        final dynamic jsonData = jsonDecode(response.data!);
        // Assuming the response returns a single order
        OrderModel order = OrderModel.fromJson(jsonData);
        update();
        return order;
      } else {
        // Show error dialog on failure
        showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Error: ${response.error ?? 'Failed to fetch last order'}",
        );
        throw Exception('Failed to fetch last order');
      }
    } catch (e) {
      // Handle unexpected errors
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Unexpected Error",
        desc: e.toString(),
      );
      rethrow;
    }
  }

  Future<OrderModel> getOrderDetailById({
    required BuildContext context,
    required String orderId,
  }) async {
    isLoading = true;
    update();

    final response = await apiRepository.fetchData(
      '$mainPoint/api/product/orders/$orderId/detail',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    isLoading = false;
    update();

    if (response.data != null) {
      final dynamic jsonData = jsonDecode(response.data!);
      OrderModel order = OrderModel.fromJson(jsonData);
      update();
      return order;
    } else {
      // Show error dialog on failure
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Error: ${response.error ?? 'Failed to fetch transactions'}",
      );
      throw Exception('Failed to fetch transactions');
    }
  }
  /// Place an order method updated to include addressId
  RxBool isPlacingOrder = false.obs;

  Future<Map<dynamic, dynamic>> placeOrder({
    required BuildContext context,
    required String userId,
    required List<Map<String, dynamic>> items,
    required String paymentType,
    required String addressId,  // Added addressId parameter
    required String billingNumber,  // Added addressId parameter
  }) async {
    try {
      isPlacingOrder.value = true;
      update();

      final body = {
        "userId": userId,
        "items": items,
        "paymentType": paymentType,
        "deliveryAddressId": addressId,  // Add addressId to the request body
        "billingNumber": billingNumber
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
          type: CustomDialogType.success,
          title: "Success",
          desc: jsonData["message"] ?? "Order placed successfully",
          okOnPress: () {},
        );
        return {'orderId': jsonData["orderId"], 'totalAmount': jsonData["totalAmount"]};
      } else {
        showCustomDialog(
          context: context,
          type: CustomDialogType.error,
          title: "Error",
          desc: response.error ?? "Failed to place order",
        );
        return {};
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Unexpected Error",
        desc: e.toString(),
      );
      return {};
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
        "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAksY2TS0gKo7ahWTiy73LEAvW6Hezllu7eQ&s",
        "bankName": "Bakong App",
        "subtitle": "National Bank",
      },
      {
        "imageUrl": "https://devithuotkeo.com/static/image/portfolio/khqr/khqr-5.png",
        "bankName": "KHQR",
        "subtitle": "for all bank payment in Cambodia",
      },
      // {
      //   "imageUrl": "https://cdn6.aptoide.com/imgs/2/a/6/2a6b391e2053870eac06539bd99d51a6_icon.png",
      //   "bankName": "ABA Offline Payment",
      //   "subtitle": "Advanced Bank of Asia Limited",
      // },
    ];
  }

  Future<void> updateTransactionByOrderId({
    required BuildContext context,
    required String status,
    required String paymentType,
    required String orderId,
    required String amount,
  }) async {
    try {
      isPlacingOrder.value = true;
      update();

      final body = {
        "status": status,
        "paymentType": paymentType,
        "amount": amount
      };

      final response = await apiRepository.putData(
        '$mainPoint/api/product/transactions/by-order/${orderId}/update',
        body: body,
        headers: {'Content-Type': 'application/json'},
        context: context,
      );

      if (response.data != null) {
        var jsonData = jsonDecode(response.data!);
      } else {
      }
    } catch (e) {
      debugPrint("Unexpected Error $e");

    } finally {
      update();
    }

  }
}

