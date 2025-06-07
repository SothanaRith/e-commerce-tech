import 'dart:developer';

import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/category_home_screen_widget.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/home_top_bar_screen_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/slider_custom_widget.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      homeController.loadHome(
        page: homeController.currentPage,
        context: context,
        userId: UserStorage.currentUser?.id.toString() ?? '',
      );
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (!homeController.isLoading && homeController.hasMore) {
          homeController.currentPage++;
          homeController.update();
          homeController.loadHome(
            page: homeController.currentPage,
            context: context,
            userId: UserStorage.currentUser?.id.toString() ?? '',
          );
        } else {
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
        builder: (controller) => SingleChildScrollView(
          controller: scrollController,
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
                  itemCount: controller.hasMore && controller.isLoading
                      ? controller.products.length + 1
                      : controller.products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    if (index < controller.products.length) {
                      final product = controller.products[index];
                      return ItemCardWidget(product: product, onUpdateCheckOut: () {
                        homeController.loadHome(page: 1, userId: UserStorage.currentUser?.id.toString() ?? '', context: context);
                      },
                        onUpdateWishlist: () {
                          homeController.loadHome(page: 1, userId: UserStorage.currentUser?.id.toString() ?? '', context: context);
                        }, parentContext: context,);
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
        ),
      ),
    );
  }
}
