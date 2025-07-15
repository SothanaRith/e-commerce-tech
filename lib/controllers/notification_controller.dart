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
  int totalUnread = 0;
  int totalNotifications = 0;
  int currentPage = 1;
  final int pageSize = 10;

  NotificationController() {
    apiRepository = ApiRepository();
  }

// Fetch notifications with pagination
  Future<void> getNotifications({
    required BuildContext context,
    bool isLoadMore = false,  // Indicates if we are loading more notifications
  }) async {
    if (isLoading) return;  // Prevent multiple requests while loading

    isLoading = true;
    update();

    final response = await apiRepository.fetchData(
      '$mainPoint/api/notification/notifications/${UserStorage.currentUser?.id}?page=$currentPage&size=$pageSize',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);

      // Extract notifications from the response data
      var dataList = jsonData['data']['notifications'] as List<dynamic>;

      List<NotificationModel> newNotifications = dataList
          .map((item) => NotificationModel.fromJson(item))
          .toList();

      // If loading more, append to the existing list
      print(isLoadMore);

      if (isLoadMore) {
        notifications.addAll(newNotifications);
      } else {
        notifications = newNotifications;  // Replace the notifications list
      }

      // Update total unread and total notifications
      totalUnread = jsonData['data']['totalUnread'];
      totalNotifications = jsonData['data']['totalNotifications'];

      // Update page for next call
      if (newNotifications.isNotEmpty) {
        currentPage++;
      }

      isLoading = false;
      update();
    } else {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Error: ${response.error}",
      );
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
      '$mainPoint/api/notification/notifications?page',
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
        type: CustomDialogType.success,
        title: "${jsonData["message"]}",
        okOnPress: () {
          // Handle success (e.g., refresh notification list)
        },
      );
    } else {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }

  // Update (mark as read) a notification
  Future<void> updateNotification({
    required String notificationId,
    required String status,
    required BuildContext context,
  }) async {
    final response = await apiRepository.putData(
      '$mainPoint/api/notification/notifications/$notificationId',
      headers: {
        'Authorization': TokenStorage.token ?? "",
        'Content-Type': 'application/json',
      },
      body: {
        "status": status,
      },
      context: context,
    );

    if (response.data != null) {
      var jsonData = jsonDecode(response.data!);
      showCustomDialog(
        context: context,
        type: CustomDialogType.success,
        title: "${jsonData["message"]}",
        okOnPress: () async {
          currentPage = 1;
          await getNotifications(context: context);
        }
      );
    } else {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
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
      '$mainPoint/api/notification/notifications/$notificationId',
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
        type: CustomDialogType.success,
        title: "${jsonData["message"]}",
        okOnPress: () {
          // Handle success (e.g., remove notification from list)
        },
      );
    } else {
      showCustomDialog(
        context: context,
        type: CustomDialogType.error,
        title: "Error: ${response.error}",
      );
    }
  }
}
