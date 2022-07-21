import 'package:book_app/controller/book_controller.dart';
import 'package:book_app/screen/detail_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookController? bookController;

  @override
  void initState() {
    bookController = Provider.of<BookController>(context, listen: false);
    bookController!.fetchBookApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Catalogue"),
        centerTitle: true,
      ),
      body: Consumer<BookController>(
        builder: (context, value, child) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: bookController!.bookListResponse == null
              ? child
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final data =
                        bookController!.bookListResponse!.books![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailBookScreen(isbn: data.isbn13!),
                            ));
                      },
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                  itemCount:
                      int.parse(bookController!.bookListResponse?.total ?? '0'),
                ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
