// import 'dart:developer';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:matchifiy/models/user.dart';
// import 'package:matchifiy/services/token_storage.dart';

// class AuthService {
//   static const _storage = FlutterSecureStorage();
//   static final ip = TokenStorage.getIp();
//   static Future<Map<String, dynamic>?> login(
//     String email,
//     String password,
//   ) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$ip/api/login'),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//         },
//         body: json.encode({'username': email, 'password': password}),
//       );

//       log('Login Response status: ${response.statusCode}');
//       log('Login Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return {
//           'token': data['token'],
//           'role': data['user']['role'],
//           // 'fcm_token': data['fcm_token'],
//           'fcm_token': data['user']['fcm_token'],
//           'user_id': data['user_id'],
//           'name': data['user']['name'],
//           'email': data['user']['email'],
//           'username': data['user']['username'],
//         };
//       } else {
//         return null;
//       }
//     } catch (e) {
//       log('Login Request failed: $e');
//       return null;
//     }
//   }

//   static Future<Map<String, dynamic>?> register(
//     User user,
//     String password,
//     String confirmPassword,
//   ) async {
//     final ip = await TokenStorage.getIp();

//     try {
//       final response = await http.post(
//         Uri.parse('$ip/api/register'),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//         },
//         body: jsonEncode(user.toJsonForRegister(password, confirmPassword)),
//       );

//       log('Register Response status: ${response.statusCode}');
//       log('Register Response body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         return {
//           'token': data['token'],
//           'role': data['user']['role'],
//           'user_id': data['user_id'],
//           'name': data['user']['name'],
//           'email': data['user']['email'],
//           'username': data['user']['username'],
//         };
//       } else {
//         return null;
//       }
//     } catch (e) {
//       log('Register Request failed: $e');
//       return null;
//     }
//   }

//   static Future<Map<String, dynamic>> changePassword({
//     required String currentPassword,
//     required String newPassword,
//     required String confirmPassword,
//   }) async {
//     try {
//       final token = await TokenStorage.getToken();

//       final response = await http.post(
//         Uri.parse('$ip/api/change-password'),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: json.encode({
//           'current_password': currentPassword,
//           'new_password': newPassword,
//           'new_password_confirmation': confirmPassword,
//         }),
//       );

//       log('Change Password Status: ${response.statusCode}');
//       log('Change Password Body: ${response.body}');

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'message': data['message'] ?? 'Password changed successfully',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to change password',
//         };
//       }
//     } catch (e) {
//       log('Change Password Error: $e');
//       return {'success': false, 'message': 'Network error occurred'};
//     }
//   }

//   static Future<Map<String, dynamic>> sendResetLink({
//     required String username,
//     required String email,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$ip/api/forgot-password'),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//         },
//         body: json.encode({'username': username, 'email': email}),
//       );

//       log('Forgot Password Status: ${response.statusCode}');
//       log('Forgot Password Body: ${response.body}');

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'message': data['message'] ?? 'تم إرسال رابط إعادة التعيين بنجاح',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'حدث خطأ ما، يرجى المحاولة لاحقاً',
//         };
//       }
//     } catch (e) {
//       log('Forgot Password Error: $e');
//       return {
//         'success': false,
//         'message': 'فشل الاتصال بالسيرفر، تأكد من اتصالك بالإنترنت',
//       };
//     }
//   }

//   static Future<void> logout() async {
//     final ip = TokenStorage.getIp();
//     final token = await TokenStorage.getToken();

//     try {
//       final response = await http.post(
//         Uri.parse('$ip/api/logout'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       log('Logout Response status: ${response.statusCode}');
//       log('Logout Response body: ${response.body}');

//       await _storage.delete(key: 'token');
//     } catch (e) {
//       log('Logout Request failed: $e');
//     }
//   }

//   static Future<Map<String, dynamic>> resetPassword({
//     required String email,
//     required String token,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$ip/api/reset-password'),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           "ngrok-skip-browser-warning": "true",
//         },
//         body: json.encode({
//           'email': email,
//           'token': token,
//           'password': password,
//           'password_confirmation': confirmPassword,
//         }),
//       );

//       log('Reset Password Status: ${response.statusCode}');
//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {'success': true, 'message': data['message']};
//       } else {
//         return {'success': false, 'message': data['message']};
//       }
//     } catch (e) {
//       log('Reset Password Error: $e');
//       return {'success': false, 'message': null};
//     }
//   }
// }
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
        body: json.encode({'username': email, 'password': password}),
      );

      log('Login Response status: ${response.statusCode}');
      log('Login Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'token': data['token'],
          'role': data['user']['role'],
          // 'fcm_token': data['fcm_token'],
          'fcm_token': data['user']['fcm_token'],
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

  static Future<Map<String, dynamic>?> register(
    User user,
    String password,
    String confirmPassword,
  ) async {
    final ip = await TokenStorage.getIp();

    try {
      final response = await http.post(
        Uri.parse('$ip/api/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(user.toJsonForRegister(password, confirmPassword)),
      );

      log('Register Response status: ${response.statusCode}');
      log('Register Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'token': data['token'],
          'role': data['user']['role'],
          'user_id': data['user_id'],
          'name': data['user']['name'],
          'email': data['user']['email'],
          'username': data['user']['username'],
        };
      } else {
        return null;
      }
    } catch (e) {
      log('Register Request failed: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final token = await TokenStorage.getToken();

      final response = await http.post(
        Uri.parse('$ip/api/change-password'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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
        Uri.parse('$ip/api/forgot-password'),
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

  static Future<void> logout() async {
    final ip = TokenStorage.getIp();
    final token = await TokenStorage.getToken();

    try {
      final response = await http.post(
        Uri.parse('$ip/api/logout'),
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
