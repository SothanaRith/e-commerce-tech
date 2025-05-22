import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_commerce_tech/controllers/product_controller.dart';
import 'package:e_commerce_tech/controllers/wishlist_contoller.dart';
import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/models/product_model.dart';
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
  const ProductDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductController productController = Get.put(ProductController());
  final WishlistController wishlistController = Get.put(WishlistController());
  ProductModel? productItem;

  String? selectedImageUrl; // Track current main image

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      ProductModel product = await productController.getProductById(
        context: context,
        id: widget.id, userId: '1',
      );
      setState(() {
        productItem = product;
        if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
          selectedImageUrl = product.imageUrl!.first;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProductController>(
        builder: (controller) {
          if (controller.isLoading || productItem == null) {
            return const Center(child: CircularProgressIndicator());
          }

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
                                  productItem!.imageUrl?.length ?? 0,
                                      (index) {
                                    final url = productItem!.imageUrl![index];
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
                                  "Are you sure you want to ${productItem?.isInWishlist == 'true' ? "remove" : "add"} ${productItem?.name} to wishlist ?",
                                  okOnPress: () {
                                    if (productItem?.isInWishlist == 'true') {
                                      wishlistController.deleteWishlist(
                                          context: context,
                                          userId: "1",
                                          productId: productItem?.id ?? '');
                                    } else {
                                      wishlistController.createWishlist(
                                          context: context,
                                          userId: "1",
                                          productId: productItem?.id ?? '');
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
                                      color: productItem?.isInWishlist == 'true'
                                          ? theme.primaryColor
                                          : Colors.white.withAlpha(150),
                                    ),
                                    child: productItem?.isInWishlist == 'true'
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
                                      productItem?.name ?? "",
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    AppText.caption(
                                      productItem?.description ?? "",
                                      maxLines: 4,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              AppText.h3(
                                productItem?.price ?? "",
                                customStyle: TextStyle(color: theme.primaryColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(thickness: 0.1, color: theme.highlightColor),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    if (productItem!.reviews != null &&
                        productItem!.reviews!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: AppText.title("Reviews"),
                      ),
                      const SizedBox(height: 12),
                      ListViewHorizontalWidget(
                        height: 160,
                        items: List.generate(productItem!.reviews?.length ?? 0,
                                (index) {
                              final review = productItem!.reviews![index];
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

                    if (productItem!.variants != null &&
                        productItem!.variants!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: AppText.title1("Store Contacts"),
                      ),
                      const SizedBox(height: 24),
                    ],

                    if (productItem!.relatedProducts != null &&
                        productItem!.relatedProducts!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: AppText.title1("Related Products"),
                      ),
                      GridCustomWidget(
                        items: List.generate(
                            productItem!.relatedProducts?.length ?? 0, (index) {
                          final related = productItem!.relatedProducts![index];
                          return ItemCardWidget(product: productItem!);
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
                  onTap: () => popBack(this),
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
