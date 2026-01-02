import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<void> createUserIfNotExists({
    required String uid,
    required String email,
    required String name,
    required String provider,
  }) async {
    final docRef = _db.collection('users').doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': uid,
        'email': email,
        'name': name,
        'provider': provider,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data();
  }

  // Cloudinary config
  final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET']!;

  /// Upload avatar lên Cloudinary → trả về image URL
  Future<String> uploadAvatarToCloudinary(File imageFile) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Upload avatar failed');
    }

    final resStr = await response.stream.bytesToString();
    final data = jsonDecode(resStr);

    return data['secure_url'];
  }

  /// Lưu avatarUrl vào Firestore
  Future<void> updateAvatar(String uid, String avatarUrl) async {
    await _db.collection('users').doc(uid).update({'avatar_url': avatarUrl});
  }

  // Update username
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }
}
