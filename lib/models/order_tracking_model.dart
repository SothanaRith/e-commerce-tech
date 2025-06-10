import 'package:e_commerce_tech/helper/global.dart';

class OrderTrackingModel {
  String? status;
  String? timestamp;

  OrderTrackingModel({
    this.status,
    this.timestamp,
  });

  OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    timestamp = formatDateString(json['timestamp']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp,
    };
  }
}
