import 'package:e_commerce_tech/controllers/category_controller.dart';
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
  State<ProductByCategoryScreen> createState() => _ProductByCategoryScreenState();
}

class _ProductByCategoryScreenState extends State<ProductByCategoryScreen> {
  // final CategoryController controller = Get.put(CategoryController(categoryId: widget.categoryId, context: context));


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController(
      categoryId: widget.categoryId.toString(),
      context: context,
    ));
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Obx(() {
        if (controller.isLoadingProducts.value) {
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
          itemBuilder: (context, index) {
            final product = controller.productByCategories[index];
            return ItemCardWidget(
              imageUrl: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? product.imageUrl!.first
                  : "",
              title: product.name ?? '',
              price: '\$${product.price ?? ''}',
            );
          },
        );
      }),
    );
  }
}
