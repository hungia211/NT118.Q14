import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  final String baseUrl = "https://www.googleapis.com/books/v1/volumes";

  Future<List> fetchBooks(String keyword) async {
    final url = Uri.parse(
        "$baseUrl?q=$keyword&langRestrict=vi&maxResults=20"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["items"] ?? [];
    } else {
      throw Exception("Load danh sách không thành công");
    }
  }
}
