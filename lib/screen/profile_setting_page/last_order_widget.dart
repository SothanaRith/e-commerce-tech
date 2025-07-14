import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/main.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: GestureDetector(
        onTap: () async {
          await orderController.getOrderDetailById(context: context, orderId: '6').then((value) => goTo(this, OrderTransactionDetailScreen(data: value)));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      imageUrl:
                      safeImageUrl(''),
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                            color: theme.primaryColor),
                      ),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppText.body2(
                            'In delivery',
                            customStyle: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4,),
                          const AppText.caption(
                            '11 Jun 2025',
                          ),
                        ],
                      ),
                      const SizedBox(height: 4,),
                      AppText.caption(
                        'your order will updated as soon',
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
                  'view',
                  customStyle: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
