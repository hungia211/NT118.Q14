import 'package:flutter/material.dart';
import '../../widgets/black_button.dart';
import '../../widgets/white_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_password_field.dart';
import '../../widgets/social_login_button.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';




class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Tiêu đề
                  SizedBox(
                    height: 80,
                    child: Image.asset(
                      "assets/images/Title.png",
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Ảnh nền trước khi vào app
                  // SizedBox(
                  //   height: 180,
                  //   child: Image.asset(
                  //     "assets/images/logo.png",
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),

                  const SizedBox(height: 20),

                  // SLOGAN
                  const Text(
                    "Không có việc gì khó",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Text(
                    "Chỉ sợ mình không làm",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Vui lòng đăng nhập để tiếp tục sử dụng",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tài khoản (Email hoặc số điện thoại)
                  CustomTextField(
                    label: "Tài khoản",
                    controller: emailController,
                  ),

                  const SizedBox(height: 16),

                  // Mật khẩu Field
                  CustomPasswordField(
                    label: "Mật khẩu",
                    controller: passwordController,
                  ),


                  const SizedBox(height: 16),


                  // LOGIN BUTTON
                  BlackButton(
                    text: "Đăng nhập",
                    onPressed: () {},
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
                        );
                      },
                      child: const Text("Quên mật khẩu?"),
                    ),
                  ),

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

                  const SizedBox(height: 12),


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
                        "Bạn mới sử dụng ứng dụng? ",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterPage()),
                          );
                        },
                        child: const Text(
                          "Đăng ký",
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
      ),
    );
  }
}
