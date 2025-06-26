import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:khqr_sdk/khqr_sdk.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

import '../screen/payment/payment_verify_screen.dart';
import 'order_contoller.dart';

class PaymentController extends GetxController {
  var deeplink = '';  // Observable variable for Deeplink
  var transactionStatus = '';  // Observable variable for Transaction Status
  var isLoading = false;  // Observable variable for loading state
  var isPaymentSuccess = false;  // Observable variable for loading state
  var qrCode = '';
  var md5 = '';
  var billingNumber = '';
  final _khqrSdk = KhqrSdk();
  OrderController orderController = Get.put(OrderController());
  final StreamController<String> _statusStreamController = StreamController<String>.broadcast(); // Broadcast stream

  // Backend URL for Deeplink Generation and Transaction Status check
  final String apiUrl = '$mainPoint/api/payment'; // Replace with your backend URL

  Future<void> resetData() async {
    deeplink = '';  // Observable variable for Deeplink
    transactionStatus = '';  // Observable variable for Transaction Status
    isLoading = false;  // Observable variable for loading state
    isPaymentSuccess = false;  // Observable variable for loading state
    qrCode = '';
    md5 = '';
    billingNumber = '';
    update();
  }

  Future<void> generateDeeplink(String appIconUrl, String appName, String appDeepLinkCallback, BuildContext context) async {
    isLoading = true;
    update();
    try {
      final sourceInfo = SourceInfo(
        appName: appName,
        appIconUrl: appIconUrl,
        appDeepLinkCallBack: appDeepLinkCallback,
      );

      final deeplinkInfo = DeeplinkInfo(
        qr: qrCode,
        url: 'https://api-bakong.nbc.gov.kh/v1/generate_deeplink_by_qr',
        sourceInfo: sourceInfo,
      );

      final deeplinkData = await _khqrSdk.generateDeepLink(deeplinkInfo);

      deeplink = deeplinkData?.shortLink ?? 'No shortLink in response';
      isLoading = false;
      update();
      await launchInBrowser(Uri.parse(deeplink));
    } catch (e) {
      print('❌ Error: $e');
      deeplink = '';
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Failed Payment",
        desc: "Something wrong. please do your payment again",
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
    isLoading = false;
    update();
  }

  Future<void> checkTransactionStatus({required String md5, required BuildContext context, bool isOpenApp = false}) async {
    if (isLoading) {
      return;
    }

    if (md5 == '') {
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Failed Payment",
        desc: "Something wrong. please do your payment again",
      );
      if (isOpenApp) {
        PaymentStorage.clearCheckPayment();
      }
      isLoading = false;
      update();
      return;
    }

    isLoading = true;
    update();
    _statusStreamController.add("Transaction status check started..."); // Emit initial message
    try {
      var url = Uri.parse('$apiUrl/check-stream-transaction');
      var request = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..body = json.encode({'md5': md5});

      var streamedResponse = await request.send();
      // Listen for the response stream
      streamedResponse.stream.listen(
            (List<int> chunk) async {
          String responseData = String.fromCharCodes(chunk);
          _statusStreamController.add(responseData); // Add data to stream
          print(responseData);

          // Strip `data: ` prefix if it exists
          if (responseData.startsWith('data: ')) {
            responseData = responseData.replaceFirst('data: ', '');
          }

          try {
            final decoded = json.decode(responseData);
            if (decoded is Map<String, dynamic> && decoded['status'] == 'Transaction successful') {
              print("✅ Transaction successful, do something here");
              isPaymentSuccess = true;
              List<Map<String, String>> items = [];

              for (var quantity in PaymentStorage.quantity ?? []) {
                for (var productId in PaymentStorage.listProductId ?? []) {
                  items.add({
                    "productId": productId ?? '',
                    "quantity": quantity ?? '0'
                  });
                }
              }

              await orderController
                  .placeOrder(
                  context: context,
                  userId:
                  UserStorage.currentUser?.id.toString() ??
                      '',
                  items: items,
                  paymentType: PaymentStorage.paymentType ?? '',
                  addressId: PaymentStorage.addressId ?? '', billingNumber: PaymentStorage.billingNumber ?? '' )
                  .then(
                    (value) async {
                  if (value.isNotEmpty) {
                    await orderController.updateTransactionByOrderId(context: context, status: "completed", paymentType: PaymentStorage.paymentType ?? '', orderId: value['orderId'].toString(), amount: value['totalAmount'].toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentVerifyScreen(
                          cart: [],
                          paymentMethod: {},
                        ),
                      ),
                    );
                  }
                },
              );

              PaymentStorage.clearCheckPayment();
              update();
            }
          } catch (e) {
            print("JSON decode error: $e");
          }
        },
        onDone: () {
          isLoading = false;
          if (!isPaymentSuccess) {
            showCustomDialog(
              context: context,
              type: DialogType.error,
              title: "Failed Payment",
              desc: "Payment Failed please try again...",
            );
            _statusStreamController.add("Transaction check completed but failed");
            if (isOpenApp) {
              PaymentStorage.clearCheckPayment();
            }
          } else {
            _statusStreamController.add("Transaction check completed");
          }
          update();
        },
        onError: (e) {
          print("Error: $e");
          isPaymentSuccess = false;

          showCustomDialog(
            context: context,
            type: DialogType.error,
            title: "Failed Payment",
            desc: "Error occurred while checking transaction",
          );

          if (isOpenApp) {
            PaymentStorage.clearCheckPayment();
          }

          _statusStreamController.add("Error occurred while checking transaction");
          isLoading = false;
          update();
        },
      );
    } catch (e) {
      _statusStreamController.add("Error: $e");
      isPaymentSuccess = false;

      if (isOpenApp) {
        PaymentStorage.clearCheckPayment();
      }

      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Failed Payment",
        desc: "Payment Failed with Error: $e",
      );

