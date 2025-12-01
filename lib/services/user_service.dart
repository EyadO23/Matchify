import 'dart:developer';

import 'package:matchifiy/models/Video_Filter.dart';
import 'package:http/http.dart' as http;
import 'package:matchifiy/services/token_storage.dart';
import 'dart:convert';

class UserService {
  static final ip = TokenStorage.getIp();

  // Future<void> sendFilter(VideoFilterModel video) async {
  //   final url = "$ip/api/filters";
  //   final token = await TokenStorage.getToken();
  //   final response = await http.post(
  //     Uri.parse(url),
  //     body: video.toJson(),
  //     headers: {
  //       'Accept': 'application/json',
  //       'Content-Type': 'application/json',
  //       // 'Authorization': 'Bearer $token',
  //     },
  //   );

  //   print("Status: ${response.statusCode}");
  //   print("Body: ${response.body}");
  // }
  Future<void> sendFilter(VideoFilterModel video) async {
    final url = "$ip/api/filters";
    final token = await TokenStorage.getToken();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token",
        },
        body: jsonEncode(video.toJson()),
      );

      log("Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");

      //  إذا في خطأ 422، اطبع الأخطاء بالتفصيل
      if (response.statusCode == 422) {
        try {
          final Map<String, dynamic> json = jsonDecode(response.body);

          if (json.containsKey("errors")) {
            log(" VALIDATION ERRORS:");

            json["errors"].forEach((key, value) {
              log("- $key: ${value.join(", ")}");
            });
          }
        } catch (e) {
          log("Error decoding 422 response: $e");
        }
      }
    } catch (e) {
      log("Error sending filter: $e");
    }
  }

  // Future<void> sendFilter(VideoFilterModel video) async {
  //   final url = "$ip/api/filters";

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         "Accept": "application/json",
  //         "Content-Type": "application/json", // مهم
  //       },
  //       body: jsonEncode(video.toJson()), // << يجب استخدام jsonEncode
  //     );

  //     log("Status: ${response.statusCode}");
  //     log("Body: ${response.body}");
  //   } catch (e) {
  //     log("Error sending filter: $e");
  //   }
  // }
}
