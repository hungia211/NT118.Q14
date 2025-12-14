import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/task.dart';

class TaskService {
  // Chuyển chế độ API ở đây: true = mock, false = API thật
  bool useMock = true;

  // URL API thật (trỏ vào Spring Boot)
  final String baseUrl = "http://10.0.2.2:8080/tasks";

  // ============================================
  // PUBLIC FUNCTION — dùng để gọi ở Controller/UI
  // ============================================
  Future<List<Task>> getTasks() async {
    return useMock ? _getTasksMock() : _getTasksReal();
  }

  // ============================================
  // 1) GIẢ API (MOCK from assets)
  // ============================================
  Future<List<Task>> _getTasksMock() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // fake network delay

      final jsonString = await rootBundle.loadString('assets/mock/tasks.json');
      final List data = jsonDecode(jsonString);

      return data.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error loading mock tasks: $e");
    }
  }

  // ============================================
  // 2) API THẬT (Spring Boot)
  // ============================================
  Future<List<Task>> _getTasksReal() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));

      if (res.statusCode != 200) {
        throw Exception("HTTP Error: ${res.statusCode}");
      }

      final List data = jsonDecode(res.body);
      return data.map((json) => Task.fromJson(json)).toList();

    } catch (e) {
      throw Exception("Error connecting to real API: $e");
    }
  }
}
