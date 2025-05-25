import 'package:e_commerce_tech/models/product_model.dart';

class CartModel {
  String? id;
  String? userId;
  String? productId;
  String? variantId;
  String? priceAtPurchase;
  String? quantity;
  String? createdAt;
  String? updatedAt;
  ProductModel? product;

  CartModel(
      {this.id,
        this.userId,
        this.productId,
        this.variantId,
        this.priceAtPurchase,
        this.quantity,
        this.createdAt,
        this.updatedAt,
        this.product});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['userId'].toString();
    productId = json['productId'].toString();
    variantId = json['variantId'].toString();
    priceAtPurchase = json['priceAtPurchase'].toString();
    quantity = json['quantity'].toString();
    createdAt = json['createdAt'].toString();
    updatedAt = json['updatedAt'].toString();
    product =
    json['Product'] != null ? ProductModel.fromJson(json['Product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['productId'] = productId;
    data['variantId'] = variantId;
    data['priceAtPurchase'] = priceAtPurchase;
    data['quantity'] = quantity;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (product != null) {
      data['Product'] = product!.toJson();
    }
    return data;
  }
}
