import 'dart:convert';

import 'package:book_app/models/book_list_response.dart';
import 'package:book_app/screen/detail_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// https://jsonplaceholder.typicode.com/photos
// https://api.itbook.store/1.0/new
// https://api.itbook.store/1.0/books/9781484206485
// https://api.itbook.store/1.0/search/Flutter Developer
//
class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookListResponse? bookListResponse;
  fetchBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final jsonBookList = jsonDecode(response.body);
      bookListResponse = BookListResponse.fromJson(jsonBookList);
      setState(() {});
    }
  }

  @override
  void initState() {
    fetchBookApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Catalogue"),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: bookListResponse == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemBuilder: (context, index) {
                  final data = bookListResponse!.books![index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailBookScreen(isbn: data.isbn13!),
                        )),
                    child: Row(
                      children: [
                        Image.network(
                          data.image ?? "...",
                          height: 100,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.title ?? '...',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(data.subtitle ?? '...'),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  data.price ?? '...',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  );
                },
                itemCount: int.parse(bookListResponse?.total ?? '0'),
              ),
      ),
    );
  }
}
