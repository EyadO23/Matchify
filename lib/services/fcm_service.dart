import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:matchifiy/services/token_storage.dart';

class FcmService {
  static final ip = TokenStorage.getIp();

  static Future<bool> sendTokenToBackend(String fcmToken) async {
    final token = await TokenStorage.getToken();

    try {
      final response = await http.post(
        Uri.parse('$ip/api/save-fcm-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'fcm_token': fcmToken}),
      );

      log('= FCM save status: ${response.statusCode}');
      log('= Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(' Error sending FCM token: $e');
      return false;
    }
  }
}
