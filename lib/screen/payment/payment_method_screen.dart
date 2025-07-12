import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/controllers/payment_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/cart_model.dart';
import 'package:e_commerce_tech/screen/payment/payment_verify_screen.dart';
import 'package:e_commerce_tech/screen/payment/qrcode_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:khqr_sdk/khqr_sdk.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaymentMethodScreen extends StatefulWidget {
  final List<CartModel> cart;
  final String addressId;

  const PaymentMethodScreen(
      {super.key, required this.cart, required this.addressId});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen>
    with WidgetsBindingObserver {
  final OrderController orderController = OrderController();

  int? selectedMethodIndex;
  bool isLoading = true;
  List<Map<String, String>> paymentMethods = [];

  final PaymentController paymentController = Get.put(PaymentController());

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove the observer when not needed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      print("object is resumed");
      if (PaymentStorage.md5 != null) {
        if (PaymentStorage.md5 != '') {
          Future.delayed(Duration.zero, () {
            paymentController.checkTransactionStatus(md5: PaymentStorage.md5 ?? '', context: context);
          });
        } else {
          paymentController.isLoading = false;
          paymentController.update();
        }
      } else {
        paymentController.isLoading = false;
        paymentController.update();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Register the observer
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      final methods = await orderController.fetchPaymentMethods();
      setState(() {
        paymentMethods = methods;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Optionally show error toast or dialog here
    }
  }

  Future<void> changeTransactionWhenDialog() async {
    if (PaymentStorage.md5 != null) {
      if (PaymentStorage.md5 != '') {
        Future.delayed(Duration.zero, () {
          paymentController.checkTransactionStatus(md5: PaymentStorage.md5 ?? '', context: context).then((value) {

          },);
        });
      } else {
        paymentController.isLoading = false;
        paymentController.update();
      }
    } else {
      paymentController.isLoading = false;
      paymentController.update();
    }
  }

  double get totalPrice {
    double total = 0;
    for (var item in widget.cart) {
      final price = double.tryParse(item.product?.price ?? '') ?? 0;
      final quantity = int.tryParse(item.quantity ?? '') ?? 0;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          type: this, title: "payment_method".tr, context: context),
      body: GetBuilder<PaymentController>(builder: (controller) {
        return Skeletonizer(
        enabled: isLoading || controller.isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.title1("total_amount_:".tr),
                        AppText.title1("\$${totalPrice.toStringAsFixed(2)}"),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.title1("TO REAL".tr),
                        AppText.title1("\៛${(totalPrice * 4000).toStringAsFixed(2)}"),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),
              paymentMethods.isEmpty
                  ? Center(
                      child: Text("no_payment_methods_available".tr,
                          style: TextStyle(color: Colors.red)))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paymentMethods.length,
                      itemBuilder: (context, index) {
                        final method = paymentMethods[index];
                        final isSelected = selectedMethodIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMethodIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.primaryColor.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: theme.highlightColor.withAlpha(20),
                                    blurRadius: 6)
                              ],
                              border: Border.all(
                                color: isSelected
                                    ? theme.primaryColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: method['imageUrl'] != null
                                          ? Image.network(
                                              method['imageUrl']!,
                                              width: 50.w,
                                              height: 50.w,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 50.w,
                                              height: 50.w,
                                              color: Colors.grey[300],
                                            ),
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText.title1(
                                            method['bankName'] ?? ""),
                                        if ((method['subtitle'] ?? "")
                                            .isNotEmpty)
                                          SizedBox(height: 6),
                                        if ((method['subtitle'] ?? "")
                                            .isNotEmpty)
                                          AppText.title2(
                                            method['subtitle'] ?? "",
                                            customStyle: TextStyle(
                                                color: theme.highlightColor),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: isSelected
                                      ? theme.primaryColor
                                      : theme.highlightColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: selectedMethodIndex == null
                    ? null
                    : () async {
                  if (selectedMethodIndex == 0) {
                    showCustomDialog(
                      context: context,
                      type: DialogType.info,
                      title: "Process Payment",
                      desc: "are you sure you want to continues payment?",
                      cancelOnPress: () {
                      },
                      okOnPress: () async {
                        if (controller.md5 == '') {
                          await controller.generateKHQR(currency: KhqrCurrency.khr, amount: totalPrice, context: context).then((value) => PaymentStorage.saveOrder(newBillingNumber: controller.billingNumber, newAddressId: widget.addressId, items: widget.cart, newPaymentType: paymentMethods[selectedMethodIndex ?? 0]
                          ['bankName'] ??
                              ""),);
                        }
                        controller.generateDeeplink(
                            'https://bakong.nbc.gov.kh/images/logo.svg',
                            'Snap Buy',
                            '$mainPoint/api/payment/payment-callback', context
                        );
                      }
                    );

                  } else if (selectedMethodIndex == 1) {
                    controller.isLoading = true;
                    controller.update();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                                return PaymentDialog(
                                  amount: totalPrice,
                                  currency: KhqrCurrency.khr,
                                  paymentType:
                                      paymentMethods[selectedMethodIndex ?? 0]
                                              ['bankName'] ??
                                          "",
                                  addressId: widget.addressId,
                                  items: widget.cart,
                                );
                              },
                    );
                  } else if (selectedMethodIndex == 2) {
                    showCustomDialog(
                      context: context,
                      type: DialogType.info,
                      title: "Process Payment",
                      desc: "are you sure you want to continues payment?",
                        cancelOnPress: () {
                        },
                      okOnPress: () async {
                        await controller.generateKHQRMerchantInfo(currency: KhqrCurrency.khr, amount: totalPrice, context: context);
                      });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedMethodIndex == null
                      ? Colors.grey
                      : theme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: AppText.title1("proceed_to_payment".tr,
                    customStyle: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
      }),
    );
  }
}
