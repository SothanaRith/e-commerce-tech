import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/controllers/payment_controller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/models/cart_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khqr_sdk/khqr_sdk.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaymentDialog extends StatefulWidget {
  final double amount;
  final KhqrCurrency currency;
  final String paymentType;
  final String addressId;
  final List<CartModel> items;

  const PaymentDialog({super.key, required this.amount, required this.currency, required this.paymentType, required this.addressId, required this.items});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> with WidgetsBindingObserver {
  final PaymentController paymentController = Get.put(PaymentController());
  final OrderController orderController = OrderController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await paymentController.generateKHQR(
        currency: widget.currency,
        amount: widget.amount, context: context,
      ).then((value) {
        PaymentStorage.saveOrder(newBillingNumber: paymentController.billingNumber, newAddressId: widget.addressId, items: widget.items, newPaymentType: widget.paymentType).then((value) async => await checkTransactionWhenDialog(),);
      },);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     Future.delayed(Duration.zero, () {
  //       paymentController.checkTransactionStatus(md5: paymentController.md5, context: context);
  //     });
  //   }
  // }

  Future<void> checkTransactionWhenDialog() async {
    Future.delayed(Duration.zero, () {
      paymentController.checkTransactionStatus(md5: paymentController.md5, context: context, isOpenDialogKhqr: true).then((value) async {
        await checkTransactionWhenDialog();
      },);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GetBuilder<PaymentController>(builder: (controller) {
          return Skeletonizer(
            enabled: controller.isGenerateLoading,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('KHQR Payment',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    )),
                const SizedBox(height: 16),
                if (!controller.isPaymentSuccess)
                  KhqrCardWidget(
                    width: 280,
                    receiverName: 'Snap Buy',
                    amount: double.parse((widget.amount * (PaymentStorage.rate ?? 4000)).toStringAsFixed(0)),
                    keepIntegerDecimal: false,
                    currency: widget.currency,
                    qr: controller.qrCode,
                  ),
                const SizedBox(height: 20),
                StreamBuilder<String>(
                  stream: controller.transactionStatusStream,
                  builder: (context, snapshot) {
                    if (controller.isPaymentSuccess) {
                      return Column(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 48),
                          const SizedBox(height: 8),
                          Text('Payment Successful!',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green)),
                        ],
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Waiting for transaction status...');
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
                    } else if (snapshot.hasData) {
                      return Text('Status: Waiting for transaction status...', style: TextStyle(fontWeight: FontWeight.w500));
                    } else {
                      return const Text('No data available.');
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    showCustomDialog(context: context, type: CustomDialogType.info, title: "Are you sure you want to cancel this payment ?", okOnPress: () {
                      controller.resetData();
                      PaymentStorage.clearCheckPayment();
                      Navigator.of(context).pop();
                    }, cancelOnPress: () {
                    }, desc: "if you cancel you need to create khqr code again");
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Cancel Payment', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
