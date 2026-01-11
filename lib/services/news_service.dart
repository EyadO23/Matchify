import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:matchifiy/services/token_storage.dart';
import '../models/team_news_model.dart';

class NewsService {
  static final ip = TokenStorage.getIp();
  Future<TeamNews> getNews() async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('$ip/api/team-news/favorites'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      log(response.body);
      final data = jsonDecode(response.body);
      return TeamNews.fromJson(data);
    } else {
      throw Exception('Failed to load news');
    }
  }
}
