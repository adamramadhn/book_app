import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/book_list_response.dart';
import 'package:http/http.dart' as http;
import 'package:book_app/models/detail_book_response.dart';
import 'package:book_app/models/simlar_response.dart';

class BookController with ChangeNotifier {
  BookListResponse? bookListResponse;
  fetchBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    if (response.statusCode == 200) {
      final jsonBookList = jsonDecode(response.body);
      bookListResponse = BookListResponse.fromJson(jsonBookList);
      notifyListeners();
    }
  }

  DetailBookResponse? detailBookResponse;
  fetchDetailBookApi(isbn) async {
    var url = Uri.parse('https://api.itbook.store/1.0/books/$isbn');
    var response = await http.post(url);

    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      detailBookResponse = DetailBookResponse.fromJson(jsonDetail);
      fetchSimiliarBookApi(detailBookResponse?.title ?? '');
      notifyListeners();
    }
  }

  SimilarBookResponse? similarBookResponse;
  fetchSimiliarBookApi(String title) async {
    var url = Uri.parse('https://api.itbook.store/1.0/search/$title');
    var response = await http.post(url);

    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      similarBookResponse = SimilarBookResponse.fromJson(jsonDetail);
      notifyListeners();
    }
  }
}
