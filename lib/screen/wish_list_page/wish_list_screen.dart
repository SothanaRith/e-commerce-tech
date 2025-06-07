import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  final WishlistController wishlistController = Get.put(WishlistController());

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  void fetchWishlist() async {
    Future.delayed(Duration.zero, () async {
      await wishlistController.getAllWishlist(
        context: context,
        userId: UserStorage.currentUser?.id.toString() ?? '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WishlistController>(builder: (logic) {
      return Scaffold(
        appBar: customAppBar(type: this,
            title: "Wish list",
            context: context,
            haveArrowBack: false),
        body: logic.isLoading
            ? Center(child: Text("no data"),)
            : SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12),
              GridCustomWidget(
                items: logic.wishlistData.map((item) {
                  final product = item.product;
                  if (product != null) {
                    return ItemCardWidget(
                      product: product,
                      parentContext: context,
                      onUpdateWishlist: () {
                        fetchWishlist();
                      },
                      onUpdateCheckOut: () {
                        fetchWishlist();
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                }).toList(),
              ),
              SizedBox(height: 130),
            ],
          ),
        ),
      );
    });
  }
}

