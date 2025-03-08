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

// setup theme color and text
final ThemeController themeController = Get.find<ThemeController>();
ThemeData get theme => themeController.theme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, Map<String, String>> _languages = await dep.init();

  Get.put(ThemeController());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp(
      languages: _languages,
    ));
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
          designSize:
              const Size(375, 812), // Reference screen size (width x height)
          minTextAdapt: true, // Adapts text size
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              initialBinding: AllBinding(),
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              locale: localizationController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(AppConstants.language[0].languageCode,
                  AppConstants.language[0].countryCode),
              initialRoute: RouteHelper.getSplashRoute(),
              getPages: RouteHelper.routes,
            );
          });
    });
  }
}
