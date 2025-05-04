import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/controllers/product_controller.dart';
import 'package:e_commerce_tech/controllers/theme_controller.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:get/get.dart';

class AllBinding extends Bindings {

  @override
  void dependencies() {
    // Get.lazyPut(() => NewsLogic());
    Get.lazyPut(() => ThemeController());

    Get.lazyPut(() => ApiRepository());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => ProductController());

  }
}
