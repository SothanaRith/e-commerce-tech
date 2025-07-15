class PosterModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String isActive;
  final String order;

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
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'].toString(),
      order: json['order'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['isActive'] = this.isActive;
    data['order'] = this.order;
    return data;
  }
}
