import 'package:e_commerce_tech/helper/global.dart';
import 'package:e_commerce_tech/models/category_model.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:e_commerce_tech/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../category/product_by_category.dart';

class CategoryHomeScreenWidget extends StatelessWidget {
  const CategoryHomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        _buildHeader(context),
        const SizedBox(height: 4),
        GetBuilder<HomeController>(
          builder: (controller) => SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return _categoryItem(category);
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.title2(
            "category".tr,
            customStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _categoryItem(CategoryModel category) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          goTo(this, ProductByCategoryScreen(categoryId: category.id, categoryName: category.name));
        },
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.blue.withAlpha(20),
              ),
              child: ClipOval(
                child: Image.network(
                  "${category.imageUrl}",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 10),
            AppText.body2(
              category.name,
              customStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
