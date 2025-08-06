import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/cart_controller.dart';
import 'package:e_commerce_tech/controllers/lacation_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/payment/payment_method_screen.dart';
import 'package:e_commerce_tech/screen/check_out_page/shipping_address_screen.dart';
import 'package:e_commerce_tech/screen/product_details_page/product_details_screen.dart';
import 'package:e_commerce_tech/screen/profile_setting_page/profile_screen.dart';
import 'package:e_commerce_tech/screen/profile_setting_page/user_profile_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:e_commerce_tech/widgets/item_select_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final CartController cartController = Get.put(CartController());
  final LocationController locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    // Fetch cart once when screen initializes
    Future.delayed(Duration.zero, () {
      cartController.fetchAllCart(context: context,
          userId: UserStorage.currentUser?.id.toString() ?? '');
      locationController.getDefaultAddresses(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "checkout".tr, context: context),
      body: GetBuilder<CartController>(
        builder: (logic) {
          if (logic.cartList.isEmpty && !logic.isLoadingProducts.value) {
            return Center(child: Text("your_cart_is_empty".tr));
          }
          return Skeletonizer(
            enabled: logic.isLoadingProducts.value,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  AppText.title1("shipping_address".tr),
                  const SizedBox(height: 12),
                  InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const ShippingAddressScreen(
                                backHome: false,)),
                        ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GetBuilder<LocationController>(builder: (
                              locationLogic) {
                            return Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      color: theme.primaryColor),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        AppText.caption(
                                          locationLogic.addressesDefault
                                              ?.phoneNumber ?? '---',
                                          customStyle: TextStyle(
                                              color: theme.primaryColor),
                                        ),
                                        const SizedBox(height: 2),
                                        AppText.body1(
                                          locationLogic.addressesDefault
                                              ?.street ?? 'N/A',
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: theme.highlightColor, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(thickness: 0.2),
                  const SizedBox(height: 24),
                  AppText.title1("order_list".tr),
                  const SizedBox(height: 12),
                  ListViewCustomWidget(
                    items: logic.cartList.map((item) {
                      final product = item.product;
                      final variant = item.variant;
                      if (product != null) {
                        int quantity = int.tryParse(item.quantity ?? '') ?? 0;
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
                              builder: (context) => Dialog(
                                insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.orange.withOpacity(0.1),
                                        radius: 28,
                                        child: Icon(Icons.dangerous_rounded, color: Colors.orange, size: 32),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'confirm_delete'.tr,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${"are_you_sure_you_want_to_delete".tr} "${product
                                            .name}" ${"from your cart?".tr}',
                                        style: const TextStyle(color: Colors.black54),
                                        textAlign: TextAlign.center,
                                      ),
                                        const SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                              child: AppText.body2("cancel".tr, customStyle: TextStyle(color: theme.primaryColor),),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: AppText.body2("confirm".tr, customStyle: TextStyle(color: theme.secondaryHeaderColor),),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ) ??
                                false; // Return false if dialog dismissed by other means
                          },
                          onDismissed: (direction) {
                            cartController.removeItemToCart(context: context,
                                productId: product.id ?? '',
                                userId: UserStorage.currentUser?.id.toString() ??
                                    '');
                          },
                          child: ItemSelectWidget(
                            imageUrl: variant?.imageUrl ?? '',
                            title: "${product.name}",
                            prices: calculateFinalPrice(double.parse(variant?.price ?? '0'), variant?.discountType, double.parse(variant?.discountValue ?? '0'), variant?.isPromotion ?? 'false'),
                            onTap: () {
                              goTo(this, ProductDetailsScreen(id: product.id ?? ''));
                            },
                            countNumber: quantity.toString(), variantTitle: variant?.title ?? '', discount: variant?.isPromotion == 'false' ? '' : "${variant?.discountValue} ${variant?.discountType == 'fixed' ? '\$' : '%'}",
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }).toList(),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: GetBuilder<CartController>(
        builder: (logic) {
          double totalPrice = 0;

          for (var item in logic.cartList) {
            double price = double.tryParse(item.priceAtPurchase ?? '') ?? 0.0;
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
                AppText.title1('${"total".tr}: \$${totalPrice.toStringAsFixed(2)}'),
                GetBuilder<LocationController>(builder: (logicLocation) {
                  return logic.cartList.isNotEmpty ? ElevatedButton(
                    onPressed: () {
                      print(logicLocation.addressesDefault?.id);
                      logicLocation.addressesDefault?.id != null && logicLocation.addressesDefault?.id != '' ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentMethodScreen(
                              cart: logic.cartList, addressId: logicLocation.addressesDefault?.id ?? '',)
                        ),
                      ) : UserStorage.currentUser?.phone == null ? showCustomDialog(
                      context: context,
                      type: CustomDialogType.info,
                      title: "please_add_your_phone_number_before_checkout".tr,
                      okOnPress: () {
                        goTo(this, UserProfileScreen());
                      }
                      ) : showCustomDialog(
                        context: context,
                        type: CustomDialogType.info,
                        title: "please_add_your_addresses".tr,
                      ) ;
                      // Proceed to payment or order confirmation

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: AppText.title2("check_out".tr,
                      customStyle: TextStyle(color: theme
                          .secondaryHeaderColor),),
                  ) : ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.highlightColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: AppText.title2("check_out".tr,
                      customStyle: TextStyle(color: theme
                          .secondaryHeaderColor),),
                  );
                })
              ],
            ),
          );
        },
      ),
    );
  }
}
