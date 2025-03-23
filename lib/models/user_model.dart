class User {
  final int id;
  final String name;
  final String email;
  final bool isVerify;
  final bool isMuted;
  final bool hasStory;
  final bool isFriend;
  final bool isFollowing;
  final bool isFollower;
  final bool isBlock;
  final String phone;
  final String role;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerify,
    required this.isMuted,
    required this.hasStory,
    required this.isFriend,
    required this.isFollowing,
    required this.isFollower,
    required this.isBlock,
    required this.phone,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert JSON to User model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isVerify: json['isVerify'],
      isMuted: json['isMuted'],
      hasStory: json['hasStory'],
      isFriend: json['isFriend'],
      isFollowing: json['isFollowing'],
      isFollower: json['isFollower'],
      isBlock: json['isBlock'],
      phone: json['phone'],
      role: json['role'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
