import 'dart:convert';

import 'package:book_app/models/detail_book_response.dart';
import 'package:book_app/models/simlar_response.dart';
import 'package:book_app/screen/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailBookScreen extends StatefulWidget {
  const DetailBookScreen({Key? key, required this.isbn}) : super(key: key);
  final String isbn;
  @override
  State<DetailBookScreen> createState() => _DetailBookScreenState();
}

class _DetailBookScreenState extends State<DetailBookScreen> {
  DetailBookResponse? detailBookResponse;
  fetchDetailBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/books/${widget.isbn}');
    var response = await http.post(url);

    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      detailBookResponse = DetailBookResponse.fromJson(jsonDetail);
      setState(() {});
      fetchSimiliarBookApi(detailBookResponse?.title ?? '');
    }
  }

  SimilarBookResponse? similarBookResponse;
  fetchSimiliarBookApi(String title) async {
    var url = Uri.parse('https://api.itbook.store/1.0/search/$title');
    var response = await http.post(url);

    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      similarBookResponse = SimilarBookResponse.fromJson(jsonDetail);
      setState(() {});
    }
  }

  @override
  void initState() {
    fetchDetailBookApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Book"),
        centerTitle: true,
      ),
      body: detailBookResponse == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
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
                                  imgUrl: detailBookResponse?.image ?? '..'),
                            )),
                        child: Image.network(
                          detailBookResponse?.image ?? '..',
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
                                detailBookResponse?.title ?? '..',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                detailBookResponse?.authors ?? '..',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                detailBookResponse?.subtitle ?? '..',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                              Row(
                                children: List.generate(
                                    5,
                                    (index) => Icon(
                                          Icons.star,
                                          color: index <=
                                                  int.parse(detailBookResponse!
                                                      .rating!)
                                              ? Colors.yellow
                                              : Colors.grey,
                                        )),
                              ),
                              Text(
                                detailBookResponse?.price ?? '..',
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
                        onPressed: () {}, child: const Text("Buy")),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(detailBookResponse?.desc ?? '..'),
                      Text("Year: ${detailBookResponse?.year}"),
                      Text("ISBN: ${detailBookResponse?.isbn10}"),
                      Text("Total Page: ${detailBookResponse?.pages}"),
                      Text("Publisher: ${detailBookResponse?.publisher}"),
                      Text("Language: ${detailBookResponse?.language}"),
                    ],
                  ),
                  const Divider(),
                  similarBookResponse == null
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: similarBookResponse?.books?.length ?? 0,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 100,
                                child: Column(
                                  children: [
                                    Image.network(
                                      similarBookResponse
                                              ?.books?[index].image ??
                                          '',
                                      height: 100,
                                    ),
                                    Text(
                                      similarBookResponse
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
    );
  }
}
