import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/cart_controller.dart';
import 'package:e_commerce_tech/controllers/product_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/utils/app_constants.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:e_commerce_tech/widgets/custom_dialog.dart';
import 'package:e_commerce_tech/widgets/grid_custom_widget.dart';
import 'package:e_commerce_tech/widgets/item_card_widget.dart';
import 'package:e_commerce_tech/widgets/list_view_horizontal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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

  String? selectedImageUrl; // Track current main image

  final CartController cartController = Get.put(CartController());

  int _dialogQuantity = 1;

  void _showAddToCartQuantityDialog() {
    _dialogQuantity = productController.product.cartQuantity == 0 ? 1 : productController.product.cartQuantity ?? 1;
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
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(width: 20),

                    // Increment Button
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 32,
                      onPressed: () {
                        setState(() {
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
          productController.getProductById(context: context, id: widget.id, userId: UserStorage.currentUser?.id ?? '');
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
      setState(() {
        if (productController.product.imageUrl != null && productController.product.imageUrl!.isNotEmpty) {
          selectedImageUrl = productController.product.imageUrl!.first;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProductController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          var product = controller.product;
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header image + thumbnails
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 1.5,
                      width: MediaQuery.sizeOf(context).width,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (selectedImageUrl != null)
                            Positioned(
                              top: 0,
                              child: Image.network(
                                "$mainPoint$selectedImageUrl",
                                height:
                                MediaQuery.sizeOf(context).height / 1.5 - 35,
                                width: MediaQuery.sizeOf(context).width,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.90,
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
                                          selectedImageUrl = url;
                                        });
                                      },
                                      child: Container(
                                        margin:
                                        const EdgeInsets.symmetric(horizontal: 4),
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                            color: selectedImageUrl == url
                                                ? theme.primaryColor
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage("$mainPoint$url"),
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
                                showCustomDialog(
                                  context: context,
                                  type: DialogType.info,
                                  title:
                                  "Are you sure you want to ${product.isInWishlist == 'true' ? "remove" : "add"} ${product.name} to wishlist ?",
                                  okOnPress: () {
                                    if (product.isInWishlist == 'true') {
                                      wishlistController.deleteWishlist(
                                          context: context,
                                          userId: UserStorage.currentUser?.id.toString() ?? '',
                                          productId: product.id ?? '').then((value) {
                                            productController.getProductById(context: context, id: widget.id, userId: UserStorage.currentUser?.id ?? "");
                                          },);
                                    } else {
                                      wishlistController.createWishlist(
                                          context: context,
                                          userId: UserStorage.currentUser?.id.toString() ?? '',
                                          productId: product.id ?? '').then((value) {
                                        productController.getProductById(context: context, id: widget.id, userId: UserStorage.currentUser?.id ?? "");

                                      });
                                    }
                                  },
                                  cancelOnPress: () {},
                                );
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AppText.h3(
                                    "\$${product.price}",
                                    customStyle: TextStyle(color: theme.primaryColor),
                                  ),
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
                                            color: product.isInCart == true
                                                ? theme.primaryColor
                                                : theme.primaryColor.withAlpha(30),
                                          ),
                                          child: SvgPicture.asset(
                                            "assets/images/icons/add_store.svg",
                                            width: 20,
                                            color: product.isInCart == true ? Colors.white : theme.primaryColor,
                                          ),
                                        ),
                                        if (product.isInCart == true)
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
                                                '${product.cartQuantity}',
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
                          const SizedBox(height: 12),
                          Divider(thickness: 0.1, color: theme.highlightColor),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    if (product.reviews != null &&
                        product.reviews!.isNotEmpty) ...[
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText.title1(
                                            review.user?.name ?? "Anonymous"),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            AppText.caption(
                                                "Mar 30 2024"), // TODO: Add actual date if available
                                            Row(
                                              children: List.generate(
                                                int.tryParse(review.rating ?? '0') ?? 0,
                                                    (index) => const Icon(
                                                  Icons.star,
                                                  size: 16,
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
                                        items: List.generate(review.images!.length, (i) {
                                          final imageUrl = "$mainPoint${review.images![i]}";
                                          return Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              image: DecorationImage(
                                                image: NetworkImage(imageUrl),
                                                fit: BoxFit.cover,
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
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: AppText.title1("store_contacts".tr),
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
                          return ItemCardWidget(product: related, parentContext: context,
                           onUpdateWishlist: () {
                            productController.getProductById(context: context, id: widget.id, userId: UserStorage.currentUser?.id ?? '');
                           },
                            onUpdateCheckOut: () {
                              productController.getProductById(context: context, id: widget.id, userId: UserStorage.currentUser?.id ?? '');
                            }, onBackAction: () {
                            productController.getProductById(context: context, id: widget.id, userId: UserStorage.currentUser?.id ?? '');
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
                  onTap: () => {
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
          );
        },
      ),
    );
  }
}
