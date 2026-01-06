// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:matchifiy/models/Video_Filter.dart';
// import 'package:matchifiy/services/user_service.dart';

// class AnalysisResultScreen extends StatefulWidget {
//   final VideoFilterModel video;

//   const AnalysisResultScreen({super.key, required this.video});

//   @override
//   State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
// }

// class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
//   final UserService _service = UserService();

//   String? extractedText;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadExtractText();
//   }

//   Future<void> _loadExtractText() async {
//     final result = await _service.sendFilter(widget.video);
//     log("Extracted Text: $result");

//     setState(() {
//       extractedText = result;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isArabic = Localizations.localeOf(context).languageCode == 'ar';
//     const Color primaryPurple = Color(0xFF8A2BE2);
//     const Color bgCard = Color(0xFF28283D);

//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E2E),
//       appBar: AppBar(
//         title: Text(isArabic ? "نتائج التحليل" : "Analysis Results"),
//         backgroundColor: const Color(0xFF1E1E2E),
//         centerTitle: true,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : extractedText == null
//               ? Center(
//                 child: Text(
//                   isArabic ? "لا يوجد نتائج" : "No results found",
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               )
//               : SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: bgCard,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: SelectableText(
//                     extractedText!,
//                     textAlign: isArabic ? TextAlign.right : TextAlign.left,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       height: 1.8,
//                     ),
//                   ),
//                 ),
//               ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/user_service.dart';
// import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

// class AnalysisResultScreen extends StatefulWidget {
//   final int jobId;
//   const AnalysisResultScreen({super.key, required this.jobId});

//   @override
//   State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
// }

// class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
//   Timer? _timer;
//   String status = "pending";
//   Map<String, dynamic>? fullResult;
//   List clips = [];

//   @override
//   void initState() {
//     super.initState();
//     _startPolling();
//   }

//   void _startPolling() {
//     _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) async {
//       final data = await UserService().getJobResult(widget.jobId);
//       if (data == null) return;

//       if (mounted) {
//         setState(() {
//           status = data["status"] ?? "pending";
//           if (data["result"] != null) {
//             fullResult = data["result"];
//           }
//           clips = data["clips"] ?? [];
//         });
//       }

//       if (status == "done" || status == "failed") {
//         timer.cancel(); // إلغاء الموقت باستخدام المعامل الممرر
//       }
//     });
//   }
//   // void _startPolling() {
//   // timer = Timer.periodic(const Duration(seconds: 3), () async {
//   // final data = await UserService().getJobResult(widget.jobId);
//   // if (data == null) return;

//   //   if (mounted) {
//   //     setState(() {
//   //       status = data["status"] ?? "pending";
//   //       // استخراج البيانات من حقل result وحقل clips الرئيسي
//   //       if (data["result"] != null) {
//   //         fullResult = data["result"];
//   //       }
//   //       clips = data["clips"] ?? [];
//   //     });
//   //   }

//   //   if (status == "done" || status == "failed") {
//   //     _timer?.cancel();
//   //   }
//   // });

//   // }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomBackgroundScaffold(
//       // return Scaffold(
//       // backgroundColor: const Color(0xFF1E1E2E),
//       appBar: AppBar(
//         title: const Text("نتائج التحليل الذكي"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: status != "done" ? _buildLoadingState() : _buildResultsState(),
//     );
//   }

//   // واجهة حالة الانتظار والمعالجة
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(color: Color(0xFFE0B0FF)),
//           const SizedBox(height: 25),
//           Text(
//             "الحالة الحالية: $status",
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//             child: Text(
//               "نحن نستخدم الذكاء الاصطناعي الآن لاستخراج أهم لحظات المباراة، يرجى عدم إغلاق الصفحة...",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.white70, height: 1.5),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // واجهة عرض النتائج بعد الاكتمال
//   Widget _buildResultsState() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // كارت إحصائيات المعالجة
//           if (fullResult != null) _buildStatsCard(),

//           const SizedBox(height: 30),
//           const Text(
//             "اللقطات المستخرجة",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 15),

