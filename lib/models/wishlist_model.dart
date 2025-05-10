class WishlistModel {
  int? id;
  int? userId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  Product? product;

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
    product = json['Product'] != null ? Product.fromJson(json['Product']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['productId'] = productId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (product != null) {
      data['Product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? price;
  List<String>? imageUrl;

  Product({
    this.id,
    this.name,
    this.price,
    this.imageUrl,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    imageUrl = json['imageUrl'] != null ? List<String>.from(json['imageUrl']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    if (imageUrl != null) {
      data['imageUrl'] = imageUrl;
    }
    return data;
  }
}
