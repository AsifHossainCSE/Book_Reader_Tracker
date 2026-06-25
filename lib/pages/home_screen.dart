import 'package:book_reader_tracker/components/gridview_widgets.dart';
import 'package:book_reader_tracker/models/book.dart';
import 'package:book_reader_tracker/network/network.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Network network = Network();

  List<Book> _books = [];
  bool _isLoading = false;

  Future<void> _searchBooks(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final books = await network.searchBooks(query);

      setState(() {
        _books = books;
      });
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Search"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search for a book',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onSubmitted: _searchBooks,
            ),

            const SizedBox(height: 10),

            if (_isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: _books.isEmpty
                    ? const Center(
                        child: Text("Search books to get started"),
                      )
                    : GridViewWidget(books: _books),
              ),
          ],
        ),
      ),
    );
  }
}