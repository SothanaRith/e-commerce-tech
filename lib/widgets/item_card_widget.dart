import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/cart_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/screen/category/product_by_category.dart';
import 'package:e_commerce_tech/screen/product_details_page/product_details_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:e_commerce_tech/widgets/safe_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ItemCardWidget extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onUpdateWishlist;
  final VoidCallback? onUpdateCheckOut;
  final BuildContext parentContext;
  final Function() onBackAction;
  const ItemCardWidget({
    super.key,
    required this.product, this.onUpdateWishlist, this.onUpdateCheckOut, required this.parentContext, required this.onBackAction,
  });

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  final WishlistController wishlistController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(id: widget.product.id.toString(), onBackAction: () { widget.onBackAction.call();}),
          ),
        );
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(safeImageUrl("${widget.product.imageUrl?.first}")),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: widget.product.isInWishlist != "null"
                      ? GestureDetector(
                    onTap: () {
                      if (widget.product.isInWishlist == 'true') {
                        wishlistController.deleteWishlist(
                          context: widget.parentContext,
                          userId: UserStorage.currentUser?.id.toString() ?? '',
                          productId: widget.product.id ?? '',
                        ).then((_) => widget.onUpdateWishlist?.call());
                      } else {
                        wishlistController.createWishlist(
                          context: widget.parentContext,
                          userId: UserStorage.currentUser?.id.toString() ?? '',
                          productId: widget.product.id ?? '',
                        ).then((_) => widget.onUpdateWishlist?.call());
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                        color: widget.product.isInWishlist == 'true'
                            ? Colors.red.shade700
                            : Colors.white.withAlpha(150),
                      ),
                      child: widget.product.isInWishlist == 'true'
                          ? SvgPicture.asset(
                        "assets/images/icons/heart.svg",
                        width: 20,
                        color: Colors.white,
                      )
                          : SvgPicture.asset(
                        "assets/images/icons/heart.svg",
                        width: 20,
                      ),
                    ),
                  )
                      : SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(widget.product.category != null)
                    GestureDetector(
                      onTap: () {
                        goTo(this, ProductByCategoryScreen(categoryId: widget.product.category?.id ?? '', categoryName: widget.product.category?.name ?? ''));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: theme.primaryColor.withAlpha(70)
                        ),
                        child: AppText.caption(
                          widget.product.category?.name ?? '',
                          customStyle: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColor
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        AppText.title2(
                          "${widget.product.totalStock}",
                          customStyle: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(width: 3,),
                        AppText.caption(
                          'in stock',
                          customStyle: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4,),
                AppText.title2(
                  widget.product.name ?? '',
                  customStyle: const TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.title1(
                      '\$${widget.product.price}',
                      customStyle: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
