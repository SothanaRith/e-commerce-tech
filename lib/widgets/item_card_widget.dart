import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/cart_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/screen/product_details_page/product_details_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
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
  final CartController cartController = Get.put(CartController());

  int _dialogQuantity = 1;

  void _showAddToCartQuantityDialog() {
    _dialogQuantity = widget.product.cartQuantity == 0 ? 1 : widget.product.cartQuantity ?? 1;
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'select_quantity'.tr,
      body: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Column(
              children: [
                AppText.title('select_quantity'.tr),
                SizedBox(height: 10,),
                AppText.body2('before_add_to_cart_you_need_to_insert_quantity'.tr),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Decrement Button
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      iconSize: 32,
                      onPressed: () {
                        if (_dialogQuantity > 1) {
                          setState(() {
                            _dialogQuantity--;
                          });
                        }
                      },
                    ),

                    SizedBox(width: 20),

                    // Quantity display
                    Text(
                      '$_dialogQuantity',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(width: 20),

                    // Increment Button
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 32,
                      onPressed: () {
                        setState(() {
                          if (int.parse(widget.product.totalStock ?? '0') > _dialogQuantity )
                          _dialogQuantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        cartController.addItemToCart(
          context: widget.parentContext,
          userId: UserStorage.currentUser?.id.toString() ?? '',
          productId: widget.product.id ?? '0',
          quantity: _dialogQuantity.toString(),
        ).then((_) => widget.onUpdateCheckOut?.call());
      },
    ).show();
  }

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
                      showCustomDialog(
                        context: widget.parentContext,
                        type: DialogType.info,
                        title:
                        "Are you sure you want to ${widget.product.isInWishlist == 'true' ? "remove" : "add"} ${widget.product.name} to wishlist ?",
                          okOnPress: () {
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
                        cancelOnPress: () {},
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                        color: widget.product.isInWishlist == 'true'
                            ? theme.primaryColor
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
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.title2(
                      widget.product.name ?? '',
                      customStyle: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    AppText.title1(
                      '\$${widget.product.price}',
                      customStyle: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6),
              if(int.parse(widget.product.totalStock ?? '0') > 0)
              GestureDetector(
                onTap: () {
                  _showAddToCartQuantityDialog();
                },
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.product.isInCart == true
                            ? theme.primaryColor
                            : theme.primaryColor.withAlpha(30),
                      ),
                      child: SvgPicture.asset(
                        "assets/images/icons/add_store.svg",
                        width: 20,
                        color: widget.product.isInCart == true ? Colors.white : theme.primaryColor,
                      ),
                    ),
                    if (widget.product.isInCart == true)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: AppText.caption(
                            '${widget.product.cartQuantity}',
                            customStyle: TextStyle(
                              color: theme.secondaryHeaderColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
