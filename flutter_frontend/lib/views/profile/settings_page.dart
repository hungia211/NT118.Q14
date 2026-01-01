import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../auth/login_page.dart';
import '../../controllers/user_controller.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService authService = AuthService();
  final user = FirebaseAuth.instance.currentUser;

  final userController = Get.find<UserController>();

  bool _showEmail = false;

  String _maskEmail(String? email) {
    if (email == null || email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final masked = name.length > 3
        ? '${name.substring(0, 3)}${'*' * (name.length - 3)}'
        : name;
    return '$masked@${parts[1]}';
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool isLoading = false;

    void showError(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }

    showDialog(
      context: context,
      barrierDismissible: isLoading,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const Text('Đổi mật khẩu'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu hiện tại',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu mới',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Xác nhận mật khẩu mới',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final current = currentPasswordController.text.trim();
                          final newPass = newPasswordController.text.trim();
                          final confirm = confirmPasswordController.text.trim();

                          // ===== VALIDATE =====
                          if (current.isEmpty ||
                              newPass.isEmpty ||
                              confirm.isEmpty) {
                            showError('Vui lòng nhập đầy đủ thông tin');
                            return;
                          }

                          if (newPass.length < 6) {
                            showError('Mật khẩu mới phải ≥ 6 ký tự');
                            return;
                          }

                          if (current == newPass) {
                            showError(
                              'Mật khẩu mới không được trùng mật khẩu cũ',
                            );
                            return;
                          }

                          if (newPass != confirm) {
                            showError('Mật khẩu xác nhận không khớp');
                            return;
                          }

                          // ===== FIREBASE =====
                          setLocalState(() => isLoading = true);
                          try {
                            final credential = EmailAuthProvider.credential(
                              email: user!.email!,
                              password: current,
                            );

                            await user!.reauthenticateWithCredential(
                              credential,
                            );
                            await user!.updatePassword(newPass);

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đổi mật khẩu thành công'),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            switch (e.code) {
                              case 'wrong-password':
                                showError('Mật khẩu hiện tại không đúng');
                                break;
                              case 'weak-password':
                                showError('Mật khẩu mới quá yếu');
                                break;
                              case 'requires-recent-login':
                                showError(
                                  'Vui lòng đăng nhập lại để đổi mật khẩu',
                                );
                                break;
                              default:
                                showError('Đổi mật khẩu thất bại');
                            }
                          } finally {
                            setLocalState(() => isLoading = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Lưu',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FEFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // EMAIL
            _buildInfoRow(
              label: 'EMAIL',
              value: _showEmail ? (user?.email ?? '') : _maskEmail(user?.email),
              onReveal: () => setState(() => _showEmail = !_showEmail),
              revealText: _showEmail ? 'Ẩn' : 'Hiện',
            ),

            const SizedBox(height: 20),

            // AVATAR
            _buildActionRow(
              label: 'ẢNH ĐẠI DIỆN',
              value: 'Thay đổi ảnh đại diện',
              buttonText: 'ĐỔI',
              onPressed: () {
                if (user == null) return;
                userController.changeAvatar(user!.uid);
              },
            ),

            const SizedBox(height: 20),

            // ĐỔI MẬT KHẨU
            _buildActionRow(
              label: 'MẬT KHẨU',
              value: '••••••••',
              buttonText: 'ĐỔI',
              onPressed: _showChangePasswordDialog,
            ),

            const SizedBox(height: 40),

            // ĐĂNG XUẤT
            const Text(
              'Tài khoản',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Đăng xuất khỏi tài khoản của bạn.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                OutlinedButton(
                  onPressed: _showLogoutConfirmation,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required VoidCallback onReveal,
    required String revealText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
            TextButton(onPressed: onReveal, child: Text(revealText)),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildActionRow({
    required String label,
    required String value,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
