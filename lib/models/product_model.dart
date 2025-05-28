import 'package:e_commerce_tech/models/user_model.dart';

class ProductModel {
  String? id;
  String? categoryId;
  String? reviewId;
  String? name;
  String? description;
  String? price;
  String? totalStock;
  List<String>? imageUrl;
  String? storeId;
  String? createdAt;
  String? updatedAt;
  String? isInWishlist;
  Category? category;
  List<Variants>? variants;
  List<Reviews>? reviews;
  List<ProductModel>? relatedProducts;

  // NEW fields
  int? cartQuantity; // default 0 if not present
  bool? isInCart;    // default false if not present

  ProductModel(
      {this.id,
        this.categoryId,
        this.reviewId,
        this.name,
        this.description,
        this.price,
        this.totalStock,
        this.imageUrl,
        this.storeId,
        this.createdAt,
        this.updatedAt,
        this.isInWishlist,
        this.category,
        this.variants,
        this.reviews,
        this.relatedProducts,
        this.cartQuantity = 0,  // default
        this.isInCart = false   // default
      });

  ProductModel.fromJson(Map<String, dynamic> json)
      : cartQuantity = json['cartQuantity'] != null
      ? int.tryParse(json['cartQuantity'].toString()) ?? 0
      : 0,
        isInCart = json['isInCart'] != null
            ? (json['isInCart'] == true || json['isInCart'].toString() == '1')
            : false {
    id = json['id'].toString();
    categoryId = json['categoryId'].toString();
    reviewId = json['reviewId'].toString();
    name = json['name'].toString();
    description = json['description'].toString();
    price = json['price'].toString();
    totalStock = json['totalStock'].toString();
    imageUrl = json['imageUrl'] != null && json['imageUrl'] is List
        ? List<String>.from(json['imageUrl'])
        : [];
    storeId = json['storeId'].toString();
    createdAt = json['createdAt'].toString();
    updatedAt = json['updatedAt'].toString();
    isInWishlist = json['isInWishlist'].toString();
    category =
    json['Category'] != null ? Category.fromJson(json['Category']) : null;
    if (json['Variants'] != null) {
      variants = <Variants>[];
      json['Variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
    if (json['Reviews'] != null) {
      reviews = <Reviews>[];
      json['Reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    if (json['RelatedProducts'] != null) {
      relatedProducts = [];
      json['RelatedProducts'].forEach((v) {
        relatedProducts!.add(ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['categoryId'] = categoryId;
    data['reviewId'] = reviewId;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['totalStock'] = totalStock;
    data['imageUrl'] = imageUrl;
    data['storeId'] = storeId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isInWishlist'] = isInWishlist;

    // New fields added to JSON output
    data['cartQuantity'] = cartQuantity;
    data['isInCart'] = isInCart;

    if (category != null) {
      data['Category'] = category!.toJson();
    }
    if (variants != null) {
      data['Variants'] = variants!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['Reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    if (relatedProducts != null) {
      data['RelatedProducts'] = relatedProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? id;

  Category({this.id});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class Variants {
  String? id;
  String? productId;
  String? sku;
  String? price;
  String? stock;
  List<VariantAttributes>? variantAttributes;

  Variants(
      {this.id,
        this.productId,
        this.sku,
        this.price,
        this.stock,
        this.variantAttributes});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productId = json['productId'].toString();
    sku = json['sku'].toString();
    price = json['price'].toString();
    stock = json['stock'].toString();
    if (json['VariantAttributes'] != null) {
      variantAttributes = <VariantAttributes>[];
      json['VariantAttributes'].forEach((v) {
        variantAttributes!.add(VariantAttributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productId'] = productId;
    data['sku'] = sku;
    data['price'] = price;
    data['stock'] = stock;
    if (variantAttributes != null) {
      data['VariantAttributes'] =
          variantAttributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariantAttributes {
  String? name;
  String? value;

  VariantAttributes({this.name, this.value});

  VariantAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    value = json['value'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}

class Reviews {
  String? id;
  String? rating;
  String? comment;
  UserReView? user;
  List<String>? images;

  Reviews({this.id, this.rating, this.comment, this.user, this.images});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    rating = json['rating'].toString();
    comment = json['comment'].toString();
    if (json['user'] != null) {
      user = UserReView.fromJson(json['user']); // ✅ Parse properly
    }
    images = json['imageUrl'] != null ? List<String>.from(json['imageUrl']) : [];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['comment'] = comment;
    data['imageUrl'] = images;
    return data;
  }
}

class UserReView {
  final int id;
  final String name;
  final String email;

  UserReView({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserReView.fromJson(Map<String, dynamic> json) {
    return UserReView(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

class RelatedProduct {
  final String id;
  final String name;
  final String price;

  RelatedProduct({required this.id, required this.name, required this.price,});

  factory RelatedProduct.fromJson(Map<String, dynamic> json) {
    return RelatedProduct(
      id: json['id'].toString(),
      name: json['name'].toString(),
      price: json['price'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
  };
}
