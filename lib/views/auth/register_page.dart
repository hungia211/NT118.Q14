import 'package:flutter/material.dart';
import 'package:todo_app/views/auth/login_page.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_password_field.dart';
import '../../widgets/black_button.dart';
import '../../widgets/white_button.dart';
import '../../widgets/social_login_button.dart';


class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(height: 30),


                Text(
                  "Tạo tài khoản",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                const Text(
                  "Vui lòng nhập đầy đủ thông tin để đăng ký",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 30),

                CustomTextField(
                  label: "Họ và tên",
                  controller: nameController,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  label: "Email",
                  controller: emailController,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  label: "Tài khoản",
                  controller: emailController,
                ),

                const SizedBox(height: 16),

                CustomPasswordField(
                  label: "Mật khẩu",
                  controller: passwordController,
                ),

                const SizedBox(height: 16),

                CustomPasswordField(
                  label: "Xác nhận mật khẩu",
                  controller: confirmPasswordController,
                ),

                const SizedBox(height: 20),

                BlackButton(
                  text: "Đăng ký",
                  onPressed: () {
                    // TODO: Xử lý đăng ký
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("HOẶC", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),

                const SizedBox(height: 20),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Nút Facebook
                    Expanded(
                      child: SocialLoginButton(
                        text: "Facebook",
                        asset: "assets/images/facebook.png",
                        color: Colors.white,
                        borderColor: Colors.grey.shade300,
                        textColor: Colors.black,
                        onTap: () {
                          // TODO: Login Facebook
                        },
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Nút Google
                    Expanded(
                      child: SocialLoginButton(
                        text: "Google",
                        asset: "assets/images/google.png",
                        color: Colors.white,
                        borderColor: Colors.grey.shade300,
                        textColor: Colors.black,
                        onTap: () {
                          // TODO: Login Google
                        },
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Bạn đã có tài khoản! ",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
