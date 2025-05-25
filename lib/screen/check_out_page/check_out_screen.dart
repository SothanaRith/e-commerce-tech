import 'package:e_commerce_tech/controllers/cart_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/check_out_page/payment_method_screen.dart';
import 'package:e_commerce_tech/screen/check_out_page/payment_verify_screen.dart';
import 'package:e_commerce_tech/screen/check_out_page/select_delivery_option_screen.dart';
import 'package:e_commerce_tech/screen/check_out_page/shipping_address_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/item_select_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    // Fetch cart once when screen initializes
    Future.delayed(Duration.zero, () {
      cartController.fetchAllCart(context: context, userId: '1');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "Checkout", context: context),
      body: GetBuilder<CartController>(
        builder: (logic) {
          if (logic.isLoadingProducts.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (logic.cartList.isEmpty) {
            return const Center(child: Text("Your cart is empty."));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                AppText.title1("Shipping Address"),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => goTo(this, const ShippingAddressScreen()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.caption("Workplace",
                                    customStyle:
                                    TextStyle(color: theme.primaryColor)),
                                const SizedBox(height: 4),
                                const Text("1901 Cili. Shiloh, Hawaii 81092"),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: theme.highlightColor, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppText.title1("Delivery Type"),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => goTo(this, const SelectDeliveryOptionScreen()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.delivery_dining),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.caption("Free shipping",
                                    customStyle:
                                    TextStyle(color: theme.primaryColor)),
                                Row(
                                  children: const [
                                    Text("Estimate: "),
                                    Text("2-30 Days",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: theme.highlightColor, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(thickness: 0.2),
                const SizedBox(height: 24),
                AppText.title1("Order List"),
                const SizedBox(height: 12),
                ListViewCustomWidget(
                  items: logic.cartList.map((item) {
                    final product = item.product;
                    if (product != null) {
                      double price = double.tryParse(product.price ?? '') ?? 0.0;
                      int quantity = int.tryParse(item.quantity ?? '') ?? 0;
                      final totalPrice = "\$${(price * quantity).toStringAsFixed(2)}";

                      return Dismissible(
                        key: Key(item.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          // Show confirmation dialog
                          return await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete "${product.name}" from your cart?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false), // Cancel
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true), // Confirm
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ) ?? false; // Return false if dialog dismissed by other means
                        },
                        onDismissed: (direction) {
                          cartController.removeItemToCart(context: context, productId: product.id ?? '', userId: '1');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.name} removed from cart')),
                          );
                        },
                        child: GestureDetector(
                          child: ItemSelectWidget(
                            imageUrl: product.imageUrl != null
                                ? "$mainPoint${product.imageUrl![0]}"
                                : 'https://via.placeholder.com/150',
                            title: product.name ?? '',
                            prices: totalPrice,
                            countNumber: quantity.toString(),
                          ),
                        ),
                      );
                      ;
                    } else {
                      return const SizedBox();
                    }
                  }).toList(),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: GetBuilder<CartController>(
        builder: (logic) {
          double totalPrice = 0;

          for (var item in logic.cartList) {
            double price = double.tryParse(item.product?.price ?? '') ?? 0.0;
            int quantity = int.tryParse(item.quantity ?? '') ?? 0;
            totalPrice += price * quantity;
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.title1('Total: \$${totalPrice.toStringAsFixed(2)}'),
                ElevatedButton(
                  onPressed: () {
                    // Proceed to payment or order confirmation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethodScreen(),
                      ),
                    );
                  },
                  child: AppText.title2("check out", customStyle: TextStyle(color: theme.secondaryHeaderColor),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
