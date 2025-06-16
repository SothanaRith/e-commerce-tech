import 'dart:async';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class PaymentController extends GetxController {
  var deeplink = '';  // Observable variable for Deeplink
  var transactionStatus = '';  // Observable variable for Transaction Status
  var isLoading = false;  // Observable variable for loading state
  var isPaymentSuccess = false;  // Observable variable for loading state
  var qrCode = '';
  var md5 = '';
  final StreamController<String> _statusStreamController = StreamController<String>.broadcast(); // Broadcast stream

  // Backend URL for Deeplink Generation and Transaction Status check
  final String apiUrl = 'https://bfae-58-97-218-118.ngrok-free.app/api/payment'; // Replace with your backend URL

  // Method to generate Deeplink by sending QR data to the backend
  Future<void> generateDeeplink(String qrCode, String appIconUrl, String appName, String appDeepLinkCallback) async {
    isLoading = true;
    update();
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/generate-deeplink'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'qrCode': qrCode,
          'appIconUrl': appIconUrl,
          'appName': appName,
          'appDeepLinkCallback': appDeepLinkCallback
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        deeplink = data['data']['shortLink'];
        update();// Assuming response data contains 'shortLink'
        await launchInBrowser(Uri.parse(deeplink));
        // await openBakongApp(deeplink.value);
      } else {
        deeplink = 'Failed to generate deeplink';
        update();
      }

    } catch (e) {
      deeplink = 'Error: $e';
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> openBakongApp(String bakongDeeplink ) async {
    // Check if the URL can be launched
    if (await canLaunch(bakongDeeplink)) {
      await launch(bakongDeeplink);  // Launch the Bakong deeplink
    } else {
      throw 'Could not open the Bakong app';
    }
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> checkTransactionStatus(String md5) async {
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
            (List<int> chunk) {
          String responseData = String.fromCharCodes(chunk);
          _statusStreamController.add(responseData); // Add data to stream
        },
        onDone: () {
          print("Stream finished.");
          isLoading = false;
          isPaymentSuccess = true;
          _statusStreamController.add("Transaction check completed.");
          update();
        },
        onError: (e) {
          print("Error: $e");
          isPaymentSuccess = false;
          _statusStreamController.add("Error occurred while checking transaction");
          isLoading = false;
          update();
        },
      );
    } catch (e) {
      _statusStreamController.add("Error: $e");
      isPaymentSuccess = false;
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
  Future<void> generateKHQR(String type) async {
    isLoading = true;
    update();
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/generate-khqr'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'type': type}), // Sending the type (merchant/individual)
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        qrCode = data['qrCode'];  // Store the generated QR code
        md5 = data['md5'];  // Store the generated QR code
        update();
      } else {
        qrCode = 'Failed to generate QR code';
        update();
      }
    } catch (e) {
      qrCode = 'Error: $e';
      update();
    } finally {
      isLoading = false;
      update();
    }
  }
}