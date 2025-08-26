import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/controllers/cart_controller.dart';
import 'package:e_commerce_tech/controllers/chat_contoller.dart';
import 'package:e_commerce_tech/controllers/chat_with_store_controller.dart';
import 'package:e_commerce_tech/controllers/history_controller.dart';
import 'package:e_commerce_tech/controllers/home_controller.dart';
import 'package:e_commerce_tech/controllers/lacation_controller.dart';
import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/controllers/payment_controller.dart';
import 'package:e_commerce_tech/controllers/poster_controller.dart';
import 'package:e_commerce_tech/controllers/product_controller.dart';
import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/controllers/theme_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/helper/rest_api_helper.dart';
import 'package:get/get.dart';

class AllBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => ThemeController());

    Get.lazyPut(() => ApiRepository());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => ProductController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => SearchingController());
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => WishlistController());
    Get.lazyPut(() => OrderController());
    Get.lazyPut(() => LocationController());
    Get.lazyPut(() => PaymentController());
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => PosterController());
    Get.lazyPut(() => ChatWithStoreController());
    Get.lazyPut(() => HistoryController());

  }
}