//           // قائمة اللقطات
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: clips.length,
//             itemBuilder: (context, index) {
//               return Card(
//                 color: const Color(0xFF28283D),
//                 margin: const EdgeInsets.only(bottom: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 10,
//                   ),
//                   leading: const CircleAvatar(
//                     backgroundColor: Color(0xFF1E1E2E),
//                     child: Icon(Icons.movie_outlined, color: Color(0xFFE0B0FF)),
//                   ),
//                   title: Text(
//                     "لقطة المباراة رقم ${index + 1}",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: const Text(
//                     "تمت المعالجة بنجاح",
//                     style: TextStyle(color: Colors.white54, fontSize: 12),
//                   ),
//                   trailing: const Icon(
//                     Icons.play_circle_fill,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                   onTap: () {
//                     // مسار الفيديو: clips[index]
//                     print("Playing: ${clips[index]}");
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // كارت ملخص البيانات الرقمية
//   Widget _buildStatsCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF28283D),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: const Color(0xFFE0B0FF).withOpacity(0.2)),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStatItem(
//                 "مدة المعالجة",
//                 "${fullResult!['processing_time_sec']}s",
//               ),
//               _buildStatItem(
//                 "عامل الاختصار",
//                 "x${fullResult!['time_reduction_factor']}",
//               ),
//               _buildStatItem(
//                 "عدد اللقطات",
//                 "${fullResult!['video_stats']['num_clips']}",
//               ),
//             ],
//           ),
//           const Divider(color: Colors.white10, height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "إجمالي مدة الفيديو الأصلية:",
//                 style: TextStyle(color: Colors.white70, fontSize: 13),
//               ),
//               Text(
//                 "${fullResult!['total_duration_sec']} ثانية",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             color: Color(0xFFE0B0FF),
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white54, fontSize: 11),
//         ),
//       ],
//     );
//   }
// }
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:matchifiy/services/user_service.dart';
import 'package:matchifiy/services/token_storage.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
import 'package:video_player/video_player.dart';

class AnalysisResultScreen extends StatefulWidget {
  final int jobId;
  const AnalysisResultScreen({super.key, required this.jobId});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  Timer? _timer;
  String status = "pending";
  Map<String, dynamic>? fullResult;
  List<String> clips = [];

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  // void _startPolling() {
  //   _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
  //     final data = await UserService().getJobResult(15.toString());
  //     // final data = await UserService().getJobResult(widget.jobId);
  //     if (data == null || !mounted) return;

  //     setState(() {
  //       status = data["status"] ?? "pending";

  //       if (data["result"] != null && data["result"] is Map) {
  //         fullResult = Map<String, dynamic>.from(data["result"]);
  //         log(fullResult.toString());
  //         //  استخراج clips بشكل آمن
  //         final rawClips = fullResult!["clips"];
  //         if (rawClips is List) {
  //           clips =
  //               rawClips
  //                   .where((e) => e != null)
  //                   .map((e) => e.toString())
  //                   .toList();
  //         }
  //       }
  //     });

  //     if (status == "done" || status == "failed") {
  //       timer.cancel();
  //     }
  //   });
  // }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted) return;

      final data = await UserService().getJobResult(widget.jobId.toString());
      if (data == null) return;

      final newStatus = data["status"] ?? "queued";

      setState(() {
        status = newStatus;

        if (data["result"] != null && data["result"] is Map) {
          fullResult = Map<String, dynamic>.from(data["result"]);

          final rawClips = fullResult!["clips"];
          if (rawClips is List) {
            clips =
                rawClips
                    .where((e) => e != null)
                    .map((e) => e.toString())
                    .toList();
          }
        }
      });

