
import 'package:e_commerce_tech/helper/global.dart';

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
  final String? id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String status;

  final String? isVerify;
  final String? isMuted;
  final String? hasStory;
  final String? isFriend;
  final String? isFollowing;
  final String? isFollower;
  final String? isBlock;

  final String? bio;
  final String? statusTitle;
  final String? coverImage;
  final String? thumbnailImage;
  final String? userQR;

  final String? latLongLat;
  final String? latLongLong;

  final String? friendSince;
  final String? lastActive;
  final String? createdAt;
  final String? updatedAt;

  // Constructor
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

  // From JSON Constructor
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'].toString(),
      email: json['email'].toString(),
      phone: json['phone']?.toString(),
      role: json['role'].toString(),
      status: json['status'].toString(),
      isVerify: json['isVerify']?.toString(),
      isMuted: json['isMuted']?.toString(),
      hasStory: json['hasStory']?.toString(),
      isFriend: json['isFriend']?.toString(),
      isFollowing: json['isFollowing']?.toString(),
      isFollower: json['isFollower']?.toString(),
      isBlock: json['isBlock']?.toString(),
      bio: json['bio']?.toString(),
      statusTitle: json['statusTitle']?.toString(),
      coverImage: json['coverImage']?.toString(),
      thumbnailImage: json['thumbnailImage']?.toString(),
      userQR: json['userQR'],
      latLongLat: json['LatLong_lat']?.toString(),
      latLongLong: json['LatLong_long']?.toString(),
      friendSince: json['friendSince']?.toString(),
      lastActive: json['lastActive']?.toString(),
      createdAt: formatDateString(json['createdAt'].toString()),
      updatedAt: formatDateString(json['updatedAt'].toString()),
    );
  }

  // To JSON Method
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
      'friendSince': friendSince,
      'lastActive': lastActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
