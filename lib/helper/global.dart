import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:intl/intl.dart';

late final ApiRepository apiRepository;

late final String mainPoint = "https://16f4-103-118-47-149.ngrok-free.app";
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