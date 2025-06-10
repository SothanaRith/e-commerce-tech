import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/item_select_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderTransactionDetailScreen extends StatelessWidget {
  final List<TrackingStep> steps = [
    TrackingStep("Order Placed", "03. 07. 2025 .6:30AM", Colors.purple[100]!, Colors.purple),
    TrackingStep("In Progress", "03. 07. 2025 .6:30AM", Colors.orange[100]!, Colors.orange),
    TrackingStep("Delivery", "03. 07. 2025 .6:30AM", Colors.teal[100]!, Colors.teal),
    TrackingStep("Delivered", "03. 07. 2025 .6:30AM", Colors.green[100]!, Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "transaction_detail".tr, context: context),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ItemSelectWidget(
            imageUrl: [],
            title: 'No Title',
            prices: '\$${'0.00'}',
            countNumber: '0',
          ),
          const SizedBox(height: 20),
          AppText.title1("order_detail".tr, customStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.body1("expected_delivery_date".tr),
              AppText.body2("03. 07. 2025"),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.body1("tracking_id".tr),
              AppText.body2("RGJ289KH12"),
            ],
          ),
          const SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) {
            int idx = entry.key;
            TrackingStep step = entry.value;
            return buildStepItem(
              context,
              title: step.title,
              time: step.time,
              bgColor: step.bgColor,
              textColor: step.textColor,
              isFirst: idx == 0,
              isLast: idx == steps.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget buildStepItem(BuildContext context,
      {required String title,
        required String time,
        required Color bgColor,
        required Color textColor,
        bool isFirst = false,
        bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.green[800],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.check, color: Colors.white, size: 12),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Colors.green[800],
              )
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppText.title2(title, customStyle: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 6),
              AppText.body2(time, customStyle: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Icon(Icons.inventory_2_outlined, color: Colors.green[800])
      ],
    );
  }
}

class TrackingStep {
  final String title;
  final String time;
  final Color bgColor;
  final Color textColor;

  TrackingStep(this.title, this.time, this.bgColor, this.textColor);
}