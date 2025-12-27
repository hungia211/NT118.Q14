import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../auth/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService authService = AuthService();
  final user = FirebaseAuth.instance.currentUser;

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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
                );
                return;
              }

              try {
                final credential = EmailAuthProvider.credential(
                  email: user?.email ?? '',
                  password: currentPasswordController.text,
                );
                await user?.reauthenticateWithCredential(credential);
                await user?.updatePassword(newPasswordController.text);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đổi mật khẩu thành công')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đổi mật khẩu thất bại')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Lưu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
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
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
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
                  child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(buttonText, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
