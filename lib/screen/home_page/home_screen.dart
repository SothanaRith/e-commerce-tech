import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/search_page/search_screen.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/category_home_screen_widget.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/home_top_bar_screen_widget.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/slider_custom_widget.dart';
import 'package:flutter_svg/svg.dart';
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
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: HomeTopBarScreenWidget(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => goTo(context, const SearchScreen()),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width - 80,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 1, color: theme.primaryColor),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/icons/search.svg"),
                        const SizedBox(width: 12),
                        AppText.body1("Search something..."),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => goTo(context, const SearchScreen()),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: theme.primaryColor,
                    ),
                    child: SvgPicture.asset("assets/images/icons/filter.svg"),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content starts below search
          Expanded(
            child: Obx(() => SingleChildScrollView(
              controller: homeController.scrollController,
              padding: const EdgeInsets.only(bottom: 132),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      shrinkWrap: true,
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
                            imageUrl: 'https://epaymentuat.acledabank.com.kh:8544/files/PCAT1746158068408.jpg',
                            title: product.name ?? '',
                            price: '\$${product.price ?? ''}',
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
          ),
        ],
      ),
    );
  }
}

