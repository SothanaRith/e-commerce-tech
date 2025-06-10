
import 'package:e_commerce_tech/helper/global.dart';
import 'package:intl/intl.dart';

class SliderModel {
  String? id;
  String? title;
  String? description;
  String? imageUrl;
  String? isActive;
  String? order;
  String? createdAt;
  String? updatedAt;

  SliderModel({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.isActive,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  // From JSON Constructor
  SliderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'].toString();
    description = json['description'].toString();
    imageUrl = json['imageUrl'].toString();
    isActive = json['isActive'].toString();
    order = json['order'].toString();
    createdAt = formatDateString(json['createdAt'].toString());
    updatedAt = formatDateString(json['updatedAt'].toString());
  }

  // To JSON Method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['isActive'] = this.isActive;
    data['order'] = this.order;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
