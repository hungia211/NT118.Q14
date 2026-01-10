import 'dart:convert';
import 'dart:developer' as console;
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/task_draft.dart';

class AiSuggestionService {
  static const _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent';

  Future<List<TaskDraft>> suggestTasks(String prompt) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Missing GEMINI_API_KEY');
    }

    final response = await http.post(
      Uri.parse('$_endpoint?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      debugPrint(response.body);
      throw Exception('AI request failed (${response.statusCode})');
    }

    final rawText = jsonDecode(response.body)
    ['candidates'][0]['content']['parts'][0]['text'];

    console.log('AI Raw Response: $rawText');

    final cleaned = _extractJson(rawText);
    final decoded = jsonDecode(cleaned) as List;

    return decoded.map((e) => TaskDraft.fromJson(e)).toList();
  }

  String _extractJson(String text) {
    final start = text.indexOf('[');
    final end = text.lastIndexOf(']');
    if (start == -1 || end == -1) {
      throw Exception('Invalid AI JSON response');
    }
    return text.substring(start, end + 1);
  }
}
