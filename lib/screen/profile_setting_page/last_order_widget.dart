import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/Transaction_model.dart';
import 'package:e_commerce_tech/screen/track_order_page/order_transaction_detail_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/safe_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LastOrderWidget extends StatefulWidget {
  const LastOrderWidget({super.key});

  @override
  State<LastOrderWidget> createState() => _LastOrderWidgetState();
}

class _LastOrderWidgetState extends State<LastOrderWidget> {
  final OrderController orderController = Get.put(OrderController());
  late Future<OrderModel> _lastOrder;

  @override
  void initState() {
    super.initState();
    // Fetch the last order on widget initialization
    _lastOrder = orderController.getLastOrder(context: context); // Replace 'user-id' with actual user ID
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FutureBuilder<OrderModel>(
        future: _lastOrder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No orders found.'));
          }

          OrderModel lastOrder = snapshot.data!;

          return GestureDetector(
            onTap: () async {
              await orderController.getOrderDetailById(
                context: context,
                orderId: lastOrder.id.toString(),
              ).then((value) => goTo(this, OrderTransactionDetailScreen(data: value)));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: theme.primaryColor.withAlpha(25),
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: safeImageUrl(lastOrder.orderItems?[0].product?.imageUrl?.first ?? ''),
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(color: theme.primaryColor),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 8,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppText.body2(
                                lastOrder.status ?? 'In delivery',
                                customStyle: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 4,),
                              AppText.caption(
                                lastOrder.createdAt ?? '11 Jun 2025',
                              ),
                            ],
                          ),
                          const SizedBox(height: 4,),
                          AppText.caption(
                            'Your order will be updated soon',
                            customStyle: TextStyle(color: theme.primaryColor),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 22),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.circular(100),
                        border: Border.all(color: theme.primaryColor, width: 1)
                    ),
                    child: AppText.body2(
                      'View',
                      customStyle: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
