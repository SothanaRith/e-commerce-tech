import 'package:e_commerce_tech/controllers/payment_controller.dart';
import 'package:e_commerce_tech/screen/payment/qrcode_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentApp extends StatelessWidget {
  // Create an instance of the controller
  final PaymentController paymentController = Get.put(PaymentController());

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
              // Show loading indicator while waiting
              if (controller.isLoading)
                CircularProgressIndicator()
              else
                ...[
                  Text('Deeplink: ${controller.deeplink}'),
                  SizedBox(height: 20),
                  Text('Transaction Status: ${controller.transactionStatus}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        controller.generateDeeplink(
                          '00020101021229270023sothanarith_heang1@aclb52045999530311654031005802KH5917Sothanarith Heang6010PHNOM PENH62520105#00010211855875758570313Devit Huotkeo0707Devit I991700131750086788210630473CC',
                          // Example QR code string (you should replace with actual data)
                          'https://bakong.nbc.gov.kh/images/logo.svg',
                          // Example app icon URL
                          'Bakong', // App name
                          'https://bakong.nbc.gov.kh/', // App callback URL
                        ),
                    child: Text('Generate Deeplink'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(PaymentStreamApp());
                    },
                    child: Text('Move to Stream QRCode'),
                  ),
                ]
            ],
          );
        }),
      ),
    );
  }
}