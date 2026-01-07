import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_app/services/notification_service.dart';

import 'controllers/notification_controller.dart';
import 'controllers/task_controller.dart';
import 'views/auth/login_page.dart';
import 'firebase_options.dart';

import 'package:get/get.dart';
import '../../services/auth_service.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('vi_VN', null);
  await NotificationService.init();


  // đăng ký AuthService với GetX
  Get.put(AuthService());
  Get.put(NotificationController());
  Get.put(TaskController());

  // Chạy .env khi app start
  await dotenv.load(fileName: ".env");


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // THÊM LOCALIZATION DELEGATES
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
      locale: const Locale('vi', 'VN'),

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Inter",
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        scaffoldBackgroundColor: const Color(0xFFF9FEFB),
      ),

      home: LoginPage(),
    );
  }
}
