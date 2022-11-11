import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speeches/NewsData.dart';

class NewsAPI {
  NewsData newsData = NewsData();

  getTopHeadlines(country, category) async {
    var response = await http.get(Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=in&category=technology&apiKey=3e0409d94d1240a5948c27e8e4bec961"));
    var data = (jsonDecode(response.body));


    return data;
  }
}