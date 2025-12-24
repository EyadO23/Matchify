import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:matchifiy/models/user.dart';
import 'package:matchifiy/services/token_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static final ip = TokenStorage.getIp();
  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$ip/api/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        // body: json.encode({'email': email, 'password': password}),
        body: json.encode({'username': email, 'password': password}),
      );

      log('Login Response status: ${response.statusCode}');
      log('Login Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'token': data['token'],
          'role': data['role'],
          'user_id': data['user_id'],
        };
      } else {
        return null;
      }
    } catch (e) {
      log('Login Request failed: $e');
      return null;
    }
  }

  static Future<bool> register(
    User user,
    String password,
    String confirmPassword,
  ) async {
    final ip = await TokenStorage.getIp();

    if (ip == null || ip.isEmpty) {
      log('Register Error: IP address is null or empty');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$ip/api/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        // تمرير كلمة المرور وتأكيدها إلى دالة toJsonForRegister المعدلة
        body: jsonEncode(user.toJsonForRegister(password, confirmPassword)),
      );

      log('Register Response status: ${response.statusCode}');
      log('Register Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'] ?? data['access_token'];
        // هنا يتم تخزين التوكن إذا كان متوفراً
        if (token != null && token.isNotEmpty) {
          // مثال: await TokenStorage.saveToken(token);
        }
        log('Register Success, token: $token');
        return true;
      } else {
        // إذا كان الرد 422 (خطأ تحقق)، يمكنك عرض رسالة الخطأ
        if (response.statusCode == 422) {
          final errorData = jsonDecode(response.body);
          log('Validation Error: ${errorData['errors']}');
        }
        return false;
      }
    } catch (e) {
      log('Register Request failed: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> sendFirebaseIdToken(
    String idToken,
  ) async {
    try {
      final ip = await TokenStorage.getIp();

      final response = await http.post(
        Uri.parse("$ip/api/auth/firebase"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"token": idToken}),
        // body: jsonEncode({"id_token": idToken}),
      );

      log(" Backend Response Status: ${response.statusCode}");
      log(" Backend Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      log("🔥 Error sending Firebase ID Token: $e");
      return null;
    }
  }

  static Future<void> logout() async {
    final ip = TokenStorage.getIp();

    if (ip == null || ip.isEmpty) {
      log('Logout Error: IP address is null or empty');
      return;
    }

    final token = await _storage.read(key: 'token');
    if (token == null) {
      log('Logout Error: No token found');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$ip/api/logout'),
        // Uri.parse('http://$ip:8000/api/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('Logout Response status: ${response.statusCode}');
      log('Logout Response body: ${response.body}');

      await _storage.delete(key: 'token');
    } catch (e) {
      log('Logout Request failed: $e');
    }
  }
}
