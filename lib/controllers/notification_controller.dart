import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:e_commerce_tech/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';

class NotificationController extends GetxController {
  late final ApiRepository apiRepository;
  bool isLoading = false;
  List<NotificationModel> notifications = [];
  NotificationModel notification = NotificationModel();

  NotificationController() {
    apiRepository = ApiRepository();
  }

  // Fetch all notifications for a user
  Future<List<NotificationModel>> getNotifications({
    required BuildContext context,
    required String userId,
  }) async {
    final response = await apiRepository.fetchData(
      '$mainPoint/api/notifications/$userId',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      print("Fetched Notifications: $jsonData");

      notifications = (jsonData as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList();
      update();
      return notifications;
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
      return []; // Return empty list if error
    }
  }

  // Create a new notification
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required BuildContext context,
  }) async {
    final response = await apiRepository.postData(
      '$mainPoint/api/notifications',
      body: {
        "userId": userId,
        "title": title,
        "body": body,
      },
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      showCustomDialog(
        context: context,
        type: DialogType.success,
        title: "${jsonData["message"]}",
        okOnPress: () {
          // Handle success (e.g., refresh notification list)
        },
      );
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }

  // Update (mark as read) a notification
  Future<void> updateNotification({
    required String notificationId,
    required BuildContext context,
  }) async {
    final response = await apiRepository.putData(
      '$mainPoint/api/notifications/$notificationId',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      showCustomDialog(
        context: context,
        type: DialogType.success,
        title: "${jsonData["message"]}",
      );
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }

  // Delete a notification
  Future<void> deleteNotification({
    required String notificationId,
    required BuildContext context,
  }) async {
    final response = await apiRepository.deleteData(
      '$mainPoint/api/notifications/$notificationId',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      showCustomDialog(
        context: context,
        type: DialogType.success,
        title: "${jsonData["message"]}",
        okOnPress: () {
          // Handle success (e.g., remove notification from list)
        },
      );
    } else {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }
}
