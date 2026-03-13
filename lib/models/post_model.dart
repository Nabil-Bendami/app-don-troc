import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String title;
  final String description;
  final String? image;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.createdAt,
  });

  /// Convert PostModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'createdAt': createdAt,
    };
  }

  /// Create PostModel from Firestore document
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String?,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Create a copy with modified fields
  PostModel copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
