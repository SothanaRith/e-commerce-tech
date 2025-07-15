import 'package:e_commerce_tech/models/product_model.dart';
import 'package:e_commerce_tech/models/slide_model.dart';

import 'category_model.dart';

class HomeModel {
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final List<ProductModel> latestProducts;
  final List<SliderModel> slides;

  HomeModel({
    required this.categories,
    required this.products,
    required this.latestProducts,
    required this.slides,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    categories: (json['categories'] as List<dynamic>? ?? [])
        .map((item) => CategoryModel.fromJson(item))
        .toList(),
    products: (json['products'] as List<dynamic>? ?? [])
        .map((item) => ProductModel.fromJson(item))
        .toList(),
    latestProducts: (json['latestProducts'] as List<dynamic>? ?? [])
        .map((item) => ProductModel.fromJson(item))
        .toList(),
    slides: (json['slides'] as List<dynamic>? ?? [])
        .map((item) => SliderModel.fromJson(item))
        .toList(),
  );


}
