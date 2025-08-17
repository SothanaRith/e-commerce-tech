import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:e_commerce_tech/controllers/home_controller.dart';
import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/controllers/payment_controller.dart';
import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/chat_bot_page/chat_bot_screen.dart';
import 'package:e_commerce_tech/screen/home_page/home_screen.dart';
import 'package:e_commerce_tech/screen/payment/payment_verify_screen.dart';
import 'package:e_commerce_tech/screen/profile_setting_page/profile_screen.dart';
import 'package:e_commerce_tech/screen/search_page/search_screen.dart';
import 'package:e_commerce_tech/screen/wish_list_page/wish_list_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  final int currentPageIndex;
  const MainScreen({super.key, this.currentPageIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  HomeController homeController = Get.put(HomeController());
  WishlistController wishlistController = Get.put(WishlistController());
  SearchingController searchController = Get.put(SearchingController());
  PaymentController paymentController = Get.put(PaymentController());
  OrderController orderController = Get.put(OrderController());

  final pagesList = [
    const HomeScreen(),
    const SearchScreen(),
    const WishListScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.currentPageIndex;

    Future.delayed(Duration.zero, () async {
      if (PaymentStorage.isPaymentCompleted != null &&
          !PaymentStorage.isPaymentCompleted!) {
        await checkPaymentProcess();
      }
    });
  }

  Future<void> checkPaymentProcess() async {
    paymentController.checkTransactionStatus(
      md5: PaymentStorage.md5 ?? '',
      context: context,
      isOpenApp: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            IndexedStack(
              index: currentPageIndex,
              children: pagesList,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: IgnorePointer(
                      ignoring: MediaQuery.of(context).viewInsets.bottom != 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: MediaQuery.of(context).viewInsets.bottom == 0
                            ? 1.0
                            : 0.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 15),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.7), // translucent base color
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(color: theme.secondaryHeaderColor.withAlpha(30), blurRadius: 10),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildNavItem(CupertinoIcons.house_fill, "home".tr, 0),
                                    _buildNavItem(CupertinoIcons.search_circle_fill, "search".tr, 1),
                                    _buildNavItem(CupertinoIcons.square_favorites_alt_fill, "wish_list".tr, 2),
                                    _buildNavItem(CupertinoIcons.person_alt_circle, "profile".tr, 3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = currentPageIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentPageIndex = index;
        });

        final userId = UserStorage.currentUser?.id ?? '';

        if (index == 0) {
          homeController.loadHome(page: 1, userId: userId, context: context);
        } else if (index == 1) {
          searchController.searchProduct(context: context, userId: userId);
        } else if (index == 2) {
          wishlistController.getAllWishlist(context: context, userId: userId);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 400),
            scale: isActive ? 1.25 : 1.0,
            curve: Curves.easeOutBack,
            child: Icon(
              icon,
              color: isActive ? theme.primaryColor : theme.secondaryHeaderColor,
              size: 26,
            ),
          ),
          const SizedBox(height: 2),
          if(!isActive)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child:
            AppText.caption(
              label,
              key: ValueKey('active_$label'),
              customStyle: TextStyle(
                color: theme.secondaryHeaderColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
