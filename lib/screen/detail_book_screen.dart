import 'package:book_app/controller/book_controller.dart';
import 'package:book_app/screen/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookScreen extends StatefulWidget {
  const DetailBookScreen({Key? key, required this.isbn}) : super(key: key);
  final String isbn;
  @override
  State<DetailBookScreen> createState() => _DetailBookScreenState();
}

class _DetailBookScreenState extends State<DetailBookScreen> {
  BookController? bookController;
  @override
  void initState() {
    bookController = Provider.of<BookController>(context, listen: false);
    bookController!.fetchDetailBookApi(widget.isbn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Book"),
        centerTitle: true,
      ),
      body: Consumer<BookController>(
        child: const Center(child: CircularProgressIndicator()),
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(10),
          child: bookController!.detailBookResponse == null
              ? child
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageView(
                                    imgUrl: bookController!
                                            .detailBookResponse?.image ??
                                        '..'),
                              )),
                          child: Image.network(
                            bookController!.detailBookResponse?.image ?? '..',
                            height: 100,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bookController!.detailBookResponse?.title ??
                                      '..',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  bookController!.detailBookResponse?.authors ??
                                      '..',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  bookController!
                                          .detailBookResponse?.subtitle ??
                                      '..',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                Row(
                                  children: List.generate(
                                      5,
                                      (index) => Icon(
                                            Icons.star,
                                            color: index <=
                                                    int.parse(bookController!
                                                        .detailBookResponse!
                                                        .rating!)
                                                ? Colors.yellow
                                                : Colors.grey,
                                          )),
                                ),
                                Text(
                                  bookController!.detailBookResponse?.price ??
                                      '..',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            Uri uri = Uri.parse(
                                bookController!.detailBookResponse!.url!);
                            try {
                              launchUrl(uri);
                            } catch (e) {}
                          },
                          child: const Text("Buy")),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bookController!.detailBookResponse?.desc ?? '..'),
                        Text(
                            "Year: ${bookController!.detailBookResponse?.year}"),
                        Text(
                            "ISBN: ${bookController!.detailBookResponse?.isbn10}"),
                        Text(
                            "Total Page: ${bookController!.detailBookResponse?.pages}"),
                        Text(
                            "Publisher: ${bookController!.detailBookResponse?.publisher}"),
                        Text(
                            "Language: ${bookController!.detailBookResponse?.language}"),
                      ],
                    ),
                    const Divider(),
                    bookController!.similarBookResponse == null
                        ? const Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: bookController!
                                      .similarBookResponse?.books?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        bookController!.similarBookResponse
                                                ?.books?[index].image ??
                                            '',
                                        height: 100,
                                      ),
                                      Text(
                                        bookController!.similarBookResponse
                                                ?.books?[index].title ??
                                            '..',
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
        ),
      ),
    );
  }
}
