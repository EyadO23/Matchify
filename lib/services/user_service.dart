// import 'dart:developer';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:matchifiy/models/Video_Filter.dart';
// import 'package:http/http.dart' as http;
// import 'package:matchifiy/services/token_storage.dart';
// import 'dart:convert';

// class UserService {
//   static final ip = TokenStorage.getIp();
//   final Dio _dio = Dio();

//   // رابط السيرفر (استبدله بالرابط الحقيقي)
//   final String _uploadUrl = "https://your-api.com/api/upload-video";

//   Future<Response?> uploadMatchVideo({
//     required File videoFile,
//     required Function(double) onProgress,
//   }) async {
//     try {
//       // تجهيز البيانات
//       FormData formData = FormData.fromMap({
//         "video": await MultipartFile.fromFile(
//           videoFile.path,
//           filename: videoFile.path.split('/').last,
//         ),
//       });

//       // إرسال الطلب
//       Response response = await _dio.post(
//         _uploadUrl,
//         data: formData,
//         onSendProgress: (sent, total) {
//           // حساب النسبة المئوية وإرسالها للواجهة
//           double progress = sent / total;
//           onProgress(progress);
//         },
//         options: Options(
//           sendTimeout: const Duration(minutes: 5), // مهلة رفع 5 دقائق
//           receiveTimeout: const Duration(minutes: 5),
//         ),
//       );

//       return response;
//     } on DioException catch (e) {
//       print("خطأ في Dio: ${e.message}");
//       return null;
//     } catch (e) {
//       print("خطأ غير متوقع: $e");
//       return null;
//     }
//   }

//   Future<String?> sendFilter(VideoFilterModel video) async {
//     final url = "$ip/api/filters";
//     final token = await TokenStorage.getToken();

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(video.toJson()),
//       );

//       log("Status Code: ${response.statusCode}");
//       log("Response Body: ${response.body}");

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final Map<String, dynamic> json = jsonDecode(response.body);

//         final extractedText = json["data"]["extracted_text"];
//         log("Extracted Text: $extractedText");

//         return extractedText;
//       }
//     } catch (e) {
//       log("Error sending filter: $e");
//     }

//     return null;
//   }
// }
import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:matchifiy/models/matchify_model.dart';
import 'dart:convert';
import 'package:matchifiy/services/token_storage.dart';

class UserService {
  // ملاحظة: تأكد أن getIp دالة تعيد String في ملف TokenStorage
  static final ip = TokenStorage.getIp();
  // static const String _defaultIp = "http://192.168.1.1:8000";
  final Dio _dio = Dio();

  // Future<String> _getBaseUrl() async {
  //   try {
  //     // محاولة جلب IP ديناميكي من التخزين، أو استخدام الافتراضي
  //     String? storedIp = await TokenStorage.getIp();
  //     return storedIp ?? ip;
  //   } catch (e) {
  //     return ip;
  //   }
  // }
  // Future<int?> uploadVideoJob({
  //   required File videoFile,
  //   required String filterType,
  //   required String summaryType,
  //   String? playerName,
  //   required Function(double) onProgress,
  // }) async {
  //   final token = await TokenStorage.getToken();
  //   // final baseUrl = await _getBaseUrl();
  //   final url = "$ip/api/filter";
  //   log(url.toString());
  //   // if (!videoFile.existsSync()) {
  //   //   throw Exception("Video file not found");
  //   // }

  //   try {
  //     final formData = FormData.fromMap({
  //       "video": await MultipartFile.fromFile(
  //         videoFile.path,
  //         filename: videoFile.path.split('/').last,
  //       ),
  //       "filter_type": filterType,
  //       "summary_type": summaryType,

  //       // if (playerName != null && playerName.isNotEmpty)
  //       //   "player_name": playerName,
  //     });

  //     final response = await _dio.post(
  //       url,
  //       data: formData,
  //       onSendProgress: (sent, total) {
  //         if (total > 0) onProgress(sent / total);
  //       },
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer $token",
  //           "Accept": "application/json",
  //           "Content-Type": "multipart/form-data",
  //         },
  //         sendTimeout: const Duration(minutes: 10),
  //         receiveTimeout: const Duration(minutes: 10),
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       log(response.data);
  //       return response.data;
  //       // return response.data["job_id"];
  //     }
  //   } on DioException catch (e) {
  //     log("Upload error: ${e.response?.data}");
  //     throw Exception(e.response?.data?['message'] ?? "فشل رفع الفيديو");
  //   }

  //   return null;
  // }

