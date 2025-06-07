import 'package:e_commerce_tech/controllers/category_controller.dart';
import 'package:e_commerce_tech/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/item_card_widget.dart';

class ProductByCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductByCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductByCategoryScreen> createState() =>
      _ProductByCategoryScreenState();
}

class _ProductByCategoryScreenState extends State<ProductByCategoryScreen> {
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      categoryController.listProByCategory(
          categoryId: widget.categoryId, context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          type: this, title: widget.categoryName, context: context),
      body: GetBuilder<CategoryController>(builder: (controller) {
        if (controller.isLoadingProducts) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.productByCategories.isEmpty) {
          return const Center(child: Text("No products found."));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.productByCategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (contextList, index) {
            final product = controller.productByCategories[index];
            return ItemCardWidget(
              product: product, parentContext: context,
              onUpdateCheckOut: () {
                Future.delayed(Duration.zero, () {
                  controller.listProByCategory(
                      categoryId: widget.categoryId, context: context);
                });
              },
              onUpdateWishlist: () {
                Future.delayed(Duration.zero, () {
                  controller.listProByCategory(
                      categoryId: widget.categoryId, context: context);
                });
              },
            );
          },
        );
      }),
    );
  }
}
