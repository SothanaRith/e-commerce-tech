import 'package:e_commerce_tech/models/product_model.dart';

import 'category_model.dart';

class HomeModel {
  final List<CategoryModel> categories;
  final List<ProductModel> products;

  HomeModel({
    required this.categories,
    required this.products,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    categories: (json['categories'] as List<dynamic>? ?? [])
        .map((item) => CategoryModel.fromJson(item))
        .toList(),
    products: (json['products'] as List<dynamic>? ?? [])
        .map((item) => ProductModel.fromJson(item))
        .toList(),
  );


}
