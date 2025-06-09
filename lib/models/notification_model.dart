import 'package:e_commerce_tech/models/product_model.dart';  // Replace with any related model if necessary

class NotificationModel {
  int? id;
  int? userId;
  String? title;
  String? body;
  String? sentAt;
  String? status;

  // Constructor
  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.sentAt,
    this.status,
  });

  // From JSON Constructor
  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    body = json['body'];
    sentAt = json['sentAt'];
    status = json['status'];
  }

  // To JSON Method
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['title'] = title;
    data['body'] = body;
    data['sentAt'] = sentAt;
    data['status'] = status;
    return data;
  }
}