  // Future<Map<String, dynamic>?> uploadVideoJob({
  //   required File videoFile,
  //   required String filterType,
  //   required String summaryType,
  //   String? playerName,
  //   required Function(double) onProgress,
  // }) async {
  //   final token = await TokenStorage.getToken();
  //   final url = "$ip/api/filter";
  //   log(url.toString());

  //   try {
  //     final formData = FormData.fromMap({
  //       "video": await MultipartFile.fromFile(
  //         videoFile.path,
  //         filename: videoFile.path.split('/').last,
  //       ),
  //       "filter_type": filterType,
  //       "summary_type": summaryType,
  //     });

  //     final response = await _dio.post(
  //       url,
  //       data: formData,
  //       onSendProgress: (sent, total) {
  //         if (total > 0) onProgress(sent / total);
  //       },
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer $token",
  //           "Accept": "application/json",
  //           "Content-Type": "multipart/form-data",
  //         },
  //         sendTimeout: const Duration(minutes: 10),
  //         receiveTimeout: const Duration(minutes: 10),
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       log(response.data.toString());
  //       return Map<String, dynamic>.from(response.data);
  //     }
  //   } on DioException catch (e) {
  //     log("Upload error: ${e.response?.data}");
  //     throw Exception(e.response?.data?['message'] ?? "فشل رفع الفيديو");
  //   }

  //   return null;
  // }
  Future<Map<String, dynamic>?> uploadVideoJob({
    required File videoFile,
    required String filterType,
    required String summaryType,
    required Function(double) onProgress,
  }) async {
    final token = await TokenStorage.getToken();
    final url = "$ip/api/videos";
    // final url = "$ip/api/filter";

    final formData = FormData.fromMap({
      "video": await MultipartFile.fromFile(
        videoFile.path,
        filename: videoFile.path.split('/').last,
      ),
      "summary_type": filterType,
      // "filter_type": filterType,
      "summary_length": summaryType,
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
      ),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    }

    return null;
  }

