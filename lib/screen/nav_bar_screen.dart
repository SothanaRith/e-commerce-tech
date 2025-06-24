import 'dart:math';

import 'package:e_commerce_tech/controllers/home_controller.dart';
import 'package:e_commerce_tech/controllers/order_contoller.dart';
import 'package:e_commerce_tech/controllers/payment_controller.dart';
import 'package:e_commerce_tech/controllers/search_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/home_page/home_screen.dart';
import 'package:e_commerce_tech/screen/payment/payment_verify_screen.dart';
import 'package:e_commerce_tech/screen/profile_setting_page/profile_screen.dart';
import 'package:e_commerce_tech/screen/search_page/search_screen.dart';
import 'package:e_commerce_tech/screen/wish_list_page/wish_list_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
    // TODO: implement initState
    setState(() {
      currentPageIndex = widget.currentPageIndex;
    });
    Future.delayed(Duration.zero, () async {
      if (PaymentStorage.isPaymentCompleted != null) {
        if (!PaymentStorage.isPaymentCompleted!){
          await checkPaymentProcess();
        }
      }
    });
    super.initState();
  }

  Future<void> checkPaymentProcess() async {
    paymentController.checkTransactionStatus(md5: PaymentStorage.md5 ?? '', context: context, isOpenApp: true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Prevents UI from resizing when keyboard appears
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
              child: IgnorePointer(
                ignoring: MediaQuery.of(context).viewInsets.bottom != 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: MediaQuery.of(context).viewInsets.bottom == 0 ? 1.0 : 0.0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 70,
                    decoration: BoxDecoration(
                      color: theme.disabledColor,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: GNav(
                      color: theme.highlightColor,
                      activeColor: theme.disabledColor,
                      tabBackgroundColor: theme.secondaryHeaderColor,
                      padding: const EdgeInsets.all(12),
                      selectedIndex: currentPageIndex,
                      gap: 8,
                      tabs: [
                        GButton(
                          icon: Icons.h_mobiledata,
                          leading: SvgPicture.asset("assets/images/icons/home.svg", width: 40, color: theme.highlightColor),
                          text: '',
                        ),
                        GButton(
                          icon: Icons.store,
                          leading: SvgPicture.asset("assets/images/icons/store.svg", width: 40, color: theme.highlightColor),
                          text: '',
                        ),
                        GButton(
                          icon: CupertinoIcons.heart,
                          leading: SvgPicture.asset("assets/images/icons/heart.svg", width: 40, color: theme.highlightColor),
                          text: '',
                        ),
                        GButton(
                          icon: Icons.person,
                          leading: SvgPicture.asset("assets/images/icons/profile.svg", width: 40, color: theme.highlightColor),
                          text: '',
                        ),
                      ],
                      onTabChange: (value) {
                        if (value == 0) {
                          homeController.loadHome(page: 1, userId: UserStorage.currentUser?.id ?? '', context: context);
                        } else if (value == 1) {
                          searchController.searchProduct(context: context, userId: UserStorage.currentUser?.id ?? '');
                        } else if (value == 2) {
                          wishlistController.getAllWishlist(context: context, userId: UserStorage.currentUser?.id ?? '');
                        }
                        setState(() {
                          currentPageIndex = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
