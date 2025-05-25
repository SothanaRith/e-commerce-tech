import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/models/wishlist_model.dart';
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

  List<WishlistModel> wishlist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  void fetchWishlist() async {
    Future.delayed(Duration.zero, () async {
      final data = await wishlistController.getAllWishlist(
        context: context,
        userId: "1", // 🔁 Replace with dynamic user ID
      );
      setState(() {
        wishlist = data;
        isLoading = false;
      });
      print("object === $wishlist");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(type: this, title: "Wish list", context: context, haveArrowBack: false),
      body: isLoading ? Center(child: Text("data"),) : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 6),
            SizedBox(height: 12),
            GridCustomWidget(
              items: wishlist.map((item) {
                final product = item.product;
                print("object== ${item.product}");
                if (product != null) {
                  return ItemCardWidget(
                      product: product
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
  }
}

