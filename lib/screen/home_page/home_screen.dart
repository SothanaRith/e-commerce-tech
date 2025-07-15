import 'dart:developer';

import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/product_details_page/product_details_screen.dart';
import 'package:e_commerce_tech/screen/profile_setting_page/last_order_widget.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/safe_network_image.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/category_home_screen_widget.dart';
import 'package:e_commerce_tech/screen/home_page/widgets/home_top_bar_screen_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/slider_custom_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final WishlistController wishlistController = Get.put(WishlistController());
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
      body: RefreshIndicator(
        onRefresh: () async {
          homeController.currentPage = 1;
          homeController.hasMore = true;
          homeController.update();
          await homeController.loadHome(
            page: homeController.currentPage,
            context: context,
            userId: UserStorage.currentUser?.id.toString() ?? '',
          );
        },
        child: GetBuilder<HomeController>(
          builder: (controller) => Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height / 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    theme.primaryColor.withAlpha(50),
                    theme.primaryColor.withAlpha(30),
                    theme.primaryColor.withAlpha(10),
                    Colors.transparent
                  ], end: Alignment.bottomCenter, begin: Alignment.topCenter),
                ),
              ),
              SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.only(bottom: 132),
                physics: AlwaysScrollableScrollPhysics(),
                child: Skeletonizer(
                  enabled: controller.currentPage == 1 && controller.isLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: HomeTopBarScreenWidget(unReadNotification: controller.totalUnReadNotification,),
                      ),
                      const SizedBox(height: 12),
                      ImageSlider(
                        imageUrls: homeController.imagesSlide,
                        height: 200,
                      ),
                      const SizedBox(height: 18),
                      LastOrderWidget(),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: AppText.title2(
                          "New Arrival".tr,
                          customStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: IntrinsicWidth(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: controller.products.take(10).map((product) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsScreen(id: product.id.toString(), onBackAction: () {
                                        homeController.loadHome(page: 1, userId: UserStorage.currentUser?.id.toString() ?? '', context: context);
                                      }),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 140,
                                      margin: EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadiusGeometry.circular(12),
                                        image: DecorationImage(image: NetworkImage(safeImageUrl(product.imageUrl?.first ?? ''), ), fit: BoxFit.cover)
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,
                                      right: 18,
                                      child: product.isInWishlist != "null"
                                          ? GestureDetector(
                                        onTap: () {
                                          if (product.isInWishlist == 'true') {
                                            wishlistController.deleteWishlist(
                                              context: context,
                                              userId: UserStorage.currentUser?.id.toString() ?? '',
                                              productId: product.id ?? '',
                                            ).then((_) => homeController.loadHome(page: 1, userId: UserStorage.currentUser?.id.toString() ?? '', context: context));
                                          } else {
                                            wishlistController.createWishlist(
                                              context: context,
                                              userId: UserStorage.currentUser?.id.toString() ?? '',
                                              productId: product.id ?? '',
                                            ).then((_) => homeController.loadHome(page: 1, userId: UserStorage.currentUser?.id.toString() ?? '', context: context));
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(120),
                                            color: product.isInWishlist == 'true'
                                                ? theme.primaryColor
                                                : Colors.white.withAlpha(180),
                                          ),
                                          child: product.isInWishlist == 'true'
                                              ? SvgPicture.asset(
                                            "assets/images/icons/heart.svg",
                                            width: 16,
                                            color: Colors.white,
                                          )
                                              : SvgPicture.asset(
                                            "assets/images/icons/heart.svg",
                                            width: 16,
                                          ),
                                        ),
                                      )
                                          : SizedBox(),
                                    ),
                                    Positioned(
                                      bottom: -12,
                                      child: Container(
                                        width: 200,
                                        height: 50,
                                        margin: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                            color: theme.primaryColor.withAlpha(100)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AppText.title2(product.name ?? '', customStyle: TextStyle(color: theme.secondaryHeaderColor),),
                                              Flexible(child: AppText.caption(product.description ?? '', customStyle: TextStyle(color: theme.secondaryHeaderColor), maxLines: 1,)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const CategoryHomeScreenWidget(),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: AppText.title2(
                          "all_product".tr,
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
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.73,
                          ),
                          itemBuilder: (itemContext, index) {
                            if (index < controller.products.length) {
                              final product = controller.products[index];
                              return ItemCardWidget(product: product,
                                onBackAction: () {
                                  homeController.loadHome(page: 1, userId: UserStorage.currentUser?.id.toString() ?? '', context: context);
                                },
                                onUpdateCheckOut: () {
                                homeController.loadHome(page: 1, userId: UserStorage.currentUser?.id.toString() ?? '', context: context);
                              },
                                onUpdateWishlist: () {
                                  homeController.loadHome(page: 1, userId: UserStorage.currentUser?.id.toString() ?? '', context: context);
                                }, parentContext: context);
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
            ],
          ),
        ),
      ),
    );
  }
}