      isLoading = false;
      update();
    }
  }

  // Stream to listen for updates from the transaction status check
  Stream<String> get transactionStatusStream => _statusStreamController.stream;

  @override
  void onClose() {
    _statusStreamController.close(); // Close the stream when the controller is disposed
    super.onClose();
  }

  // Generate KHQR QR code
  Future<void> generateKHQR({required KhqrCurrency currency,required String amount, required BuildContext context}) async {
    isLoading = true;
    billingNumber = await generateBillNumberWithRandom();
    update();
    try {
      final expire = DateTime.now().millisecondsSinceEpoch + 3600000;
      final info = IndividualInfo(
          bakongAccountId: 'un_virak2@aclb',
          // bakongAccountId: 'sothanarith_heang1@aclb',
          merchantName: 'Snap Buy ($billingNumber)',
          billNumber: billingNumber,
          currency: currency,
          amount: double.parse(amount),
          expirationTimestamp: expire
      );
      final khqrData = await _khqrSdk.generateIndividual(info);
      qrCode = khqrData?.qr ?? '';
      md5 = khqrData?.md5 ?? '';

      if (qrCode != '' && md5 != '') {
        PaymentStorage.savePayment(qrCode: qrCode, md5: md5, isPaymentCompleted: false);
      }

      update();
    } catch (e) {
      qrCode = '';
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Failed Payment",
        desc: "Something wrong. please do your payment again",
      );
      update();
    } finally {
      isLoading = false;
      update();
    }
  }
  Future<void> generateKHQRMerchantInfo({required KhqrCurrency currency,required String amount, required BuildContext context}) async {
    isLoading = true;
    billingNumber = await generateBillNumberWithRandom();
    update();
    try {
      final expire = DateTime.now().millisecondsSinceEpoch + 3600000;
      final info = MerchantInfo(
        bakongAccountId: 'un_virak2@aclb',
        acquiringBank: 'ABA Bank',
        merchantId: '1241779',
        merchantName: 'Heang Sothanarith',
        currency: KhqrCurrency.khr,
        amount: double.parse(amount),
        merchantCategoryCode: "8220",
        expirationTimestamp: expire,
      );
      final khqrData = await _khqrSdk.generateMerchant(info);
      deeplink = "abamobilebank://ababank.com?type=payway&qrcode=00020101021130510016abaakhppxxx@abaa01151250216233230280208ABA Bank5204822053031165802KH5917HEANG SOTHANARITH6010PHNOM PENH624768430010PAYWAY@ABA010712417790209031712101050116304FD93";
      await launchInBrowser(Uri.parse(deeplink));
      qrCode = '';  // Store the generated QR code
      md5 = '';  // Store the generated QR code
      update();
    } catch (e) {
      qrCode = '';
      showCustomDialog(
        context: context,
        type: DialogType.error,
        title: "Failed Payment",
        desc: "Something wrong. please do your payment again",
      );
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  String generateBillNumberWithRandom() {
    final now = DateTime.now();
    final rand = Random().nextInt(900000) + 100000; // 6-digit random
    final formatted = "${now.month.toString().padLeft(2, '0')}$rand${now.day.toString().padLeft(2, '0')}";
    return "${formatted}";
  }
}