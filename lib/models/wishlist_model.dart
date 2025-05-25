import 'package:e_commerce_tech/models/product_model.dart';

class WishlistModel {
  int? id;
  int? userId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  ProductModel? product;

  WishlistModel({
    this.id,
    this.userId,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  WishlistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    productId = json['productId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    product = json['product'] != null ? ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['productId'] = productId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}