  Future<Map<String, dynamic>?> generateSummary({
    required String clipsDir,
    required String summaryType,
    required String summaryLength,
    required String videoId,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await _dio.post(
      "$ip/api/video_summaries/generate",
      data: {
        "clips_dir": clipsDir,
        "summary_type": summaryType,
        "summary_length": summaryLength,
        "video_id": videoId,
      },
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

  Future<Map<String, dynamic>?> getGenerateResult(String jobId) async {
    final token = await TokenStorage.getToken();
    final response = await _dio.get(
      "$ip/api/video_summaries/$jobId/result",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );
    if (response.statusCode == 200)
      return Map<String, dynamic>.from(response.data);
    return null;
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

  Future<Map<String, dynamic>?> fetchAnalysisResults({
    required String clipsDir,
  }) async {
    final token = await TokenStorage.getToken();

    try {
      final uri = Uri.parse(
        '$ip/highlights/generate',
      ).replace(queryParameters: {'clips_dir': clipsDir});

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error fetching results: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  // Future<MatchifyResult?> fetchAnalysisResults(String jobId) async {
  //   final token = await TokenStorage.getToken();
  //   try {
  //     // final url = '$ip/highlights/generate';
  //     // final response = await http.get(Uri.parse('$ip/highlights/generate'));
  //     final url = Uri.parse('$ip/highlights/generate');
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization':
  //             'Bearer $token', // استبدل YOUR_TOKEN_HERE بالتوكين الفعلي
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       return MatchifyResult.fromJson(data);
  //     } else {
  //       print("Error fetching results: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Exception: $e");
  //     return null;
  //   }
  // }

  Future<Map<String, dynamic>?> getJobResult(String jobId) async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('$ip/highlights/result/$jobId');
    final resp = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "multipart/form-data",
      },
    );

    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    } else {
      print("Error fetching job result: ${resp.body}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> waitForJobCompletion(String jobId) async {
    int retryCount = 0;
    const int maxRetries =
        60; // انتظر لمدة 5 دقائق كحد أقصى (60 محاولة * 5 ثوانٍ)

    while (retryCount < maxRetries) {
      try {
        final token = await TokenStorage.getToken();
        // نستخدم نفس التوكين المستخدم في الرفع
        // String? token = await _getToken();

        // تأكد من الرابط الصحيح لفحص الحالة (Status)
        // غالباً يكون المسار /jobs/{id} أو /status/{id}
        final response = await http.get(
          Uri.parse('$ip/jobs/$jobId'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          log(
            "Job Status Check: ${data['status']} - Progress: ${data['progress']}%",
          );

          if (data['status'] == 'completed') {
            return data; // نجحت العملية
          } else if (data['status'] == 'failed') {
            log("Job failed on server side");
            return null;
          }
        }
      } catch (e) {
        log("Error polling job: $e");
      }

      retryCount++;
      await Future.delayed(
        const Duration(seconds: 5),
      ); // انتظر 5 ثوانٍ قبل الفحص القادم
    }
    return null; // انتهى الوقت ولم تكتمل المعالجة
  }

  /// Poll until job is completed
  // Future<Map<String, dynamic>?> waitForJobCompletion(
  //   String jobId, {
  //   int intervalSeconds = 2,
  // }) async {
  //   Map<String, dynamic>? result;
  //   bool done = false;

  //   while (!done) {
  //     await Future.delayed(Duration(seconds: intervalSeconds));
  //     result = await getJobResult(jobId);
  //     if (result == null) return null;
  //     if (result['status'] == 'completed' || result['status'] == 'failed') {
  //       done = true;
  //     }
  //   }

  //   return result;
  // }

  // رفع الفيديو وإنشاء Job
  // Future<int?> uploadVideoJob({
  //   required File videoFile,
  //   required String filterType,
  //   required String summaryType,
  //   String? playerName,
  //   required Function(double) onProgress,
  // }) async {
  //   final token = await TokenStorage.getToken();
  //   final baseUrl = await _getBaseUrl();
  //   final url = "$baseUrl/api/filters";

  //   try {
  //     FormData formData = FormData.fromMap({
  //       "video": await MultipartFile.fromFile(
  //         videoFile.path,
  //         filename: videoFile.path.split('/').last,
  //       ),
  //       "filter_type": filterType,
  //       "summary_type": summaryType,
  //       if (playerName != null && playerName.isNotEmpty)
  //         "player_name": playerName,
  //     });

  //     final response = await _dio.post(
  //       url,
  //       data: formData,
  //       onSendProgress: (sent, total) {
  //         if (total > 0) onProgress(sent / total);
  //       },
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer $token",
  //           "Accept": "application/json",
  //         },
  //         sendTimeout: const Duration(minutes: 10),
  //         receiveTimeout: const Duration(minutes: 10),
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       return response.data["job_id"];
  //     }
  //   } catch (e) {
  //     log("Upload error: $e");
  //   }
  //   return null;
  // }

  // Future<Map<String, dynamic>?> getJobResult(int jobId) async {
  //   final token = await TokenStorage.getToken();
  //   final baseUrl = await TokenStorage.getIp();
  //   final url = "$baseUrl/api/filter/result/$jobId";
  //   // final url = "$baseUrl/api/filters/$jobId";

  //   try {
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Accept": "application/json",
  //         "Content-Type": "application/json",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       log("Job result response: $data");
  //       return Map<String, dynamic>.from(data);
  //     }
  //   } catch (e) {
  //     log("Get job error: $e");
  //   }

  //   return null;
  // }

  // Future<Map<String, dynamic>?> getJobResult(int jobId) async {
  //   final token = await TokenStorage.getToken();
  //   final baseUrl = await TokenStorage.getIp();
  //   final url = "$baseUrl/api/filters/$jobId";

  //   try {
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Accept": "application/json",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       log("Full response: $data");

  //       //  نرجع فقط result
  //       return Map<String, dynamic>.from(data['result']);
  //     }
  //   } catch (e) {
  //     log("Get job error: $e");
  //   }

  //   return null;
  // }

  // جلب نتيجة Job
  // Future<Map<String, dynamic>?> getJobResult(int jobId) async {
  //   final token = await TokenStorage.getToken();
  //   // final baseUrl = await _getBaseUrl();
  //   // final url = "$ip/api/filter/result/9";
  //   final url = "$ip/api/filters/$jobId";

  //   try {
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Accept": "application/json",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       // return jsonDecode(response.body);

  //       final data = jsonDecode(response.body);
  //       // ملاحظة: تأكد من أن الباكيند يرسل الحقل بهذا الاسم (مثلاً team أو favorite_team)
  //       log(data.toString());
  //       return data['results'];
  //     }
  //   } catch (e) {
  //     log("Get job error: $e");
  //   }
  //   return null;
  // }

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
    required String summaryType,
    required String summaryLength,
    required String videoId,
  }) async {
    final token = await TokenStorage.getToken();
    if (token == null) return null;

    final url = "$ip/api/video_summaries/generate";

    final response = await _dio.post(
      url,
      data: {
        "clips_dir": clipsDir,
        "summary_type": summaryType,
        "summary_length": summaryLength,
        "video_id": videoId,
      },
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
}
