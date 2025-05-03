import 'package:e_commerce_tech/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';

class CategoryHomeScreenWidget extends StatelessWidget {
  const CategoryHomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>(); // Get the controller

    return Column(
      children: [
        _buildHeader(context),
        SizedBox(height: 4),
        Obx(() {
          return SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return _categoryItem(category);
              },
            ),
          );
        }),
        SizedBox(height: 6),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Category",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to the category screen (you can update this based on your needs)
            },
            child: Text(
              "See All",
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryItem(CategoryModel category) {
    return Padding(
      padding: const EdgeInsets.only(right: 10), // Padding for spacing between items
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
                "http://192.168.1.2:6000/uploads/${category.imageUrl}",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.image, size: 40, color: Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            category.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
