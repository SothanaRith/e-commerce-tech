import 'package:e_commerce_tech/controllers/theme_controller.dart';
import 'package:get/get.dart';

class AllBinding extends Bindings {

  @override
  void dependencies() {
    // Get.lazyPut(() => NewsLogic());
    Get.lazyPut(() => ThemeController());

  }
}
