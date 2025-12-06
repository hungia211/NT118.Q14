import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/black_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),

                const Text(
                  "Khôi phục mật khẩu",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                const Text(
                  "Nhập email để nhận hướng dẫn đặt lại mật khẩu",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                CustomTextField(
                  label: "Email",
                  controller: emailController,
                ),

                const SizedBox(height: 20),

                BlackButton(
                  text: "Gửi yêu cầu",
                  onPressed: () {
                    // TODO: Gửi email reset mật khẩu
                  },
                ),

                const SizedBox(height: 12),

                TextButton(
                  child: const Text(
                    "Quay lại đăng nhập",
                    style: TextStyle(fontSize: 14),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