      //  الشرط المهم
      if (newStatus != "queued") {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 🔗 بناء رابط الفيديو الكامل
  // String _buildVideoUrl(String path) {
  //   final baseUrl = TokenStorage.getIp();
  //   return "$baseUrl/$path";
  // }

  String _buildVideoUrl(String path) {
    final baseUrl = TokenStorage.getIp();

    //  توحيد المسار (Windows ➜ URL)
    final normalizedPath = path.replaceAll('\\', '/');

    //  بناء URL صالح
    final fullUrl = "$baseUrl/$normalizedPath";

    //  تشفير الرابط لمنع crash
    return Uri.encodeFull(fullUrl);
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundScaffold(
      appBar: AppBar(
        title: const Text("نتائج التحليل الذكي"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: status != "done" ? _buildLoadingState() : _buildResultsState(),
    );
  }

  // ================= LOADING =================
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color.fromARGB(255, 114, 116, 228),
          ),
          // const CircularProgressIndicator(color: Color(0xFFE0B0FF)),
          const SizedBox(height: 25),
          Text(
            "الحالة الحالية: $status",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Text(
              "نحن نستخدم الذكاء الاصطناعي لاستخراج أهم لحظات المباراة، يرجى عدم إغلاق الصفحة...",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ================= RESULTS =================
  Widget _buildResultsState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (fullResult != null) _buildStatsCard(),
          const SizedBox(height: 30),
          const Text(
            "اللقطات المستخرجة",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: clips.length,
          //   itemBuilder: (context, index) {
          //     return Card(
          //       color: const Color(0xFF28283D),
          //       margin: const EdgeInsets.only(bottom: 12),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //       child: ListTile(
          //         contentPadding: const EdgeInsets.symmetric(
          //           horizontal: 20,
          //           vertical: 10,
          //         ),
          //         leading: const CircleAvatar(
          //           backgroundColor: Color(0xFF1E1E2E),
          //           child: Icon(Icons.movie_outlined, color: Color(0xFFE0B0FF)),
          //         ),
          //         title: Text(
          //           "لقطة المباراة رقم ${index + 1}",
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         subtitle: const Text(
          //           "تمت المعالجة بنجاح",
          //           style: TextStyle(color: Colors.white54, fontSize: 12),
          //         ),
          //         trailing: const Icon(
          //           Icons.play_circle_fill,
          //           color: Colors.white,
          //           size: 30,
          //         ),
          //         // onTap: () {
          //         //   final videoUrl = _buildVideoUrl(clips[index]);
          //         //   Navigator.push(
          //         //     context,
          //         //     MaterialPageRoute(
          //         //       builder: (_) => VideoPlayerScreen(videoUrl: videoUrl),
          //         //     ),
          //         //   );
          //         // },
          //         onTap: () {
          //           try {
          //             final videoUrl = _buildVideoUrl(clips[index]);
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (_) => VideoPlayerScreen(videoUrl: videoUrl),
          //               ),
          //             );
          //           } catch (e) {
          //             debugPrint("Video open error: $e");
          //           }
          //         },
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  // ================= STATS =================
  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF28283D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0B0FF).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     _buildStatItem(
          //       "مدة المعالجة",
          //       "${fullResult!['processing_time_sec']}s",
          //     ),
          //     _buildStatItem(
          //       "عامل الاختصار",
          //       "x${fullResult!['time_reduction_factor']}",
          //     ),
          //     _buildStatItem(
          //       "عدد اللقطات",
          //       "${fullResult!['video_stats']['num_clips']}",
          //     ),
          //   ],
          // ),
          // const Divider(color: Colors.white10, height: 30),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text(
          //       "إجمالي مدة الفيديو الأصلية:",
          //       style: TextStyle(color: Colors.white70, fontSize: 13),
          //     ),
          //     Text(
          //       "${fullResult!['total_duration_sec']} ثانية",
          //       style: const TextStyle(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFE0B0FF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }
}

// ================= VIDEO PLAYER =================
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("تشغيل اللقطة")),
      body: Center(
        child:
            _controller.value.isInitialized
                ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                : const CircularProgressIndicator(),
      ),
    );
  }
}
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/user_service.dart';
// import 'package:matchifiy/services/token_storage.dart';
// import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
// import 'package:video_player/video_player.dart';

// class AnalysisResultScreen extends StatefulWidget {
//   final int jobId;
//   const AnalysisResultScreen({super.key, required this.jobId});

//   @override
//   State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
// }

// class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
//   Timer? _timer;
//   String status = "pending";
//   Map<String, dynamic>? fullResult;
//   List<String> clips = [];

//   @override
//   void initState() {
//     super.initState();
//     _startPolling();
//   }

//   void _startPolling() {
//     _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
//       final data = await UserService().getJobResult(15.toString());
//       // final data = await UserService().getJobResult(widget.jobId);
//       if (data == null || !mounted) return;

//       setState(() {
//         status = data["status"] ?? "pending";

//         if (data["result"] != null && data["result"] is Map) {
//           fullResult = Map<String, dynamic>.from(data["result"]);

//           //  استخراج clips بشكل آمن
//           final rawClips = fullResult!["clips"];
//           if (rawClips is List) {
//             clips =
//                 rawClips
//                     .where((e) => e != null)
//                     .map((e) => e.toString())
//                     .toList();
//           }
//         }
//       });

//       if (status == "done" || status == "failed") {
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   // 🔗 بناء رابط الفيديو الكامل
//   // String _buildVideoUrl(String path) {
//   //   final baseUrl = TokenStorage.getIp();
//   //   return "$baseUrl/$path";
//   // }

//   String _buildVideoUrl(String path) {
//     final baseUrl = TokenStorage.getIp();

//     //  توحيد المسار (Windows ➜ URL)
//     final normalizedPath = path.replaceAll('\\', '/');

//     //  بناء URL صالح
//     final fullUrl = "$baseUrl/$normalizedPath";

//     //  تشفير الرابط لمنع crash
//     return Uri.encodeFull(fullUrl);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomBackgroundScaffold(
//       appBar: AppBar(
//         title: const Text("نتائج التحليل الذكي"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: status != "done" ? _buildLoadingState() : _buildResultsState(),
//     );
//   }

//   // ================= LOADING =================
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(
//             color: Color.fromARGB(255, 114, 116, 228),
//           ),
//           // const CircularProgressIndicator(color: Color(0xFFE0B0FF)),
//           const SizedBox(height: 25),
//           Text(
//             "الحالة الحالية: $status",
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//             child: Text(
//               "نحن نستخدم الذكاء الاصطناعي لاستخراج أهم لحظات المباراة، يرجى عدم إغلاق الصفحة...",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.white70, height: 1.5),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ================= RESULTS =================
//   Widget _buildResultsState() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (fullResult != null) _buildStatsCard(),
//           const SizedBox(height: 30),
//           const Text(
//             "اللقطات المستخرجة",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 15),

//           // ListView.builder(
//           //   shrinkWrap: true,
//           //   physics: const NeverScrollableScrollPhysics(),
//           //   itemCount: clips.length,
//           //   itemBuilder: (context, index) {
//           //     return Card(
//           //       color: const Color(0xFF28283D),
//           //       margin: const EdgeInsets.only(bottom: 12),
//           //       shape: RoundedRectangleBorder(
//           //         borderRadius: BorderRadius.circular(15),
//           //       ),
//           //       child: ListTile(
//           //         contentPadding: const EdgeInsets.symmetric(
//           //           horizontal: 20,
//           //           vertical: 10,
//           //         ),
//           //         leading: const CircleAvatar(
//           //           backgroundColor: Color(0xFF1E1E2E),
//           //           child: Icon(Icons.movie_outlined, color: Color(0xFFE0B0FF)),
//           //         ),
//           //         title: Text(
//           //           "لقطة المباراة رقم ${index + 1}",
//           //           style: const TextStyle(
//           //             color: Colors.white,
//           //             fontWeight: FontWeight.bold,
//           //           ),
//           //         ),
//           //         subtitle: const Text(
//           //           "تمت المعالجة بنجاح",
//           //           style: TextStyle(color: Colors.white54, fontSize: 12),
//           //         ),
//           //         trailing: const Icon(
//           //           Icons.play_circle_fill,
//           //           color: Colors.white,
//           //           size: 30,
//           //         ),
//           //         // onTap: () {
//           //         //   final videoUrl = _buildVideoUrl(clips[index]);
//           //         //   Navigator.push(
//           //         //     context,
//           //         //     MaterialPageRoute(
//           //         //       builder: (_) => VideoPlayerScreen(videoUrl: videoUrl),
//           //         //     ),
//           //         //   );
//           //         // },
//           //         onTap: () {
//           //           try {
//           //             final videoUrl = _buildVideoUrl(clips[index]);
//           //             Navigator.push(
//           //               context,
//           //               MaterialPageRoute(
//           //                 builder: (_) => VideoPlayerScreen(videoUrl: videoUrl),
//           //               ),
//           //             );
//           //           } catch (e) {
//           //             debugPrint("Video open error: $e");
//           //           }
//           //         },
//           //       ),
//           //     );
//           //   },
//           // ),
//         ],
//       ),
//     );
//   }

//   // ================= STATS =================
//   Widget _buildStatsCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF28283D),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: const Color(0xFFE0B0FF).withOpacity(0.2)),
//       ),
//       child: Column(
//         children: [
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//           //   children: [
//           //     _buildStatItem(
//           //       "مدة المعالجة",
//           //       "${fullResult!['processing_time_sec']}s",
//           //     ),
//           //     _buildStatItem(
//           //       "عامل الاختصار",
//           //       "x${fullResult!['time_reduction_factor']}",
//           //     ),
//           //     _buildStatItem(
//           //       "عدد اللقطات",
//           //       "${fullResult!['video_stats']['num_clips']}",
//           //     ),
//           //   ],
//           // ),
//           // const Divider(color: Colors.white10, height: 30),
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     const Text(
//           //       "إجمالي مدة الفيديو الأصلية:",
//           //       style: TextStyle(color: Colors.white70, fontSize: 13),
//           //     ),
//           //     Text(
//           //       "${fullResult!['total_duration_sec']} ثانية",
//           //       style: const TextStyle(
//           //         color: Colors.white,
//           //         fontWeight: FontWeight.bold,
//           //       ),
//           //     ),
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             color: Color(0xFFE0B0FF),
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white54, fontSize: 11),
//         ),
//       ],
//     );
//   }
// }

// // ================= VIDEO PLAYER =================
// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerScreen({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(title: const Text("تشغيل اللقطة")),
//       body: Center(
//         child:
//             _controller.value.isInitialized
//                 ? AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 )
//                 : const CircularProgressIndicator(),
//       ),
//     );
//   }
// }

//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/user_service.dart';

// class AnalysisResultScreen extends StatefulWidget {
//   final int jobId;
//   const AnalysisResultScreen({super.key, required this.jobId});

//   @override
//   State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
// }

// class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
//   Timer? _timer;
//   String status = "pending"; // pending, processing, done, failed
//   List clips = [];

//   @override
//   void initState() {
//     super.initState();
//     _startPolling();
//   }

//   void _startPolling() {
//     // فحص النتيجة كل 3 ثوانٍ
//     _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
//       final data = await UserService().getJobResult(widget.jobId);
//       if (data == null) return;

//       if (mounted) {
//         setState(() {
//           status = data["status"] ?? "pending";
//           clips = data["clips"] ?? [];
//         });
//       }

//       if (status == "done" || status == "failed") {
//         _timer?.cancel();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E2E),
//       appBar: AppBar(
//         title: const Text("نتيجة التحليل"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Center(
//         child:
//             status != "done"
//                 ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const CircularProgressIndicator(color: Color(0xFFE0B0FF)),
//                     const SizedBox(height: 20),
//                     Text(
//                       "حالة المعالجة: $status",
//                       style: const TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.all(20.0),
//                       child: Text(
//                         "يتم الآن تحليل الفيديو بالذكاء الاصطناعي، يرجى الانتظار...",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                     ),
//                   ],
//                 )
//                 : ListView.builder(
//                   itemCount: clips.length,
//                   padding: const EdgeInsets.all(15),
//                   itemBuilder:
//                       (_, i) => Card(
//                         color: const Color(0xFF28283D),
//                         margin: const EdgeInsets.only(bottom: 10),
//                         child: ListTile(
//                           leading: const Icon(
//                             Icons.slow_motion_video,
//                             color: Color(0xFFE0B0FF),
//                           ),
//                           title: Text(
//                             "لقطة المباراة رقم ${i + 1}",
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           subtitle: Text(
//                             "تم استخراجها بنجاح",
//                             style: const TextStyle(color: Colors.white70),
//                           ),
//                           trailing: const Icon(
//                             Icons.play_circle_fill,
//                             color: Colors.white,
//                           ),
//                           onTap: () {
//                             // منطق تشغيل الرابط المرتجع من السيرفر للكلب
//                           },
//                         ),
//                       ),
//                 ),
//       ),
//     );
//   }
// }
