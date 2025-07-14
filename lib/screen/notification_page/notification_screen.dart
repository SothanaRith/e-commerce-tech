import 'package:e_commerce_tech/controllers/notification_controller.dart';
import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/track_order_page/order_transaction_detail_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController notificationController = Get.put(NotificationController());
  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    // Initially fetch notifications
    Future.delayed(Duration.zero, () {
      notificationController.getNotifications(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(builder: (controller) {
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
              child: AppText.title2(
                  "News ${controller.totalUnread}",
                  customStyle: TextStyle(color: theme.secondaryHeaderColor)),
            ),
            SizedBox(width: 16),
          ],
        ),
        body: Skeletonizer(
          enabled: controller.isLoading && controller.notifications.isEmpty,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              // Check if we've reached the end of the list and not currently loading more
              if (scrollNotification is ScrollEndNotification &&
                  scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                if (!controller.isLoading) {
                  // Trigger loading more notifications when scrolled to the bottom
                  controller.getNotifications(context: context, isLoadMore: true);
                }
              }
              return false;
            },
            child: ListView.builder(
              itemCount: controller.notifications.length + (controller.isLoading ? 1 : 0), // Add loading item at the bottom
              itemBuilder: (context, index) {
                // Show loading spinner when fetching more notifications
                if (index == controller.notifications.length && controller.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                final notification = controller.notifications[index];
                return InkWell(
                  onTap: () async {
                    // Mark the notification as 'read' when tapped
                    if (notification.status != 'read') {
                      controller.updateNotification(
                          notificationId: notification.id ?? '', status: 'read', context: context);
                    }
                    String message = notification.title ?? '';

                    final match = RegExp(r'#(\d+)').firstMatch(message);

                    if (match != null) {
                      int orderId = int.parse(match.group(1)!);
                      await orderController.getOrderDetailById(context: context, orderId: orderId.toString()).then((value) => goTo(this, OrderTransactionDetailScreen(data: value)));
                    } else {
                      print("Order ID not found");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: notification.status == "read"
                          ? Colors.transparent
                          : theme.primaryColor.withAlpha(50),
                    ),
                    child: Padding(
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
                        subtitle: AppText.caption(notification.body ?? ''),
                        trailing: AppText.caption(notification.sentAt ?? '', customStyle: const TextStyle(color: Colors.green)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
