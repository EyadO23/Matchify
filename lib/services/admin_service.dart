import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:matchifiy/services/token_storage.dart';

class AdminService {
  String ip = TokenStorage.getIp();

  Future<List<dynamic>> getAllUsers() async {
    final token = await TokenStorage.getToken();
    try {
      final response = await http.get(
        Uri.parse('$ip/api/admin/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      log(response.body);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("فشل جلب المستخدمين: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("خطأ في الاتصال بالسيرفر: $e");
    }
  }

  Future<Map<String, dynamic>> deleteUser(int userId) async {
    final token = await TokenStorage.getToken();
    try {
      final response = await http.delete(
        Uri.parse("$ip/api/admin/users/$userId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        return result;
      } else {
        throw Exception(result['message'] ?? "فشل عملية الحذف");
      }
    } catch (e) {
      throw Exception("خطأ أثناء الحذف: $e");
    }
  }

  Future<Map<String, dynamic>> getUserReport(int userId) async {
    try {
      final token = await TokenStorage.getToken();

      final response = await http.get(
        Uri.parse("$ip/api/admin/users/$userId/video-reports"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      log(response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("فشل جلب تقارير المستخدم: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("خطأ في الاتصال: $e");
    }
  }

  Future<Map<String, dynamic>> getAllReports() async {
    final String _url = "$ip/api/videos/reportAll";
    final token = await TokenStorage.getToken();
    try {
      final response = await http.get(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception("فشل تحميل البيانات");
    } catch (e) {
      rethrow;
    }
  }
}
