import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String provider;
  final String? avatarUrl;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.provider,
    required this.createdAt,
    this.avatarUrl,
  });

  /// Firestore -> AppUser
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      provider: map['provider'] as String,
      avatarUrl: map['avatar_url'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  /// AppUser -> Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'provider': provider,
      'avatar_url': avatarUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
