// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/token_storage.dart';
// import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:video_player/video_player.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:dio/dio.dart';

// class VideoResultScreen extends StatefulWidget {
//   final String videoUrl; // رابط الفيديو من السيرفر

//   const VideoResultScreen({super.key, required this.videoUrl});

//   @override
//   State<VideoResultScreen> createState() => _VideoResultScreenState();
// }

// class _VideoResultScreenState extends State<VideoResultScreen> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   bool _isDownloading = false;
//   double _downloadProgress = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await TokenStorage.clearLastVideoResult();
//     });
//     // requestStoragePermission();

//     // تشغيل الفيديو من الرابط
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() => _isInitialized = true);
//         _controller.play();
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _downloadVideoToDownloads() async {
//     try {
//       // Android 13+
//       if (Platform.isAndroid) {
//         final videoPermission = await Permission.videos.request();
//         if (!videoPermission.isGranted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('صلاحية الوصول للفيديو مطلوبة')),
//           );
//           return;
//         }
//       }

//       setState(() {
//         _isDownloading = true;
//         _downloadProgress = 0.0;
//       });

//       // مجلد Downloads الحقيقي
//       final downloadsDir = Directory('/storage/emulated/0/Download');
//       if (!downloadsDir.existsSync()) {
//         downloadsDir.createSync(recursive: true);
//       }

//       final filePath =
//           '${downloadsDir.path}/highlight_${DateTime.now().millisecondsSinceEpoch}.mp4';

//       await Dio().download(
//         widget.videoUrl,
//         filePath,
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             setState(() {
//               _downloadProgress = received / total;
//             });
//           }
//         },
//       );

//       setState(() => _isDownloading = false);

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('تم حفظ الفيديو في Downloads')));
//     } catch (e) {
//       setState(() => _isDownloading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('فشل التحميل: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomBackgroundScaffold(
//       appBar: AppBar(
//         title: const Text("نتيجة الفيديو"),
//         backgroundColor: Colors.transparent,
//       ),
//       body: Center(
//         child:
//             _isInitialized
//                 ? AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 )
//                 : const CircularProgressIndicator(),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           if (_isInitialized)
//             FloatingActionButton(
//               heroTag: "play_pause",
//               onPressed: () {
//                 setState(() {
//                   _controller.value.isPlaying
//                       ? _controller.pause()
//                       : _controller.play();
//                 });
//               },
//               child: Icon(
//                 _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//               ),
//             ),
//           const SizedBox(height: 15),
//           // FloatingActionButton(
//           //   heroTag: "download",
//           //   onPressed: _isDownloading ? null : _downloadVideoToDownloads,
//           //   backgroundColor: Colors.green,
//           //   child:
//           //       _isDownloading
//           //           ? CircularProgressIndicator(
//           //             value: _downloadProgress,
//           //             color: Colors.white,
//           //           )
//           //           : const Icon(Icons.download),
//           // ),
//           FloatingActionButton(
//             heroTag: "download",
//             onPressed: _isDownloading ? null : _downloadVideoToDownloads,
//             // onPressed: _isDownloading ? null : _downloadVideoToDownloads,
//             backgroundColor: Colors.green,
//             child:
//                 _isDownloading
//                     ? SizedBox(
//                       width: 24,
//                       height: 24,
//                       child: CircularProgressIndicator(
//                         value: _downloadProgress,
//                         color: Colors.white,
//                         strokeWidth: 2.5,
//                       ),
//                     )
//                     : const Icon(Icons.download),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:matchifiy/services/token_storage.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';

class VideoResultScreen extends StatefulWidget {
  final String videoUrl; // رابط الفيديو من السيرفر

  const VideoResultScreen({super.key, required this.videoUrl});

  @override
  State<VideoResultScreen> createState() => _VideoResultScreenState();
}

class _VideoResultScreenState extends State<VideoResultScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await TokenStorage.clearLastVideoResult();
    });

    // تشغيل الفيديو من الرابط
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() => _isInitialized = true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _downloadVideoToDownloads() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    try {
      // Android 13+
      if (Platform.isAndroid) {
        final videoPermission = await Permission.videos.request();
        if (!videoPermission.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isArabic
                    ? 'صلاحية الوصول للفيديو مطلوبة'
                    : 'Video permission is required',
              ),
            ),
          );
          return;
        }
      }

      setState(() {
        _isDownloading = true;
        _downloadProgress = 0.0;
      });

      // مجلد Downloads الحقيقي
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      final filePath =
          '${downloadsDir.path}/highlight_${DateTime.now().millisecondsSinceEpoch}.mp4';

      await Dio().download(
        widget.videoUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      setState(() => _isDownloading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'تم حفظ الفيديو في Downloads'
                : 'Video saved in Downloads',
          ),
        ),
      );
    } catch (e) {
      setState(() => _isDownloading = false);
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic ? 'فشل التحميل: $e' : 'Download failed: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return CustomBackgroundScaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? "نتيجة الفيديو" : "Video Result",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child:
            _isInitialized
                ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                : const CircularProgressIndicator(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isInitialized)
            FloatingActionButton(
              heroTag: "play_pause",
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          const SizedBox(height: 15),
          FloatingActionButton(
            heroTag: "download",
            onPressed: _isDownloading ? null : _downloadVideoToDownloads,
            backgroundColor: Colors.green,
            child:
                _isDownloading
                    ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: _downloadProgress,
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                    : const Icon(Icons.download),
          ),
        ],
      ),
    );
  }
}
