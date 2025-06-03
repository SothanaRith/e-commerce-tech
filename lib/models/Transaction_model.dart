import 'package:e_commerce_tech/models/product_model.dart';

class TransactionModel {
  String? id;
  String? orderId;
  String? paymentType;
  String? status;
  String? transactionId;
  String? amount;
  String? notes;
  String? createdAt;
  String? updatedAt;
  OrderModel? order;

  TransactionModel({
    this.id,
    this.orderId,
    this.paymentType,
    this.status,
    this.transactionId,
    this.amount,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.order,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    orderId = json['orderId'].toString();
    paymentType = json['paymentType'].toString();
    status = json['status'].toString();
    transactionId = json['transactionId'].toString();
    amount = json['amount'].toString();
    notes = json['notes'].toString();
    createdAt = json['createdAt'].toString();
    updatedAt = json['updatedAt'].toString();
    order = json['Order'] != null ? OrderModel.fromJson(json['Order']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['orderId'] = orderId;
    data['paymentType'] = paymentType;
    data['status'] = status;
    data['transactionId'] = transactionId;
    data['amount'] = amount;
    data['notes'] = notes;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (order != null) {
      data['Order'] = order!.toJson();
    }
    return data;
  }
}

class OrderModel {
  String? id;
  String? userId;
  String? totalAmount;
  String? paymentType;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<OrderItem>? orderItems;

  OrderModel({
    this.id,
    this.userId,
    this.totalAmount,
    this.paymentType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.orderItems,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['userId'].toString();
    totalAmount = json['totalAmount'].toString();
    paymentType = json['paymentType'].toString();
    status = json['status'].toString();
    createdAt = json['createdAt'].toString();
    updatedAt = json['updatedAt'].toString();
    if (json['orderItems'] != null) {
      orderItems = <OrderItem>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(OrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['totalAmount'] = totalAmount;
    data['paymentType'] = paymentType;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (orderItems != null) {
      data['orderItems'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItem {
  String? id;
  String? orderId;
  String? productId;
  String? variantId;
  String? quantity;
  String? price;
  ProductModel? product;

  OrderItem({
    this.id,
    this.orderId,
    this.productId,
    this.variantId,
    this.quantity,
    this.price,
    this.product,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    orderId = json['orderId'].toString();
    productId = json['productId'].toString();
    variantId = json['variantId'].toString();
    quantity = json['quantity'].toString();
    price = json['price'].toString();
    product = json['Product'] != null ? ProductModel.fromJson(json['Product']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['orderId'] = orderId;
    data['productId'] = productId;
    data['variantId'] = variantId;
    data['quantity'] = quantity;
    data['price'] = price;
    if (product != null) {
      data['Product'] = product!.toJson();
    }
    return data;
  }
}
