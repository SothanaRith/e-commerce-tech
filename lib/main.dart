import 'package:e_commerce_tech/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_tech/controllers/language_controller.dart';
import 'package:e_commerce_tech/utils/dep.dart' as dep;
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/app_route.dart';
import 'package:e_commerce_tech/utils/messages.dart';

// setup theme color and text
final ThemeController themeController = Get.find<ThemeController>();
ThemeData get theme => themeController.theme;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> _languages = await dep.init();
  Get.put(ThemeController());
  runApp( MyApp(languages: _languages,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.languages});
  final Map<String , Map<String, String>> languages;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
          return GetMaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            locale: localizationController.locale,
            translations: Messages(languages: languages),
            fallbackLocale: Locale(AppConstants.language[0].languageCode,
                AppConstants.language[0].countryCode

            ),
            initialRoute: RouteHelper.getSplashRoute(),
            getPages: RouteHelper.routes,
          );
        });
  }
}
