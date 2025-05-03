class ProductModel {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final String price;
  final int totalStock;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.totalStock,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    categoryId: json['categoryId'],
    name: json['name'],
    description: json['description'],
    price: json['price'],
    totalStock: json['totalStock'] ?? 0,
    imageUrl: json['imageUrl'].toString(),
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}
