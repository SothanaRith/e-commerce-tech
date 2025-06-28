import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:intl/intl.dart';

late final ApiRepository apiRepository;

String mainPoint = "http://192.168.0.102:3000"; // Default value

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