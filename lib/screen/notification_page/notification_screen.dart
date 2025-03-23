import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final List<Map<String, dynamic>> notifications = [
    {
      "date": "Today",
      "notifications": [
        {
          "title": "Order Shipped",
          "description": "your order has been pack and delivery for maybe 1 day later. Thank you",
          "time": "3:00 AM"
        },
        {
          "title": "Order Shipped",
          "description": "your order has been pack and delivery for maybe 1 day later. Thank you",
          "time": "3:00 AM"
        },
        {
          "title": "Order Shipped",
          "description": "your order has been pack and delivery for maybe 1 day later. Thank you",
          "time": "3:00 AM"
        }
      ]
    },
    {
      "date": "30.09.2025",
      "notifications": [
        {
          "title": "Order Shipped",
          "description": "your order has been pack and delivery for maybe 1 day later. Thank you",
          "time": "3:00 AM"
        },
        {
          "title": "Order Shipped",
          "description": "your order has been pack and delivery for maybe 1 day later. Thank you",
          "time": "3:00 AM"
        },
        {
          "title": "Order Shipped",
          "description": "your order has been pack and delivery for maybe 1 day later. Thank you",
          "time": "3:00 AM"
        },
        {
          "title": "Order Shipped",
          "description": "your order has been pack and delivery for maybe 1 day later. Thank you",
          "time": "3:00 AM"
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "Notifications", context: context, action: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(50)
          ),
          child: AppText.title2("News 2", customStyle: TextStyle(color: theme.secondaryHeaderColor),),
        ),
        SizedBox(width: 16,)
      ]),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final section = notifications[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  section['date'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              ...section['notifications'].map<Widget>((notification) {
                return ListTile(
                  leading: Container(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.highlightColor.withAlpha(60)
                    ),
                    child: SvgPicture.asset("assets/images/icons/delivery.svg"),
                  ),
                  title: AppText.title1(notification['title']),
                  subtitle: AppText.caption(notification['description']),
                  trailing: AppText.caption(notification['time'], customStyle: const TextStyle(color: Colors.green)),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
