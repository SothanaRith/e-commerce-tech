import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/category_home_screen_widget.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/home_top_bar_screen_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/slider_custom_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => SingleChildScrollView(
        controller: homeController.scrollController,
        padding: const EdgeInsets.only(bottom: 132),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: HomeTopBarScreenWidget(),
            ),
            const SizedBox(height: 12),
            const ImageSlider(
              imageUrls: [
                'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
                'https://i.pinimg.com/736x/43/61/09/4361091dd491bacbbcdbaa0be7a2d2be.jpg',
              ],
              height: 200,
            ),
            const SizedBox(height: 12),
            const CategoryHomeScreenWidget(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AppText.title2(
                "All Product",
                customStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: homeController.hasMore.value && homeController.isLoading.value
                    ? homeController.products.length + 1
                    : homeController.products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  if (index < homeController.products.length) {
                    final product = homeController.products[index];
                    return ItemCardWidget(
                      product: product,
                      onUpdateCheckOut: () {
                        homeController.loadHome(page: 1, userId: UserStorage.currentUser?.id.toString() ?? '', context: context);
                      },
                      onUpdateWishlist: () {
                        homeController.loadHome(page: 1, userId: UserStorage.currentUser?.id.toString() ?? '', context: context);
                      },
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}

