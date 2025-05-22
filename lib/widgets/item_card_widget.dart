import 'dart:ffi';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/screen/product_details_page/product_details_screen.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ItemCardWidget extends StatefulWidget {
  final ProductModel product;
  const ItemCardWidget({
    super.key,
    required this.product,
  });

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {

  final WishlistController wishlistController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(id: widget.product.id.toString(),),));
        },
      child: Column(
        spacing: 2,
        children: [
          // Maintain aspect ratio for the image
          AspectRatio(
            aspectRatio: 1, // Square image
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("$mainPoint${widget.product.imageUrl?.first ?? ""}"),
                      fit: BoxFit.cover, // Ensure the image scales properly
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: widget.product.isInWishlist != "null" ?
                  GestureDetector(
                    onTap: () {
                      showCustomDialog(
                          context: context,
                          type: DialogType.info,
                          title: "Are you sure you want to ${widget.product.isInWishlist == 'true' ? "remove" : "add"} ${widget.product.name} to wishlist ?",
                          okOnPress: () {
                            if (widget.product.isInWishlist == 'true') {
                              wishlistController.deleteWishlist(context: context, userId: "1", productId: widget.product.id ?? '');
                            } else {
                              wishlistController.createWishlist(context: context, userId: "1", productId: widget.product.id ?? '');
                            }
                          },
                          cancelOnPress: () {

                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                        color: widget.product.isInWishlist == 'true' ? theme.primaryColor : Colors.white.withAlpha(150),
                      ),
                      child: widget.product.isInWishlist == 'true' ? SvgPicture.asset("assets/images/icons/heart.svg", width: 20, color: Colors.white,) : SvgPicture.asset("assets/images/icons/heart.svg", width: 20,),
                    ),
                  ) : SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.title2(widget.product.name ?? '', customStyle: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis, ),
                    maxLines: 1,
                    ),
                    AppText.title1(
                      '\$${widget.product.price}', customStyle: TextStyle(color: theme.primaryColor, fontSize: 14, overflow: TextOverflow.ellipsis,),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6,),
              GestureDetector(
                onTap: () {

                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(120),
                    color: theme.primaryColor.withAlpha(30),
                  ),
                  child: SvgPicture.asset("assets/images/icons/add_store.svg", width: 20,),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
