import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:matchifiy/services/token_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static final ip = TokenStorage.getIp();
  static Future<void> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Sign-in aborted by user");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        print("Failed to retrieve ID token");
        return;
      }

      final response = await http.post(
        Uri.parse('$ip/api/google-login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['access_token'];
        final user = data['user'];

        print("Token: $token");
        print("User: $user");
      } else {
        print("Login failed: ${response.body}");
      }
    } catch (error) {
      print("Error during Google Sign-In: $error");
    }
  }

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
          'token': data['access_token'],
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

  // static Future<bool> register(Contractor contractor) async {
  //   final ip = await TokenStorage.getIp(); // إذا كانت async

  //   if (ip == null || ip.isEmpty) {
  //     log('Register Error: IP address is null or empty');
  //     return false;
  //   }

  //   try {
  //     final response = await http.post(
  //       Uri.parse('$ip/api/register'),
  //       headers: {
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(contractor.toJsonRegister()),
  //     );

  //     log('Register Response status: ${response.statusCode}');
  //     log('Register Response body: ${response.body}');

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final data = jsonDecode(response.body);
  //       final token = data['access_token'];
  //       log('Register Success, token: $token');
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     log('Register Request failed: $e');
  //     return false;
  //   }
  // }

  // static Future<void> logout() async {
  //   final ip = TokenStorage.getIp();

  //   if (ip == null || ip.isEmpty) {
  //     log('Logout Error: IP address is null or empty');
  //     return;
  //   }

  //   final token = await _storage.read(key: 'token');
  //   if (token == null) {
  //     log('Logout Error: No token found');
  //     return;
  //   }

  //   try {
  //     final response = await http.post(
  //       Uri.parse('$ip/api/logout'),
  //       // Uri.parse('http://$ip:8000/api/logout'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     log('Logout Response status: ${response.statusCode}');
  //     log('Logout Response body: ${response.body}');

  //     await _storage.delete(key: 'token');
  //   } catch (e) {
  //     log('Logout Request failed: $e');
  //   }
  // }
}
