import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_tech/controllers/cart_controller.dart';
import 'package:e_commerce_tech/controllers/lacation_controller.dart';
import 'package:e_commerce_tech/controllers/product_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/cart_model.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/screen/category/product_by_category.dart';
import 'package:e_commerce_tech/screen/chat_bot_page/chat_bot_screen.dart';
import 'package:e_commerce_tech/screen/chat_with_store/chat_with_store_screen.dart';
import 'package:e_commerce_tech/screen/check_out_page/check_out_screen.dart';
import 'package:e_commerce_tech/screen/location_page/location_select_screen.dart';
import 'package:e_commerce_tech/screen/payment/payment_method_screen.dart';
import 'package:e_commerce_tech/screen/product_details_page/variant_widget.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarBackground = false;

  final LocationController locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && !_showAppBarBackground) {
        setState(() {
          _showAppBarBackground = true;
        });
      } else if (_scrollController.offset <= 100 && _showAppBarBackground) {
        setState(() {
          _showAppBarBackground = false;
        });
      }
    });

    Future.delayed(Duration.zero, () async {
      await cartController.fetchAllCart(context: context,
          userId: UserStorage.currentUser?.id.toString() ?? '');
      await locationController.getDefaultAddresses(context: context);
      await productController.getProductById(
        context: context,
        id: widget.id,
        userId: UserStorage.currentUser?.id.toString() ?? '',
      );
      await cartController.fetchTotalItemsInCart(
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (controller) {
      var product = controller.product;
      return Scaffold(
        body: Skeletonizer(
          enabled: controller.isLoading,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery
                          .sizeOf(context)
                          .width,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (controller.selectedImageUrl.isNotEmpty)
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      goTo(
                                          this,
                                          FlexibleImagePreview(
                                              image: controller
                                                  .selectedImageUrl)),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    safeImageUrl(controller.selectedImageUrl),
                                    placeholder: (context, url) =>
                                        Center(
                                            child: CircularProgressIndicator(
                                                color: theme.primaryColor)),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                    height:
                                    MediaQuery
                                        .sizeOf(context)
                                        .height / 1.5 -
                                        35,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 38,)
                              ],
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
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          border: Border.all(
                                            color:
                                            controller.selectedImageUrl ==
                                                url
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
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    AppText.h3(
                                      product.name ?? "",
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        goTo(
                                            this,
                                            ProductByCategoryScreen(
                                                categoryId:
                                                product.category?.id ??
                                                    '',
                                                categoryName:
                                                product.category?.name ??
                                                    ''));
                                      },
                                      child: Container(
                                        width: MediaQuery
                                            .sizeOf(context)
                                            .width / 2.1,
                                        decoration: BoxDecoration(
                                            color: theme.primaryColor,
                                            borderRadius:
                                            BorderRadius.circular(100)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .all(5.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadiusGeometry
                                                        .circular(100),
                                                    child: CachedNetworkImage(
                                                      imageUrl: safeImageUrl(
                                                          product.category
                                                              ?.imageUrl ??
                                                              ''),
                                                      placeholder: (context,
                                                          url) =>
                                                          Center(
                                                              child: CircularProgressIndicator(
                                                                  color: theme
                                                                      .primaryColor)),
                                                      errorWidget: (context,
                                                          url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                      height: 20,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                AppText.title2(
                                                  product.category?.name ??
                                                      '',
                                                  customStyle: TextStyle(
                                                      color: theme
                                                          .secondaryHeaderColor,
                                                      fontSize: 9),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0),
                                              child: Icon(
                                                Icons.navigate_next_outlined,
                                                color:
                                                theme.secondaryHeaderColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        AppText.h2(
                                          "\$${product.price}",
                                          customStyle: TextStyle(
                                              color: theme.primaryColor),
                                        ),
                                        AppText.body2(
                                          "${product.totalStock} in Stock",
                                          maxLines: 4,
                                          customStyle: TextStyle(
                                              color: theme.primaryColor),
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

                    if (product.variants != null &&
                        product.variants!.isNotEmpty) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: product.variants!.map((item) {
                            return GestureDetector(
                              onTap: () {
                                cartController.selectedVariant = null;
                                cartController.dialogQuantity = 0;
                                cartController.update();
                                showBottomBar(product: product);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: product.variants?[0].title ==
                                        item.title ? 12 : 0,
                                    right: product.variants?.last.title !=
                                        item.title ? 12 : 12),
                                child: VariantWidget(variants: item),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    Container(
                      width: MediaQuery
                          .sizeOf(context)
                          .width,
                      height: 6,
                      color: theme.highlightColor.withAlpha(50),
                    ),
                    const SizedBox(height: 12),
                    if (product.reviews != null &&
                        product.reviews!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: AppText.title("reviews".tr),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                product.reviews?.length ?? 0,
                                    (index) {
                                  final review = product.reviews![index];
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            18),
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
                                                  review.user?.name ??
                                                      "Anonymous"),
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
                                          const SizedBox(height: 10),
                                          if(review.comment != '')...[
                                            AppText.caption(
                                                review.comment ?? ""),
                                            const SizedBox(height: 10),
                                          ],
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
                                                    goTo(
                                                        this,
                                                        FlexibleImagePreview(
                                                            image: imageUrl));
                                                  },
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          5),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            safeImageUrl(
                                                                imageUrl)),
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
                                    ),
                                  );
                                }),
                          ),
                        ),
                      )
                    ],
                    const SizedBox(height: 12),
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
                top: 0,
                child: Container(
                  width: MediaQuery
                      .sizeOf(context)
                      .width,
                  decoration: BoxDecoration(
                    color: _showAppBarBackground
                        ? Colors.grey.withAlpha(100)
                        : Colors.transparent,
                    boxShadow: _showAppBarBackground
                        ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
                        : [],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12.0, left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () =>
                            {
                              widget.onBackAction?.call(),
                              popBack(this)
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.secondaryHeaderColor.withAlpha(
                                    200),
                              ),
                              child: const Icon(Icons.arrow_back),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    goTo(this, ChatWithStoreScreen(
                                        senderId: UserStorage.currentUser
                                            ?.id ?? '', receiverId: "3"));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withAlpha(150),),
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                          CupertinoIcons.chat_bubble_fill,
                                          color: theme.primaryColor))),
                              SizedBox(width: 8,),
                              GetBuilder<CartController>(
                                  builder: (cartLogic) {
                                    return GestureDetector(
                                      onTap: () {
                                        goTo(this, CheckOutScreen());
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white.withAlpha(
                                                    150),
                                                shape: BoxShape.circle
                                            ),
                                            margin: EdgeInsets.only(left: 5),
                                            padding:
                                            EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                            child: Icon(
                                                Icons.shopping_cart_rounded,
                                                color: theme.primaryColor),
                                          ),
                                          Positioned(
                                            top: -5,
                                            left: 0,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors
                                                            .transparent),
                                                    color: Colors.red),
                                                padding: EdgeInsets.all(6),
                                                child: AppText.body1(
                                                  cartLogic.totalItemsInCart
                                                      .toString(),
                                                  customStyle:
                                                  TextStyle(color: theme
                                                      .secondaryHeaderColor),
                                                )),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                              SizedBox(width: 8,),
                              GestureDetector(
                                onTap: () {
                                  if (product.isInWishlist == 'true') {
                                    wishlistController
                                        .deleteWishlist(
                                        context: context,
                                        userId: UserStorage.currentUser?.id
                                            .toString() ??
                                            '',
                                        productId: product.id ?? '')
                                        .then(
                                          (value) {
                                        productController.getProductById(
                                            context: context,
                                            id: widget.id,
                                            userId:
                                            UserStorage.currentUser?.id ??
                                                "");
                                      },
                                    );
                                  } else {
                                    wishlistController
                                        .createWishlist(
                                        context: context,
                                        userId: UserStorage.currentUser?.id
                                            .toString() ??
                                            '',
                                        productId: product.id ?? '')
                                        .then((value) {
                                      productController.getProductById(
                                          context: context,
                                          id: widget.id,
                                          userId: UserStorage.currentUser
                                              ?.id ??
                                              "");
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
                                            ? Colors.red.shade700
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
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
              color: theme.secondaryHeaderColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(60),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              GetBuilder<CartController>(builder: (logic) {
                return Container(
                  child: GetBuilder<LocationController>(
                      builder: (logicLocation) {
                        return CustomButtonWidget(
                          buttonStyle: BtnStyle.none,
                          title: "buy_now".tr,
                          action: () {
                            final addressId = logicLocation.addressesDefault?.id;

                            if (addressId == null || addressId.isEmpty) {
                              showCustomDialog(
                                context: context,
                                type: CustomDialogType.info,
                                title: "please_add_your_addresses".tr,
                                okOnPress: () => goTo(this, LocationSelectScreen()),
                              );
                              return;
                            }

                            if (product.variants == null || product.variants!.isEmpty) {
                              showCustomDialog(
                                context: context,
                                type: CustomDialogType.info,
                                title: "variant is undefined".tr,
                                okOnPress: () => goTo(this, LocationSelectScreen()),
                              );
                              return;
                            }

                            final firstVariant = product.variants!.first;

                            if (firstVariant.isActive != "true" || int.parse(firstVariant.stock ?? '0') <= 0) {
                              showCustomDialog(
                                context: context,
                                type: CustomDialogType.info,
                                title: "product_are_not_available".tr,
                              );
                              return;
                            }

                            CartModel item = CartModel(
                              product: product,
                              priceAtPurchase: firstVariant.price,
                              variantId: firstVariant.id,
                              userId: UserStorage.currentUser?.id,
                              productId: product.id,
                              quantity: "1",
                              variant: firstVariant
                            );

                            List<CartModel> items = [];
                            items.add(item);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentMethodScreen(
                                  cart: items,
                                  addressId: addressId,
                                ),
                              ),
                            );
                          },
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2.5,
                        );
                      }),
                );
              }),
              Container(
                child: CustomButtonWidget(
                  buttonStyle: BtnStyle.action,
                  title: "add_to_cart".tr,
                  action: () {
                    cartController.selectedVariant = null;
                    cartController.dialogQuantity = 0;
                    cartController.update();
                    showBottomBar(product: productController.product);
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
    });
  }

  Future<void> showBottomBar({
    required ProductModel product,
  }) async {
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
                  return _buildCartBottomSheet(
                      scrollController, productController.product);
                },
              ),
            ],
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
            return GetBuilder<CartController>(builder: (logic) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Center(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6),
                    child: AppText.title(product.name ?? ''),
                  ),
                  if (product.imageUrl != null &&
                      product.imageUrl != 'null') ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(8),
                            child: CachedNetworkImage(
                              imageUrl:
                              safeImageUrl(product.imageUrl?.first ?? ''),
                              placeholder: (context, url) =>
                                  Center(
                                    child: CircularProgressIndicator(
                                        color: theme.primaryColor),
                                  ),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                              height: MediaQuery
                                  .sizeOf(context)
                                  .width / 4,
                              width: MediaQuery
                                  .sizeOf(context)
                                  .width / 4,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(logic.selectedVariant != null)...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppText.body('\$', customStyle: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold),),
                                  SizedBox(width: 3,),
                                  AppText.h3('${logic.selectedVariant?.price}',
                                    customStyle: TextStyle(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.bold),),
                                ],
                              ),
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   children: [
                              //     AppText.title2(
                              //       '\៛',
                              //       customStyle: TextStyle(color: theme.primaryColor),
                              //     ),
                              //     SizedBox(width: 2,),
                              //     AppText.title(
                              //       ' ${(double.parse(logic.selectedVariant?.price ?? '0') * rate).toStringAsFixed(2)}',
                              //       customStyle: TextStyle(color: theme.primaryColor),
                              //     ),
                              //   ],
                              // ),
                            ],
                            SizedBox(height: 4,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (logic.dialogQuantity > 0) {
                                      logic.dialogQuantity--;
                                      logic.update();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadiusGeometry
                                            .circular(8),
                                        color: theme.primaryColor.withAlpha(50)
                                    ),
                                    child: AppText.body2("-",
                                      customStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: theme.primaryColor),),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: AppText.body(
                                    '${logic.dialogQuantity}',
                                    customStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: theme.highlightColor),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (logic.selectedVariant != null) {
                                      if (int.parse(
                                          logic.selectedVariant?.stock ?? '0') >
                                          logic.dialogQuantity) {
                                        logic.dialogQuantity++;
                                        logic.update();
                                      }
                                    } else {
                                      Get.snackbar(
                                        'Missing Information',
                                        'please_select_variant_first',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red.withOpacity(
                                            0.5),
                                        colorText: Colors.white,
                                        duration: Duration(seconds: 1),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadiusGeometry
                                            .circular(8),
                                        color: theme.primaryColor.withAlpha(50)
                                    ),
                                    child: AppText.body2("+",
                                      customStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: theme.primaryColor),),
                                  ),
                                ),
                                SizedBox(width: 16,),
                                AppText.title2(
                                  "${logic.selectedVariant?.stock ??
                                      '0'}'s in stock now",
                                  customStyle: TextStyle(
                                      color: theme.highlightColor,
                                      fontWeight: FontWeight.w400),),

                              ],),
                            SizedBox(height: 12,),
                            GestureDetector(
                              onTap: () {
                                if (logic.selectedVariant == null &&
                                    logic.dialogQuantity == 0) {
                                  Get.snackbar(
                                    'Missing Information',
                                    'please_select_variant_first',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red.withOpacity(
                                        0.5),
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 2),
                                  );
                                  return;
                                }
                                logic
                                    .addItemToCart(
                                  context: context,
                                  userId: UserStorage.currentUser?.id
                                      .toString() ?? '',
                                  productId: productController.product.id ??
                                      '0',
                                  quantity: logic.dialogQuantity.toString(),
                                  variant: logic.selectedVariant ?? Variants(),
                                )
                                    .then(
                                      (value) {
                                    productController.getProductById(
                                        context: context,
                                        id: widget.id,
                                        userId: UserStorage.currentUser?.id ??
                                            '');
                                    cartController.fetchTotalItemsInCart(
                                        context: context);
                                  },
                                );
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 32),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadiusGeometry
                                          .circular(100),
                                      color: theme.primaryColor
                                  ),
                                  child: AppText.body1("check_out".tr,
                                    customStyle: TextStyle(
                                        color: theme.secondaryHeaderColor,
                                        fontWeight: FontWeight.bold),)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                  SizedBox(height: 18,),
                  Container(width: double.infinity,
                    height: 4,
                    color: theme.highlightColor.withAlpha(30),),
                  SizedBox(height: 10,),
                  if (product.variants != null &&
                      product.variants!.isNotEmpty) ...[
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: product.variants!.map((item) {
                            return GestureDetector(
                              onTap: () {
                                if (item.isActive == "false" ||
                                    int.parse(item.stock ?? '0') <= 0) {
                                  return;
                                }
                                logic.selectedVariant = item;
                                logic.dialogQuantity = 1;
                                logic.update();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: product.variants?[0].title == item.title
                                      ? 10
                                      : 0,
                                  bottom: product.variants?.last.title !=
                                      item.title ? 10 : 10,
                                  left: 12,
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          width: 2,
                                          color: logic.selectedVariant == item
                                              ? theme.primaryColor
                                              : Colors.transparent,
                                        ),
                                      ),
                                      child: VariantWidget(
                                        variants: item,
                                        isSelected: logic.selectedVariant ==
                                            item,
                                      ),
                                    ),
                                    if (item.isActive == "false" ||
                                        int.parse(item.stock ?? '0') <= 0)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: theme.secondaryHeaderColor
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(
                                                14),
                                          ),
                                          child: Center(
                                            child: AppText.title1(
                                                "not_available".tr),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              );
            });
          },
        ),
      ),
    );
    ;
  }
}
