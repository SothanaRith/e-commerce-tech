import 'package:e_commerce_tech/controllers/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khqr_sdk/khqr_sdk.dart';
import 'package:flutter/widgets.dart';

class PaymentStreamApp extends StatefulWidget {
  @override
  State<PaymentStreamApp> createState() => _PaymentStreamAppState();
}

class _PaymentStreamAppState extends State<PaymentStreamApp> with WidgetsBindingObserver {
  final PaymentController paymentController = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);  // Register the observer
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);  // Remove the observer when not needed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // When app is resumed (comes to the foreground)
    if (state == AppLifecycleState.resumed) {
      print("App has returned to the foreground");
      // You can refresh the transaction status when app is resumed
      paymentController.checkTransactionStatus(paymentController.md5); // Use the MD5 or any identifier
    }
    // If you want to track when the app goes to the background, you can add logic for AppLifecycleState.paused
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Integration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<PaymentController>(builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show loading indicator while waiting for response

              if (controller.isLoading)
                CircularProgressIndicator()
              else
                ...[
                  if (!controller.isPaymentSuccess)
                  KhqrCardWidget(
                    width: 300.0,
                    receiverName: 'Narith KoKo',
                    amount: 100.00,
                    keepIntegerDecimal: false,
                    currency: KhqrCurrency.khr,
                    qr: controller.qrCode,
                  ),
                  SizedBox(height: 20),
                  if (!controller.isPaymentSuccess)
                  Text('QR Code: ${controller.qrCode}'),
                  SizedBox(height: 20),
                  if (!controller.isPaymentSuccess)
                  ElevatedButton(
                    onPressed: () async {
                      // Simulate a deeplink or QR generation
                      await controller.generateKHQR("individual");
                    },
                    child: Text('Generate QR Code'),
                  ),
                  SizedBox(height: 20),
                  // Use StreamBuilder to listen to the status stream
                  StreamBuilder<String>(
                    stream: controller.transactionStatusStream,
                    builder: (context, snapshot) {
                      if (controller.isPaymentSuccess) {
                        return Center(child: Text('successfully pay!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Waiting for transaction status...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        // Display the transaction status data received from the stream
                        return Text('Transaction Status: ${snapshot.data}');
                      } else {
                        return Text('No data available');
                      }
                    },
                  ),
                ]
            ],
          );
        }),
      ),
    );
  }
}
