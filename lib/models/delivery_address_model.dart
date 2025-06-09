class DeliveryAddress {
  final String? id;
  final String? userId;
  final String? fullName;
  final String? phoneNumber;
  final String? street;
  final String? isDefault;

  DeliveryAddress({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.street,
    required this.isDefault,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      fullName: json['fullName'].toString(),
      phoneNumber: json['phoneNumber'].toString(),
      street: json['street'] ?? '',
      isDefault: json['isDefault'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['street'] = street;
    data['isDefault'] = isDefault;
    return data;
  }
}