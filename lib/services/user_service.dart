import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:matchifiy/models/user_highlight_model.dart';
import 'dart:convert';
import 'package:matchifiy/services/token_storage.dart';

class UserService {
  static final ip = TokenStorage.getIp();
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> uploadVideoJob({
    required File videoFile,
    required String filterType,
    required Function(double) onProgress,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      final url = "$ip/api/videos";

      final formData = FormData.fromMap({
        "video": await MultipartFile.fromFile(
          videoFile.path,
          filename: videoFile.path.split('/').last,
        ),
        "summary_type": filterType,
      });

      final response = await _dio.post(
        url,
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) onProgress(sent / total);
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          sendTimeout: const Duration(minutes: 20),
          receiveTimeout: const Duration(minutes: 20),
        ),
      );
      log(Map<String, dynamic>.from(response.data).toString());
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      }
      return null;
    } catch (e) {
      if (e.toString().contains('Connection closed')) {
        await Future.delayed(Duration(seconds: 10));
        return await uploadVideoJob(
          videoFile: videoFile,
          filterType: filterType,
          onProgress: onProgress,
        );
      } else if (e.toString().contains('Dio')) {
        throw Exception('عذراً يرجى التحقق من صحة الانترنت والمحاولة لاحقاً ');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getGenerateResult(String videoJobId) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return null;

      final uri = Uri.parse("$ip/api/video_summaries/$videoJobId/result");

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      log(response.statusCode.toString());
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        final data = jsonDecode(response.body);
        log(data.toString());
        return data;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      if (e.toString().contains('Connection closed')) {
        // لا توقف العملية
        await Future.delayed(Duration(seconds: 10));
        return await getGenerateResult(videoJobId);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getVideoProgress(String jobId) async {
    final token = await TokenStorage.getToken();

    final response = await _dio.get(
      "$ip/api/videos/$jobId/progress",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    }

    return null;
  }

  Future<Map<String, dynamic>?> fetchUploadProgress(String jobId) async {
    final token = await TokenStorage.getToken();
    if (token == null) return null;

    final url = "$ip/api/videos/$jobId/progress";

    final response = await _dio.get(
      url,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    if (response.statusCode == 200) {
      log(response.data.toString());
      return Map<String, dynamic>.from(response.data);
    }
    return null;
  }

  Future<Map<String, dynamic>?> generateVideoSummary({
    required String clipsDir,
    required String videoId,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return null;

      final url = Uri.parse("$ip/api/video_summaries/generate");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"clips_dir": clipsDir, "video_id": videoId}),
      );
      log(response.toString());
      if (response.statusCode == 200) {
        log(response.body.toString());
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      if (e.toString().contains('Connection closed')) {
        await Future.delayed(Duration(seconds: 10));
        return await generateVideoSummary(clipsDir: clipsDir, videoId: videoId);
      }
      rethrow;
    }
  }

  final String _url = "$ip/api/my/highlights";

  Future<List<UserHighlight>> getMyHighlights() async {
    final token = await TokenStorage.getToken();
    try {
      final response = await http.get(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      log(response.statusCode.toString());
      log(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          Iterable list = data['highlights'];
          log(list.toString());
          return list.map((model) => UserHighlight.fromJson(model)).toList();
        }
      }
      return [];
    } catch (e) {
      print("Error fetching highlights: $e");
      return [];
    }
  }
}
