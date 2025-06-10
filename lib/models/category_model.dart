
import 'package:e_commerce_tech/helper/global.dart';

class CategoryResponse {
  final List<CategoryModel> categories;

  CategoryResponse({required this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      categories: List<CategoryModel>.from(
        json['categories'].map((x) => CategoryModel.fromJson(x)),
      ),
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });


  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      name: json['name'].toString(),
      description: json['description'].toString(),
      imageUrl: json['imageUrl'].toString(),
      createdAt: formatDateString(json['createdAt'].toString()),
      updatedAt: formatDateString(json['updatedAt'].toString())
    );
  }
}
