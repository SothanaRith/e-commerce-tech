class UserModel {
  bool? success;
  String? message;
  User? user;

  UserModel({this.success, this.message, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (user != null) {
      data['user'] = user;
    }
    return data;
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String status;

  final bool isVerify;
  final bool isMuted;
  final bool hasStory;
  final bool isFriend;
  final bool isFollowing;
  final bool isFollower;
  final bool isBlock;

  final String? bio;
  final String? statusTitle;
  final String? coverImage;
  final String? thumbnailImage;
  final String? userQR;

  final double? latLongLat;
  final double? latLongLong;

  final DateTime? friendSince;
  final DateTime? lastActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.isVerify,
    required this.isMuted,
    required this.hasStory,
    required this.isFriend,
    required this.isFollowing,
    required this.isFollower,
    required this.isBlock,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.bio,
    this.statusTitle,
    this.coverImage,
    this.thumbnailImage,
    this.userQR,
    this.latLongLat,
    this.latLongLong,
    this.friendSince,
    this.lastActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      status: json['status'],

      isVerify: json['isVerify'] ?? false,
      isMuted: json['isMuted'] ?? false,
      hasStory: json['hasStory'] ?? false,
      isFriend: json['isFriend'] ?? false,
      isFollowing: json['isFollowing'] ?? false,
      isFollower: json['isFollower'] ?? false,
      isBlock: json['isBlock'] ?? false,

      bio: json['bio'],
      statusTitle: json['statusTitle'],
      coverImage: json['coverImage'],
      thumbnailImage: json['thumbnailImage'],
      userQR: json['userQR'],

      latLongLat: json['LatLong_lat'] != null ? double.tryParse(json['LatLong_lat'].toString()) : null,
      latLongLong: json['LatLong_long'] != null ? double.tryParse(json['LatLong_long'].toString()) : null,

      friendSince: json['friendSince'] != null ? DateTime.tryParse(json['friendSince']) : null,
      lastActive: json['lastActive'] != null ? DateTime.tryParse(json['lastActive']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'status': status,

      'isVerify': isVerify,
      'isMuted': isMuted,
      'hasStory': hasStory,
      'isFriend': isFriend,
      'isFollowing': isFollowing,
      'isFollower': isFollower,
      'isBlock': isBlock,

      'bio': bio,
      'statusTitle': statusTitle,
      'coverImage': coverImage,
      'thumbnailImage': thumbnailImage,
      'userQR': userQR,

      'LatLong_lat': latLongLat,
      'LatLong_long': latLongLong,

      'friendSince': friendSince?.toIso8601String(),
      'lastActive': lastActive?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
