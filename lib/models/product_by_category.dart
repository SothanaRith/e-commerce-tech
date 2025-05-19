// import '../../models/product_model.dart';
//
// class ProductByCategoryModel{
//   final List<ProductModel> products;
//
//   ProductByCategoryModel({
//     required this.products
// });
//   factory ProductByCategoryModel.fromJson(Map<String, dynamic> json) => ProductByCategoryModel(
//     products: (json['products'] as List<dynamic>? ?? [])
//         .map((item) => ProductModel.fromJson(item))
//         .toList(),
//   );
// }

// lib/models/products_response.dart
import 'package:e_commerce_tech/models/product_model.dart';

class ProductsResponse {
  final int statusCode;
  final String status;
  final String message;
  final List<ProductModel> data;

  ProductsResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) => ProductsResponse(
    statusCode: json['statusCode'] as int,
    status: json['status'] as String,
    message: json['message'] as String,
    data: (json['data'] as List<dynamic>)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'status': status,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

// lib/models/variant.dart
class Variant {
  final int id;
  final int productId;
  final String sku;
  final String price;
  final int stock;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<VariantAttribute> variantAttributes;

  Variant({
    required this.id,
    required this.productId,
    required this.sku,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
    required this.variantAttributes,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json['id'] as int,
    productId: json['productId'] as int,
    sku: json['sku'] as String,
    price: json['price'] as String,
    stock: json['stock'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    variantAttributes: (json['VariantAttributes'] as List<dynamic>)
        .map((e) => VariantAttribute.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'sku': sku,
    'price': price,
    'stock': stock,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'VariantAttributes': variantAttributes.map((a) => a.toJson()).toList(),
  };
}

// lib/models/variant_attribute.dart
class VariantAttribute {
  final String name;
  final String value;

  VariantAttribute({
    required this.name,
    required this.value,
  });

  factory VariantAttribute.fromJson(Map<String, dynamic> json) => VariantAttribute(
    name: json['name'] as String,
    value: json['value'] as String,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'value': value,
  };
}

// lib/models/review.dart
class Review {
  final int id;
  final int rating;
  final String comment;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'] as int,
    rating: json['rating'] as int,
    comment: json['comment'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'rating': rating,
    'comment': comment,
  };
}

// lib/models/related_product.dart
class RelatedProduct {
  final int id;
  final String name;

  RelatedProduct({
    required this.id,
    required this.name,
  });

  factory RelatedProduct.fromJson(Map<String, dynamic> json) => RelatedProduct(
    id: json['id'] as int,
    name: json['name'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
