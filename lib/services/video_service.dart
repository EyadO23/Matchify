// import 'package:video_player/video_player.dart';
// import 'package:matchifiy/services/token_storage.dart';

// class VideoService {
//   VideoPlayerController? _controller;

//   VideoPlayerController? get controller => _controller;

//   bool get isInitialized => _controller?.value.isInitialized ?? false;

//   Future<void> init(String videoUrl) async {
//     final token = await TokenStorage.getToken();

//     _controller = VideoPlayerController.network(
//       videoUrl,
//       httpHeaders: {"Authorization": "Bearer $token", "Accept": "video/mp4"},
//     );

//     await _controller!.initialize();
//     _controller!.play();
//   }

//   void play() => _controller?.play();
//   void pause() => _controller?.pause();

//   void dispose() {
//     _controller?.dispose();
//     _controller = null;
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:matchifiy/services/token_storage.dart';
import 'package:http/http.dart' as http;

class VideoService {
  VideoPlayerController? _controller;

  VideoPlayerController? get controller => _controller;

  Future<void> init(String videoUrl) async {
    try {
      final token = await TokenStorage.getToken();
      log("🎬 Downloading video...");
      log("URL: $videoUrl");

      final response = await http.get(
        Uri.parse(videoUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode != 200) {
        log(" Download failed: ${response.statusCode}");
        throw Exception("Download failed");
      }

      final dir = await getTemporaryDirectory();
      final file = File(
        "${dir.path}/clip_${DateTime.now().millisecondsSinceEpoch}.mp4",
      );
      await file.writeAsBytes(response.bodyBytes);

      log(" Video downloaded: ${file.path}");

      _controller = VideoPlayerController.file(file);
      await _controller!.initialize();
      _controller!.play();
    } catch (e, s) {
      log(" VideoService error: $e");
      log("Stack: $s");
      rethrow;
    }
  }

  void dispose() {
    _controller?.dispose();
    _controller = null;
  }
}

// import 'dart:developer';
// import 'package:video_player/video_player.dart';
// import 'package:matchifiy/services/token_storage.dart';

// class VideoService {
//   VideoPlayerController? _controller;

//   VideoPlayerController? get controller => _controller;

//   bool get isInitialized => _controller?.value.isInitialized ?? false;

//   Future<void> init(String videoUrl) async {
//     try {
//       final token = await TokenStorage.getToken();

//       if (token == null || token.isEmpty) {
//         log(" VideoService: Token is NULL or EMPTY");
//       } else {
//         log(" VideoService: Token found");
//       }

//       log(" VideoService: Initializing video");
//       log(" Video URL: $videoUrl");

//       _controller = VideoPlayerController.network(
//         videoUrl,
//         httpHeaders: {"Authorization": "Bearer $token", "Accept": "video/mp4"},
//       );

//       /// الاستماع لأخطاء المشغل نفسه
//       _controller!.addListener(() {
//         final value = _controller!.value;

//         if (value.hasError) {
//           log(" VideoPlayer ERROR:");
//           log("${value.errorDescription}");
//         }
//       });

//       await _controller!.initialize();

//       log(" Video initialized successfully");
//       _controller!.play();
//     } catch (e, stack) {
//       log(" VideoService init FAILED");
//       log("Error: $e");
//       log("StackTrace: $stack");

//       rethrow; // مهم: حتى تعرف الواجهة أن هناك فشل
//     }
//   }

//   void play() {
//     if (_controller == null) {
//       log(" play() called but controller is NULL");
//       return;
//     }
//     _controller!.play();
//   }

//   void pause() {
//     if (_controller == null) {
//       log(" pause() called but controller is NULL");
//       return;
//     }
//     _controller!.pause();
//   }

//   void dispose() {
//     log(" VideoService disposed");
//     _controller?.dispose();
//     _controller = null;
//   }
// }
