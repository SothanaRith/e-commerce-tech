
import 'package:e_commerce_tech/helper/global.dart';

class NotificationModel {
  String? id;
  String? userId;
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
    id = json['id'].toString();
    userId = json['userId'].toString();
    title = json['title'].toString();
    body = json['body'].toString();
    sentAt = formatDateString(json['sentAt'].toString());
    status = json['status'].toString();
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
