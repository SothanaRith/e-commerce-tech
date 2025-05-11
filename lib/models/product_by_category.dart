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
class ProductsResponse {
  final int statusCode;
  final String status;
  final String message;
  final List<Product> data;

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
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'status': status,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

// lib/models/product.dart
class Product {
  final int id;
  final int categoryId;
  final String? reviewId;
  final String name;
  final String description;
  final String price;
  final int? totalStock;
  final List<String>? imageUrl;
  final int? storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Variant> variants;
  final List<Review> reviews;
  final List<RelatedProduct> relatedProducts;

  Product({
    required this.id,
    required this.categoryId,
    this.reviewId,
    required this.name,
    required this.description,
    required this.price,
    this.totalStock,
    this.imageUrl,
    this.storeId,
    required this.createdAt,
    required this.updatedAt,
    required this.variants,
    required this.reviews,
    required this.relatedProducts,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    categoryId: json['categoryId'] as int,
    reviewId: json['reviewId']?.toString(),
    name: json['name'] as String,
    description: json['description'] as String,
    price: json['price'] as String,
    totalStock: json['totalStock'] as int?,
    imageUrl: (json['imageUrl'] as String?)
        ?.replaceAll(RegExp(r'^\[|\]$'), '') // strip [ ]
        .split(',')
        .map((s) => s.trim().replaceAll('"', ''))
        .where((s) => s.isNotEmpty)
        .toList(),
    storeId: json['storeId'] as int?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    variants: (json['Variants'] as List<dynamic>)
        .map((e) => Variant.fromJson(e as Map<String, dynamic>))
        .toList(),
    reviews: (json['Reviews'] as List<dynamic>)
        .map((e) => Review.fromJson(e as Map<String, dynamic>))
        .toList(),
    relatedProducts: (json['RelatedProducts'] as List<dynamic>)
        .map((e) => RelatedProduct.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'reviewId': reviewId,
    'name': name,
    'description': description,
    'price': price,
    'totalStock': totalStock,
    'imageUrl': imageUrl,
    'storeId': storeId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'Variants': variants.map((v) => v.toJson()).toList(),
    'Reviews': reviews.map((r) => r.toJson()).toList(),
    'RelatedProducts': relatedProducts.map((p) => p.toJson()).toList(),
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
