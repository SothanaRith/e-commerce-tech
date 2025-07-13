import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_tech/controllers/cart_controller.dart';
import 'package:e_commerce_tech/controllers/product_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/screen/category/product_by_category.dart';
import 'package:e_commerce_tech/screen/chat_bot_page/chat_bot_screen.dart';
import 'package:e_commerce_tech/screen/check_out_page/check_out_screen.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:e_commerce_tech/widgets/flexible_image_preview_widget.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_horizontal_widget.dart';
import 'package:e_commerce_tech/widgets/safe_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../theme/shadow.dart';
import '../../widgets/custom_button_widget.dart';
import '../my_order_page/my_order_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.id, this.onBackAction});

  final String id;
  final Function()? onBackAction;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductController productController = Get.put(ProductController());
  final WishlistController wishlistController = Get.put(WishlistController());

  final CartController cartController = Get.put(CartController());

  int _dialogQuantity = 1;

  void _showAddToCartQuantityDialog() {
    _dialogQuantity =
    productController.product.cartQuantity == 0 ? 1 : productController.product
        .cartQuantity ?? 1;
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'Select Quantity',
      body: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Column(
              children: [
                AppText.title('Select Quantity'),
                SizedBox(height: 10,),
                AppText.body2('Before add to cart you need to insert quantity'),
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
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(width: 20),
                    // Increment Button
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 32,
                      onPressed: () {
                        setState(() {
                          if (int.parse(
                              productController.product.totalStock ?? '0') >
                              _dialogQuantity)
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
          context: context,
          userId: UserStorage.currentUser?.id.toString() ?? '',
          productId: productController.product.id ?? '0',
          quantity: _dialogQuantity.toString(),
        ).then((value) {
          productController.getProductById(context: context,
              id: widget.id,
              userId: UserStorage.currentUser?.id ?? '');
        },);
      },
    ).show();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await productController.getProductById(
        context: context,
        id: widget.id, userId: UserStorage.currentUser?.id.toString() ?? '',
      );
      await cartController.fetchTotalItemsInCart(
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GetBuilder<ProductController>(
        builder: (controller) {
          var product = controller.product;
          return Skeletonizer(
            enabled: controller.isLoading,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header image + thumbnails
                      SizedBox(
                        height: MediaQuery
                            .sizeOf(context)
                            .height / 1.5,
                        width: MediaQuery
                            .sizeOf(context)
                            .width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (controller.selectedImageUrl.isNotEmpty)
                              GestureDetector(
                                onTap: () =>
                                    goTo(this, FlexibleImagePreview(
                                        image: controller.selectedImageUrl)),
                                child: CachedNetworkImage(
                                  imageUrl: safeImageUrl(
                                      controller.selectedImageUrl),
                                  placeholder: (context, url) =>
                                      Center(child: CircularProgressIndicator(
                                          color: theme.primaryColor)),
                                  errorWidget: (context, url,
                                      error) => const Icon(Icons.error),
                                  height: MediaQuery
                                      .sizeOf(context)
                                      .height / 1.5 - 35,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery
                                    .sizeOf(context)
                                    .width * 0.90,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: theme.secondaryHeaderColor,
                                ),
                                child: ListViewHorizontalWidget(
                                  horizontalPadding: 4,
                                  height: 60,
                                  items: List.generate(
                                    product.imageUrl?.length ?? 0,
                                        (index) {
                                      final url = product.imageUrl![index];
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            controller.selectedImageUrl = url;
                                          });
                                        },
                                        child: Container(
                                          margin:
                                          const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                5),
                                            border: Border.all(
                                              color: controller
                                                  .selectedImageUrl == url
                                                  ? theme.primaryColor
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  safeImageUrl("$url")),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              right: 25,
                              child: GestureDetector(
                                onTap: () {
                                  if (product.isInWishlist == 'true') {
                                    wishlistController.deleteWishlist(
                                        context: context,
                                        userId: UserStorage.currentUser?.id
                                            .toString() ?? '',
                                        productId: product.id ?? '').then((
                                        value) {
                                      productController.getProductById(
                                          context: context,
                                          id: widget.id,
                                          userId: UserStorage.currentUser
                                              ?.id ?? "");
                                    },);
                                  } else {
                                    wishlistController.createWishlist(
                                        context: context,
                                        userId: UserStorage.currentUser?.id
                                            .toString() ?? '',
                                        productId: product.id ?? '').then((
                                        value) {
                                      productController.getProductById(
                                          context: context,
                                          id: widget.id,
                                          userId: UserStorage.currentUser
                                              ?.id ?? "");
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: product.isInWishlist == 'true'
                                            ? theme.primaryColor
                                            : Colors.white.withAlpha(150),
                                      ),
                                      child: product.isInWishlist == 'true'
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
                                    const SizedBox(width: 6),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Name + description + price
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          goTo(this, ProductByCategoryScreen(categoryId: product.category?.id ?? '', categoryName: product.category?.name ?? ''));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: theme.primaryColor,
                                              borderRadius: BorderRadius.circular(100)
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: safeImageUrl(
                                                        product.category?.imageUrl ?? ''),
                                                    placeholder: (context, url) =>
                                                        Center(child: CircularProgressIndicator(
                                                            color: theme.primaryColor)),
                                                    errorWidget: (context, url,
                                                        error) => const Icon(Icons.error),
                                                    height: 40, fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(width: 4,),
                                                  AppText.title2(product.category?.name ?? '', customStyle: TextStyle(color: theme.secondaryHeaderColor),),
                                                ],
                                              ),
                                              Icon(Icons.navigate_next_outlined, color: theme.secondaryHeaderColor,)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      AppText.h3(
                                        product.name ?? "",
                                        maxLines: 2,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      AppText.caption(
                                        product.description ?? "",
                                        maxLines: 4,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AppText.h2(
                                            "\$${product.price}",
                                            customStyle: TextStyle(
                                                color: theme.primaryColor),
                                          ),
                                          AppText.body2(
                                            "${product.totalStock} in Stock",
                                            maxLines: 4,
                                            customStyle: TextStyle(color: theme.primaryColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Divider(
                                thickness: 0.1, color: theme.highlightColor),
                          ],
                        ),
                      ),
                      if (product.reviews != null &&
                          product.reviews!.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: AppText.title("reviews".tr),
                        ),
                        const SizedBox(height: 12),
                        ListViewHorizontalWidget(
                          height: 160,
                          items: List.generate(product.reviews?.length ?? 0,
                                  (index) {
                                final review = product.reviews![index];
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: theme.secondaryHeaderColor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText.title1(
                                              review.user?.name ?? "Anonymous"),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .end,
                                            children: [
                                              Row(
                                                children: List.generate(
                                                  int.tryParse(
                                                      review.rating ?? '0') ??
                                                      0,
                                                      (index) =>
                                                  const Icon(
                                                    Icons.star_rounded,
                                                    size: 18,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      AppText.caption(review.comment ?? ""),
                                      const SizedBox(height: 10),
                                      if (review.images != null &&
                                          review.images!.isNotEmpty)
                                        ListViewHorizontalWidget(
                                          horizontalPadding: 4,
                                          items: List.generate(
                                              review.images!.length, (i) {
                                            final imageUrl = "${review
                                                .images![i]}";
                                            return GestureDetector(
                                              onTap: () {
                                                goTo(this, FlexibleImagePreview(
                                                    image: imageUrl));
                                              },
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(5),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        safeImageUrl(imageUrl)),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                          height: 60,
                                        ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],

                      if (product.variants != null &&
                          product.variants!.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: product.variants?[0].variantAttributes
                                ?.map((attribute) {
                              return Row(
                                children: [
                                  AppText.body(
                                    "${attribute.name}: ",
                                    customStyle: TextStyle(
                                        color: theme.highlightColor),
                                  ),
                                  SizedBox(width: 8),
                                  AppText.title(
                                    "${attribute.value}",
                                    customStyle: TextStyle(
                                        color: theme.primaryColor),
                                  ),
                                ],
                              );
                            }).toList() ?? [],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (product.relatedProducts != null &&
                          product.relatedProducts!.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: AppText.title1("related_products".tr),
                        ),
                        GridCustomWidget(
                          items: List.generate(
                              product.relatedProducts?.length ?? 0, (index) {
                            final related = product.relatedProducts![index];
                            return ItemCardWidget(
                              product: related,
                              parentContext: context,
                              onUpdateWishlist: () {
                                productController.getProductById(
                                    context: context,
                                    id: widget.id,
                                    userId: UserStorage.currentUser?.id ?? '');
                              },
                              onUpdateCheckOut: () {
                                productController.getProductById(
                                    context: context,
                                    id: widget.id,
                                    userId: UserStorage.currentUser?.id ?? '');
                              },
                              onBackAction: () {
                                productController.getProductById(
                                    context: context,
                                    id: widget.id,
                                    userId: UserStorage.currentUser?.id ?? '');
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
                // Back Button
                Positioned(
                  top: 50,
                  left: 25,
                  child: InkWell(
                    onTap: () =>
                    {
                      widget.onBackAction?.call(),
                      popBack(this)
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.secondaryHeaderColor.withAlpha(90),
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
            color: theme.secondaryHeaderColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0)),
            boxShadow: [
              BoxShadow(color: Colors.grey.withAlpha(60),
                blurRadius: 10,
                offset: Offset(0, 2),)
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 6,
          children: [
            GestureDetector(
                onTap: () {
                  goTo(this, ChatScreen());
                },
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: theme.primaryColor)
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(CupertinoIcons.chat_bubble_fill,
                        color: theme.primaryColor))),
            GetBuilder<CartController>(builder: (cartLogic) {
              return GestureDetector(
                onTap: () {
                  goTo(this, CheckOutScreen());
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: theme.highlightColor),
                          shape: BoxShape.circle
                      ),
                      margin: EdgeInsets.only(left: 5),
                      padding: EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: Icon(Icons.shopping_cart_rounded,
                          color: theme.highlightColor),
                    ),
                    Positioned(
                      top: -6,
                      left: 0,
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 1, color: theme.secondaryHeaderColor),
                              color: Colors.red
                          ),
                          padding: EdgeInsets.all(6),
                          child: AppText.body1(cartLogic.totalItemsInCart.toString(), customStyle: TextStyle(
                              color: theme.secondaryHeaderColor),)),
                    )
                  ],
                ),
              );
            }),
            Spacer(),
            Container(
              child: CustomButtonWidget(
                buttonStyle: BtnStyle.action,
                title: "Add to cart",
                action: () {
                  showMaterialModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    isDismissible: true,
                    enableDrag: true,

                    builder: (context) =>
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(color: Colors.transparent),
                            ),
                            DraggableScrollableSheet(
                              initialChildSize: 0.6,
                              minChildSize: 0.4,
                              maxChildSize: 0.95,
                              builder: (context, scrollController) {
                                return _buildCartBottomSheet(scrollController,
                                    productController.product);
                              },
                            ),
                          ],
                        ),
                  );
                },
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 2.5,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCartBottomSheet(ScrollController scrollController,
      ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        boxShadow: [defaultShadow()],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: MediaQuery
                        .sizeOf(context)
                        .width / 7,
                    margin: const EdgeInsets.all(16),
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                ),
                Container(
                    child: Column(
                      // children: product.variants?[0].variantAttributes?.map((attribute) {
                      //   return Row(
                      //     children: [
                      //       AppText.body(
                      //         "${attribute.name}: ",
                      //         customStyle: TextStyle(color: theme.highlightColor),
                      //       ),
                      //       SizedBox(width: 8),
                      //       AppText.title(
                      //         "${attribute.value}",
                      //         customStyle: TextStyle(color: theme.primaryColor),
                      //       ),
                      //     ],
                      //   );
                      // }).toList() ?? [],
                    )
                )
              ],
            );
          },
        ),
      ),
    );;
  }
}
