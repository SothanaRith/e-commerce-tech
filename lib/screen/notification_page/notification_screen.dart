import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';

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
        TextButton(
          onPressed: () {},
          child: const Text('Mark all as read'),
        ),
      ]),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final section = notifications[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                  leading: const Icon(Icons.local_shipping, color: Colors.green),
                  title: AppText.title(notification['title']),
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
