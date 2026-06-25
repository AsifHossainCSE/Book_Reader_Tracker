import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:book_reader_tracker/models/book.dart';

class Network {
  static const String _baseUrl =
      'https://www.googleapis.com/books/v1/volumes';

  Future<List<Book>> searchBooks(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      '$_baseUrl?q=${Uri.encodeComponent(query)}&maxResults=20',
    );

    print("Searching: $query");
    print("URL: $url");

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      print("Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List items = data['items'] ?? [];

        return items
            .map((e) => Book.fromJson(e))
            .toList();
      }

      if (response.statusCode == 429) {
        throw Exception("API limit exceeded. Try later.");
      }

      throw Exception("Server error: ${response.statusCode}");
    } on TimeoutException {
      throw Exception("Request timeout. Check internet.");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}