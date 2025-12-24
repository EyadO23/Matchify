import 'dart:developer';
import 'package:matchifiy/models/Video_Filter.dart';
import 'package:http/http.dart' as http;
import 'package:matchifiy/services/token_storage.dart';
import 'dart:convert';

class UserService {
  static final ip = TokenStorage.getIp();
  Future<String?> sendFilter(VideoFilterModel video) async {
    final url = "$ip/api/filters";
    final token = await TokenStorage.getToken();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(video.toJson()),
      );

      log("Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        final extractedText = json["data"]["extracted_text"];
        log("Extracted Text: $extractedText");

        return extractedText;
      }
    } catch (e) {
      log("Error sending filter: $e");
    }

    return null;
  }
}
