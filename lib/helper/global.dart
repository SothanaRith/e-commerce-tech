import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

late final ApiRepository apiRepository;

String mainPoint = "http://10.10.101.55:3000"; // Default value

// late final String mainPoint = "https://c9f0-58-97-220-69.ngrok-free.app";

String formatDateString(String dateString) {
  try {
    // Parse the ISO 8601 string into a DateTime object
    DateTime date = DateTime.parse(dateString);
    // Format the DateTime object into a readable string
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  } catch (e) {
    print(e);
    return dateString; // Return original string if format fails
  }
}

Future<double> getExchangeRateUSDToKHR() async {
  final response = await http.get(Uri.parse('https://api.exchangerate.host/live?access_key=b1e22dad591ee383664a8bce731e0ac8&currencies=KHR'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['quotes'] != null) {
      return data['quotes']['USDKHR'];
    } else {
      return 4000;
    }
  } else {
    throw Exception('Failed to fetch exchange rate');
  }
}