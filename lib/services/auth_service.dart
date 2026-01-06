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
          'ngrok-skip-browser-warning': 'true',
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
          'name': data['user']['name'],
          'email': data['user']['email'],
          'username': data['user']['username'],
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
          'ngrok-skip-browser-warning': 'true',
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

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      // جلب التوكن لأن العملية تتطلب صلاحية (Authorization)
      final token = await TokenStorage.getToken();

      final response = await http.post(
        Uri.parse('$ip/api/change-password'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // إرسال التوكن في الـ Header
        },
        body: json.encode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        }),
      );

      log('Change Password Status: ${response.statusCode}');
      log('Change Password Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password changed successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to change password',
        };
      }
    } catch (e) {
      log('Change Password Error: $e');
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  static Future<Map<String, dynamic>> sendResetLink({
    required String username,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$ip/api/forgot-password'), // تأكد من المسار في الباك اند
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: json.encode({'username': username, 'email': email}),
      );

      log('Forgot Password Status: ${response.statusCode}');
      log('Forgot Password Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'تم إرسال رابط إعادة التعيين بنجاح',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'حدث خطأ ما، يرجى المحاولة لاحقاً',
        };
      }
    } catch (e) {
      log('Forgot Password Error: $e');
      return {
        'success': false,
        'message': 'فشل الاتصال بالسيرفر، تأكد من اتصالك بالإنترنت',
      };
    }
  }

  // static Future<Map<String, dynamic>?> sendFirebaseIdToken(
  //   String idToken,
  // ) async {
  //   try {
  //     final ip = await TokenStorage.getIp();

  //     final response = await http.post(
  //       Uri.parse("$ip/api/auth/firebase"),
  //       headers: {
  //         "Accept": "application/json",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({"token": idToken}),
  //       // body: jsonEncode({"id_token": idToken}),
  //     );

  //     log(" Backend Response Status: ${response.statusCode}");
  //     log(" Backend Response Body: ${response.body}");

  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body);
  //     }

  //     return null;
  //   } catch (e) {
  //     log("🔥 Error sending Firebase ID Token: $e");
  //     return null;
  //   }
  // }

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

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$ip/api/reset-password'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "ngrok-skip-browser-warning": "true",
        },
        body: json.encode({
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      log('Reset Password Status: ${response.statusCode}');
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      log('Reset Password Error: $e');
      return {'success': false, 'message': null};
    }
  }
}
