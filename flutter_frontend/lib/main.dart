import 'package:flutter/material.dart';
import 'views/auth/login_page.dart'; // IMPORT LOGIN PAGE

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //  GLOBAL THEME APP
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Inter",   // DÙNG FONT INTER TOÀN APP

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),  // MÀU XANH LÁ NHẸ
        ),

        scaffoldBackgroundColor: const Color(0xFFF9FEFB), // NỀN MẶC ĐỊNH
      ),

      // ✨ TRANG ĐẦU TIÊN KHI APP CHẠY
      home: LoginPage(),
    );
  }
}
