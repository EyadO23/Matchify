// // // // import 'package:flutter/material.dart';
// // // // import 'package:matchifiy/models/matchify_model.dart';
// // // // import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

// // // // class VideoResultsScreen extends StatelessWidget {
// // // //   final MatchifyResult result;

// // // //   const VideoResultsScreen({super.key, required this.result});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return CustomBackgroundScaffold(
// // // //       appBar: AppBar(
// // // //         title: const Text("نتائج تحليل الفيديو"),
// // // //         backgroundColor: Colors.transparent,
// // // //         elevation: 0,
// // // //       ),
// // // //       body: Padding(
// // // //         padding: const EdgeInsets.all(16.0),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             // بطاقة ملخص الحالة
// // // //             _buildStatusCard(),
// // // //             const SizedBox(height: 20),
// // // //             const Text(
// // // //               "اللقطات البارزة المستخرجة:",
// // // //               style: TextStyle(
// // // //                 color: Colors.white,
// // // //                 fontSize: 18,
// // // //                 fontWeight: FontWeight.bold,
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 10),
// // // //             // قائمة الكليبات الناتجة
// // // //             Expanded(
// // // //               child: ListView.builder(
// // // //                 itemCount: result.highlights.length,
// // // //                 itemBuilder: (context, index) {
// // // //                   final item = result.highlights[index];
// // // //                   return _buildHighlightTile(item, context);
// // // //                 },
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildStatusCard() {
// // // //     return Container(
// // // //       padding: const EdgeInsets.all(16),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white.withOpacity(0.1),
// // // //         borderRadius: BorderRadius.circular(15),
// // // //         border: Border.all(color: Colors.white24),
// // // //       ),
// // // //       child: Row(
// // // //         children: [
// // // //           const Icon(Icons.check_circle, color: Colors.greenAccent, size: 40),
// // // //           const SizedBox(width: 15),
// // // //           Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               const Text(
// // // //                 "الحالة: اكتمل التحليل",
// // // //                 style: TextStyle(
// // // //                   color: Colors.white,
// // // //                   fontWeight: FontWeight.bold,
// // // //                 ),
// // // //               ),
// // // //               Text(
// // // //                 "تم استخراج ${result.highlights.length} لقطات",
// // // //                 style: const TextStyle(color: Colors.white70),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildHighlightTile(Highlight highlight, BuildContext context) {
// // // //     return Card(
// // // //       color: Colors.white.withOpacity(0.05),
// // // //       margin: const EdgeInsets.only(bottom: 12),
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // //       child: ListTile(
// // // //         leading: const Icon(Icons.movie_filter, color: Color(0xFF7274E4)),
// // // //         title: Text(
// // // //           highlight.clipName,
// // // //           style: const TextStyle(color: Colors.white),
// // // //         ),
// // // //         subtitle: Text(
// // // //           "عدد الأجزاء: ${highlight.segments.length}",
// // // //           style: const TextStyle(color: Colors.white60),
// // // //         ),
// // // //         trailing: const Icon(
// // // //           Icons.play_circle_fill,
// // // //           color: Colors.white,
// // // //           size: 30,
// // // //         ),
// // // //         onTap: () {
// // // //           // هنا يتم فتح مشغل الفيديو
// // // //           ScaffoldMessenger.of(context).showSnackBar(
// // // //             SnackBar(content: Text("جاري تشغيل: ${highlight.clipName}")),
// // // //           );
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:matchifiy/models/matchify_model.dart';
// // // import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
// // // import 'package:matchifiy/widgets/simple_video_player.dart';
// // // import 'package:video_player/video_player.dart';

// // // class VideoResultsScreen extends StatelessWidget {
// // //   final MatchifyResult? result;

// // //   const VideoResultsScreen({super.key, this.result, required clipsDir});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return CustomBackgroundScaffold(
// // //       appBar: AppBar(
// // //         title: const Text(
// // //           "نتائج تحليل Matchify",
// // //           style: TextStyle(fontWeight: FontWeight.bold),
// // //         ),
// // //         backgroundColor: Colors.transparent,
// // //         elevation: 0,
// // //         centerTitle: true,
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             // بطاقة ملخص الحالة والإحصائيات
// // //             _buildStatusCard(),

// // //             const SizedBox(height: 25),

// // //             const Row(
// // //               children: [
// // //                 Icon(Icons.auto_awesome, color: Color(0xFF7274E4), size: 20),
// // //                 SizedBox(width: 8),
// // //                 Text(
// // //                   "اللقطات الذكية المكتشفة",
// // //                   style: TextStyle(
// // //                     color: Colors.white,
// // //                     fontSize: 18,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 15),

// // //             // قائمة المقاطع الناتجة
// // //             Expanded(
// // //               child:
// // //                   result!.highlights.isEmpty
// // //                       ? _buildEmptyState()
// // //                       : ListView.builder(
// // //                         itemCount: result!.highlights.length,
// // //                         physics: const BouncingScrollPhysics(),
// // //                         itemBuilder: (context, index) {
// // //                           final item = result!.highlights[index];
// // //                           return _buildHighlightTile(item, context, index + 1);
// // //                         },
// // //                       ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildStatusCard() {
// // //     return Container(
// // //       padding: const EdgeInsets.all(20),
// // //       decoration: BoxDecoration(
// // //         gradient: LinearGradient(
// // //           colors: [
// // //             const Color(0xFF7274E4).withOpacity(0.3),
// // //             Colors.white.withOpacity(0.05),
// // //           ],
// // //           begin: Alignment.topLeft,
// // //           end: Alignment.bottomRight,
// // //         ),
// // //         borderRadius: BorderRadius.circular(24),
// // //         border: Border.all(color: Colors.white10),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Container(
// // //             padding: const EdgeInsets.all(12),
// // //             decoration: const BoxDecoration(
// // //               color: Colors.greenAccent,
// // //               shape: BoxShape.circle,
// // //             ),
// // //             child: const Icon(Icons.check, color: Color(0xFF1E1E2E), size: 28),
// // //           ),
// // //           const SizedBox(width: 20),
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 const Text(
// // //                   "اكتملت المعالجة بنجاح",
// // //                   style: TextStyle(
// // //                     color: Colors.white,
// // //                     fontSize: 16,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 4),
// // //                 Text(
// // //                   "تم تحليل الفيديو واستخراج ${result!.highlights.length} لقطات بارزة",
// // //                   style: const TextStyle(color: Colors.white60, fontSize: 13),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildHighlightTile(
// // //     HighlightClip highlight,
// // //     BuildContext context,
// // //     int index,
// // //   ) {
// // //     return Container(
// // //       margin: const EdgeInsets.only(bottom: 15),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white.withOpacity(0.05),
// // //         borderRadius: BorderRadius.circular(18),
// // //         border: Border.all(color: Colors.white.withOpacity(0.1)),
// // //       ),
// // //       child: ListTile(
// // //         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// // //         leading: CircleAvatar(
// // //           backgroundColor: const Color(0xFF7274E4).withOpacity(0.2),
// // //           child: Text(
// // //             "$index",
// // //             style: const TextStyle(
// // //               color: Color(0xFF7274E4),
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //         ),
// // //         title: Text(
// // //           "كليب: ${highlight.clip}",
// // //           style: const TextStyle(
// // //             color: Colors.white,
// // //             fontWeight: FontWeight.w600,
// // //           ),
// // //         ),
// // //         subtitle: Text(
// // //           "يحتوي على ${highlight.segments.length} أجزاء مؤكدة",
// // //           style: const TextStyle(color: Colors.white38, fontSize: 12),
// // //         ),
// // //         trailing: Container(
// // //           decoration: const BoxDecoration(
// // //             color: Color(0xFF7274E4),
// // //             shape: BoxShape.circle,
// // //           ),
// // //           child: const Icon(
// // //             Icons.play_arrow_rounded,
// // //             color: Colors.white,
// // //             size: 30,
// // //           ),
// // //         ),
// // //         onTap: () => _playVideo(context, highlight.highlightVideo),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildEmptyState() {
// // //     return Center(
// // //       child: Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           Icon(Icons.abc, size: 60, color: Colors.white24),
// // //           const SizedBox(height: 10),
// // //           const Text(
// // //             "لم يتم العثور على لقطات تطابق الفلتر",
// // //             style: TextStyle(color: Colors.white38),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   void _playVideo(BuildContext context, String url) {
// // //     // نقوم بفتح مشغل فيديو بسيط في شاشة جديدة أو Modal
// // //     showModalBottomSheet(
// // //       context: context,
// // //       isScrollControlled: true,
// // //       backgroundColor: Colors.black,
// // //       builder: (context) => SimpleVideoPlayer(videoUrl: url),
// // //     );
// // //   }
// // // }
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';

// // class VideoResultScreen extends StatefulWidget {
// //   final String videoPath;

// //   const VideoResultScreen({super.key, required this.videoPath});

// //   @override
// //   State<VideoResultScreen> createState() => _VideoResultScreenState();
// // }

// // class _VideoResultScreenState extends State<VideoResultScreen> {
// //   late VideoPlayerController _controller;
// //   bool _isInitialized = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = VideoPlayerController.file(File(widget.videoPath))
// //       ..initialize().then((_) {
// //         setState(() {
// //           _isInitialized = true;
// //         });
// //         _controller.play();
// //       });
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Video Result")),
// //       body: Center(
// //         child:
// //             _isInitialized
// //                 ? AspectRatio(
// //                   aspectRatio: _controller.value.aspectRatio,
// //                   child: VideoPlayer(_controller),
// //                 )
// //                 : const CircularProgressIndicator(),
// //       ),
// //       floatingActionButton:
// //           _isInitialized
// //               ? FloatingActionButton(
// //                 onPressed: () {
// //                   setState(() {
// //                     _controller.value.isPlaying
// //                         ? _controller.pause()
// //                         : _controller.play();
// //                   });
// //                 },
// //                 child: Icon(
// //                   _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
// //                 ),
// //               )
// //               : null,
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:path_provider/path_provider.dart';

// class VideoResultScreen extends StatefulWidget {
//   final String videoPath;

//   const VideoResultScreen({super.key, required this.videoPath});

//   @override
//   State<VideoResultScreen> createState() => _VideoResultScreenState();
// }

// class _VideoResultScreenState extends State<VideoResultScreen> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(File(widget.videoPath))
//       ..initialize().then((_) {
//         setState(() {
//           _isInitialized = true;
//         });
//         _controller.play();
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _downloadVideo() async {
//     try {
//       Directory? directory;

//       // نحدد مجلد التنزيلات حسب نظام التشغيل
//       if (Platform.isAndroid) {
//         directory = Directory('/storage/emulated/0/Download');
//       } else {
//         directory = await getApplicationDocumentsDirectory();
//       }

//       if (!directory.existsSync()) {
//         directory.createSync(recursive: true);
//       }

//       final fileName = widget.videoPath.split('/').last;
//       final newFile = File('${directory.path}/$fileName');

//       await File(widget.videoPath).copy(newFile.path);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("تم حفظ الفيديو في ${newFile.path}")),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("فشل حفظ الفيديو: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E2E),
//       appBar: AppBar(
//         title: const Text(
//           "نتيجة الفيديو",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Center(
//         child:
//             _isInitialized
//                 ? AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 )
//                 : const CircularProgressIndicator(color: Colors.white),
//       ),
//       floatingActionButton:
//           _isInitialized
//               ? Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   FloatingActionButton(
//                     heroTag: "play_pause",
//                     onPressed: () {
//                       setState(() {
//                         _controller.value.isPlaying
//                             ? _controller.pause()
//                             : _controller.play();
//                       });
//                     },
//                     backgroundColor: const Color(0xFF7274E4),
//                     child: Icon(
//                       _controller.value.isPlaying
//                           ? Icons.pause
//                           : Icons.play_arrow,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   FloatingActionButton(
//                     heroTag: "download",
//                     onPressed: _downloadVideo,
//                     backgroundColor: const Color(0xFF7274E4),
//                     child: const Icon(Icons.download),
//                   ),
//                 ],
//               )
//               : null,
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
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
    // requestStoragePermission();

    // تشغيل الفيديو من الرابط
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() => _isInitialized = true);
        _controller.play();
      });
  }

  // Future<void> requestStoragePermission() async {
  //   if (await Permission.storage.request().isGranted) {
  //     print("Storage permission granted");
  //   } else {
  //     print("Storage permission denied");
  //   }
  // }
  // Future<void> requestStoragePermission() async {
  //   if (await Permission.storage.request().isGranted) {
  //     print("Storage permission granted");
  //   } else {
  //     print("Storage permission denied");
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Future<void> _downloadVideo() async {
  //   try {
  //     if (!await Permission.storage.request().isGranted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text('صلاحية التخزين مطلوبة')));
  //       return;
  //     }

  //     setState(() {
  //       _isDownloading = true;
  //       _downloadProgress = 0.0;
  //     });

  //     // مجلد التنزيلات
  //     Directory? downloadsDir = await getExternalStorageDirectory();
  //     final filePath = '${downloadsDir!.path}/highlight.mp4';

  //     // تحميل الفيديو
  //     await Dio().download(
  //       widget.videoUrl,
  //       filePath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           setState(() {
  //             _downloadProgress = received / total;
  //           });
  //         }
  //       },
  //     );

  //     setState(() {
  //       _isDownloading = false;
  //     });

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('تم تحميل الفيديو في: $filePath')));
  //   } catch (e) {
  //     setState(() {
  //       _isDownloading = false;
  //     });
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('فشل التحميل: $e')));
  //   }
  // }
  Future<void> _downloadVideoToDownloads() async {
    try {
      // 1️⃣ طلب صلاحية التخزين
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('صلاحية التخزين مطلوبة')));
        return;
      }

      setState(() {
        _isDownloading = true;
        _downloadProgress = 0.0;
      });

      // 2️⃣ الحصول على مجلد التنزيلات على أندرويد
      Directory downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      final filePath = '${downloadsDir.path}/highlight.mp4';

      // 3️⃣ تحميل الفيديو باستخدام Dio مع تحديث progress
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

      setState(() {
        _isDownloading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم حفظ الفيديو في: $filePath')));
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل التحميل: $e')));
    }
  }

  // Future<void> _downloadVideo() async {
  //   try {
  //     setState(() {
  //       _isDownloading = true;
  //       _downloadProgress = 0.0;
  //     });

  //     // مجلد التنزيلات على الجهاز
  //     final dir = await getApplicationDocumentsDirectory();
  //     final filePath = '${dir.path}/highlight.mp4';

  //     // تحميل الفيديو
  //     await Dio().download(
  //       widget.videoUrl,
  //       filePath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           setState(() {
  //             _downloadProgress = received / total;
  //           });
  //         }
  //       },
  //     );

  //     setState(() {
  //       _isDownloading = false;
  //     });

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('تم تحميل الفيديو في: $filePath')));
  //   } catch (e) {
  //     setState(() {
  //       _isDownloading = false;
  //     });
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('فشل التحميل: $e')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundScaffold(
      appBar: AppBar(
        title: const Text("نتيجة الفيديو"),
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
          // FloatingActionButton(
          //   heroTag: "download",
          //   onPressed: _isDownloading ? null : _downloadVideoToDownloads,
          //   backgroundColor: Colors.green,
          //   child:
          //       _isDownloading
          //           ? CircularProgressIndicator(
          //             value: _downloadProgress,
          //             color: Colors.white,
          //           )
          //           : const Icon(Icons.download),
          // ),
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
