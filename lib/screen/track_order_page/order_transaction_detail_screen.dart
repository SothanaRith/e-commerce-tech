import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/Transaction_model.dart';
import 'package:e_commerce_tech/models/order_tracking_model.dart';
import 'package:e_commerce_tech/screen/product_details_page/product_details_screen.dart';
import 'package:e_commerce_tech/screen/review_page/review_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/item_select_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderTransactionDetailScreen extends StatefulWidget {
  final OrderModel data;
  const OrderTransactionDetailScreen({super.key, required this.data});
  @override
  State<OrderTransactionDetailScreen> createState() => _OrderTransactionDetailScreenState();
}

class _OrderTransactionDetailScreenState extends State<OrderTransactionDetailScreen> {

  bool showAllItems = false;
  
  MaterialColor stepColor ({required String status}) {
    if (status == "Order Placed") {
      return Colors.purple;
    } else if (status == "In Progress") {
      return Colors.orange;
      
    } else if (status == "Delivery") {
      return Colors.teal;
      
    } else if (status == "Delivered") {
      return Colors.green;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "transaction_detail".tr, context: context),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListViewCustomWidget(
            items: (showAllItems ? widget.data.orderItems : widget.data.orderItems?.take(3))!.map((item) {
              return ItemSelectWidget(
              imageUrl: item.product?.variants?[int.parse(item.variantId ?? '0')].imageUrl ?? '',
              onTap: () {
                goTo(this, ProductDetailsScreen(id: item.product?.id ?? ''));
              },
              actionTitle: "review_this_product".tr,
              onAction: () {
                if (item.product != null)
                goTo(this, ReviewScreen(product: item.product!, variantId: int.parse(item.variantId ?? '0'),));
              },
              title: item.product?.name ?? '--',
              prices: '\$${item.product?.price}',
              countNumber: item.quantity ?? '0',
            );
          }).toList(),),
          const SizedBox(height: 6),
          if (widget.data.orderItems!.length > 3)
            GestureDetector(
              onTap: () {
                setState(() {
                  showAllItems = !showAllItems;
                });
              },
              child: AppText.title2(showAllItems ? 'show_less'.tr : 'show_all'.tr, customStyle: TextStyle(color: theme.primaryColor),),
            ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.title1("order_detail".tr, customStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.body1("expected_delivery_date".tr),
              AppText.body2(widget.data.updatedAt ?? ''),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.body1("tracking_id".tr),
              AppText.body2(widget.data.id ?? ''),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.body1("billing_number".tr),
              AppText.body2(widget.data.billingNumber ?? ''),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.body1("payment_type".tr),
              AppText.body2(widget.data.paymentType ?? ''),
            ],
          ),
          const SizedBox(height: 20),
          ...widget.data.trackingSteps!.asMap().entries.map((entry) {
            int idx = entry.key;
            OrderTrackingModel step = entry.value;
            return buildStepItem(
              context,
              title: step.status ?? 'N/A',
              time: step.timestamp ?? '',
              bgColor: stepColor(status: step.status ?? ''),
              textColor: stepColor(status: step.status ?? ''),
              isFirst: idx == 0,
              isLast: idx == widget.data.trackingSteps!.length - 1,
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
                  color: bgColor.withAlpha(50),
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