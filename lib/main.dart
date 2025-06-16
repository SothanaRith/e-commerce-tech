import 'package:e_commerce_tech/controllers/theme_controller.dart';
import 'package:e_commerce_tech/widgets/all_get_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:e_commerce_tech/controllers/language_controller.dart';
import 'package:e_commerce_tech/utils/dep.dart' as dep;
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/app_route.dart';
import 'package:e_commerce_tech/utils/messages.dart';
import 'firebase_options.dart';
// Setup theme color and text
final ThemeController themeController = Get.find<ThemeController>();
ThemeData get theme => themeController.theme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // Initialize languages
  Map<String, Map<String, String>> _languages = await dep.init();

  // Load token and user data
  await TokenStorage.loadToken();
  await UserStorage.loadUser();

  // Initialize theme controller
  Get.put(ThemeController());

  // Set preferred orientation to portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp(languages: _languages)); // Start the app after initialization
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.languages});
  final Map<String, Map<String, String>> languages;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
          return ScreenUtilInit(
              designSize: const Size(375, 812), // Reference screen size (width x height)
              minTextAdapt: true, // Adapts text size to screen size
              splitScreenMode: true, // Enable split screen mode for larger screens
              builder: (context, child) {
                return GetMaterialApp(
                  title: 'Flutter Demo',
                  debugShowCheckedModeBanner: false, // Hide the debug banner
                  initialBinding: AllBinding(), // Initialize dependencies
                  theme: theme, // Use the dynamically set theme
                  locale: localizationController.locale, // Set the current locale
                  translations: Messages(languages: languages), // Language translations
                  fallbackLocale: Locale(AppConstants.language[0].languageCode,
                      AppConstants.language[0].countryCode), // Fallback locale
                  initialRoute: RouteHelper.getSplashRoute(), // Initial route
                  getPages: RouteHelper.routes, // Define your app routes
                );
              });
        });
  }
}
