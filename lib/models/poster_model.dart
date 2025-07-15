class PosterModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final bool isActive;
  final int order;

  PosterModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.isActive,
    required this.order,
  });

  factory PosterModel.fromJson(Map<String, dynamic> json) {
    return PosterModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'],
      order: json['order'],
    );
  }
}
