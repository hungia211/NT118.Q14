import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/user_service.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();

  final isUploadingAvatar = false.obs;
  final avatarUrl = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> changeAvatar(String uid) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (picked == null) return;

      isUploadingAvatar.value = true;

      final file = File(picked.path);

      // 1. Upload Cloudinary
      final url = await _userService.uploadAvatarToCloudinary(file);

      // 2. Save Firestore
      await _userService.updateAvatar(uid, url);

      // 3. Update state
      avatarUrl.value = url;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  Future<void> loadUser(String uid) async {
    try {
      final data = await _userService.getUser(uid);
      if (data == null) return;
      print(data['avatar_url']);
      avatarUrl.value = data['avatar_url'] ?? '';
    } catch (e) {
      print('Load user error: $e');
    }
  }

  Future<void> changeAvatarWithFile(String uid, File file) async {
    try {
      isUploadingAvatar.value = true;

      final url = await _userService.uploadAvatarToCloudinary(file);
      await _userService.updateAvatar(uid, url);

      avatarUrl.value = url;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isUploadingAvatar.value = false;
    }
  }
}
