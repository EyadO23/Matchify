import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:matchifiy/services/token_storage.dart';

class FavoriteTeamService {
  static final ip = TokenStorage.getIp();
  // جلب الفريق المفضل من الباكيند
  Future<String?> getFavoriteTeam() async {
    final token = await TokenStorage.getToken();

    // إذا لم يوجد توكين، لا داعي لإرسال الطلب
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$ip/api/favorite-team'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      log("Get Favorite Team Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // ملاحظة: تأكد من أن الباكيند يرسل الحقل بهذا الاسم (مثلاً team أو favorite_team)
        return data['team']?.toString();
      }
      return null;
    } catch (e) {
      log("Error fetching favorite team: $e");
      return null;
    }
  }

  // حفظ أو تعديل الفريق المفضل
  Future<bool> saveFavoriteTeam(String teamName) async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      log("Error: No token found in storage");
      return false;
    }

    try {
      // إرسال الطلب للباكيند
      final response = await http.post(
        Uri.parse('$ip/api/favorite-team'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        // ملاحظة مهمة: تأكد من اسم الحقل المتوقع في الـ Controller (مثلاً team_id أو team_name)
        body: jsonEncode({'team': teamName}),
      );

      // طباعة الرد لمساعدتك في معرفة ما إذا كان الباكيند يرفض الطلب (مثل 422 Validation Error)
      log("Save Favorite Team Status: ${response.statusCode}");
      log("Save Favorite Team Response: ${response.body}");

      // التحقق من النجاح (200 أو 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Exception while saving favorite team: $e");
      return false;
    }
  }
}
