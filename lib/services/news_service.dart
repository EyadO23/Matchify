import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:matchifiy/services/token_storage.dart';
import '../models/team_news_model.dart';

class NewsService {
  static final ip = TokenStorage.getIp();

  Future<TeamNews> getTeamNews(String team) async {
    try {
      final response = await http.post(
        Uri.parse('$ip/api/team-news'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'team': team}),
      );

      // طباعة حالة الرد والبيانات القادمة من الباكيند للتأكد منها
      log("Team News Status Code: ${response.statusCode}");
      log("Team News Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception('فشل تحميل الأخبار: كود الحالة ${response.statusCode}');
      }

      // تحويل النص المستلم إلى JSON ثم إلى كائن TeamNews
      final Map<String, dynamic> data = jsonDecode(response.body);
      return TeamNews.fromJson(data);
    } catch (e) {
      // طباعة الخطأ في حال حدوث مشكلة في الاتصال أو التحويل
      log("Error in NewsService: $e");
      rethrow;
    }
  }
}
