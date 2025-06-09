import 'package:e_commerce_tech/controllers/notification_controller.dart';
import 'package:e_commerce_tech/helper/notification_service.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          type: this,
          title: "Notifications",
          context: context,
          action: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: AppText.title2("News 2", customStyle: TextStyle(color: theme.secondaryHeaderColor)),
            ),
            SizedBox(width: 16),
          ]
      ),
      body: GetBuilder<NotificationController>(
          init: NotificationController(), // Initialize the controller
          builder: (controller) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.notifications.isEmpty) {
              return Center(child: Text("No notifications available"));
            }

            return ListView.builder(
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.highlightColor.withAlpha(60),
                      ),
                      child: SvgPicture.asset("assets/images/icons/delivery.svg"),
                    ),
                    title: AppText.title1(notification.title ?? ''),
                    subtitle: AppText.caption(notification.body  ?? ''),
                    trailing: AppText.caption(notification.sentAt  ?? '', customStyle: const TextStyle(color: Colors.green)),
                  ),
                );
              },
            );
          }
      ),
    );
  }
}
