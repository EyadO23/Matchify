///////////////////////////////okkkkkkk
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
import 'package:matchifiy/widgets/home_screen.dart';
import 'package:matchifiy/widgets/video_result_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:matchifiy/services/user_service.dart';
import 'package:matchifiy/utils/url_helper.dart'; // تأكد من المسار الصحيح لديك

enum FilterType { goalsOnly, redCard, yellowCard }

enum SummaryLength { long, short }

class MatchAnalysisScreen extends StatefulWidget {
  const MatchAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<MatchAnalysisScreen> createState() => _MatchAnalysisScreenState();
}

class _MatchAnalysisScreenState extends State<MatchAnalysisScreen> {
  Trimmer? _trimmer;
  File? _finalVideoFile;
  VideoPlayerController? _videoController;

  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _isTrimming = false;
  bool _isLoading = false;
  double _uploadProgress = 0.0;

  final UserService _userService = UserService();

  // 2. تعريف متغير نسبة التحميل
  double progress = 0.0;

  FilterType _selectedFilter = FilterType.goalsOnly;
  SummaryLength _summaryLength = SummaryLength.long;

  @override
  void dispose() {
    _disposeVideoResources();
    super.dispose();
  }

  Future<void> _disposeVideoResources() async {
    try {
      if (_videoController != null) {
        await _videoController!.pause();
        await _videoController!.dispose();
        _videoController = null;
      }
    } catch (e) {
      log("Dispose error: $e");
    }
  }

  // String filterToArabic(FilterType type) {
  //   switch (type) {
  //     case FilterType.goalsOnly:
  //       return "أهداف المباراة";
  //     case FilterType.redCard:
  //       return "بطاقات حمراء";
  //     case FilterType.yellowCard:
  //       return "بطاقات صفراء";
  //   }
  // }
  String filterToArabic(FilterType type) {
    switch (type) {
      case FilterType.goalsOnly:
        return "اهداف";
      case FilterType.redCard:
        return "بطاقة حمراء";
      case FilterType.yellowCard:
        return "بطاقة صفراء";
    }
  }

  Future<void> _pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowCompression: false,
      );

      if (result?.files.single.path == null) return;

      final file = File(result!.files.single.path!);
      await _disposeVideoResources();

      _trimmer = Trimmer();
      await _trimmer!.loadVideo(videoFile: file);

      final duration =
          _trimmer!.videoPlayerController!.value.duration.inMilliseconds;
      _startValue = 0.0;
      _endValue = duration.toDouble();

      if (mounted) _showTrimmer();
    } catch (e) {
      log("Pick video error: $e");
    }
  }

  void _showTrimmer() {
    if (_trimmer == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor: const Color.fromARGB(255, 114, 116, 228),
      backgroundColor: const Color(0xFF1E1E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "قص المقطع المطلوب",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.black,
                        child: VideoViewer(trimmer: _trimmer!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TrimViewer(
                    trimmer: _trimmer!,
                    viewerHeight: 50,
                    viewerWidth: MediaQuery.of(context).size.width,
                    durationStyle: DurationStyle.FORMAT_MM_SS,
                    onChangeStart: (v) => _startValue = v,
                    onChangeEnd: (v) => _endValue = v,
                    onChangePlaybackState:
                        (v) => setModalState(() => _isPlaying = v),
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    iconSize: 70,
                    color: const Color.fromARGB(255, 114, 116, 228),
                    // color: const Color(0xFFE0B0FF),
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                    ),
                    onPressed: () async {
                      final p = await _trimmer!.videoPlaybackControl(
                        startValue: _startValue,
                        endValue: _endValue,
                      );
                      setModalState(() => _isPlaying = p);
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed:
                          _isTrimming
                              ? null
                              : () => _saveTrimmedVideo(
                                modalContext,
                                setModalState,
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          114,
                          116,
                          228,
                        ),
                        // backgroundColor: const Color(0xFF8A2BE2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child:
                          _isTrimming
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "تأكيد المقطع المختار",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveTrimmedVideo(
    BuildContext modalContext,
    void Function(void Function()) setModalState,
  ) async {
    if (_endValue <= _startValue) return;
    setModalState(() => _isTrimming = true);
    try {
      await _trimmer!.saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,
        onSave: (path) async {
          if (path == null) return;
          await _disposeVideoResources();
          final file = File(path);
          final controller = VideoPlayerController.file(file);
          await controller.initialize();
          await controller.setLooping(true);
          await controller.play();
          if (mounted) {
            setState(() {
              _finalVideoFile = file;
              _videoController = controller;
            });
          }
          setModalState(() => _isTrimming = false);
          Navigator.pop(modalContext);
        },
      );
    } catch (e) {
      log("Trim error: $e");
      setModalState(() => _isTrimming = false);
    }
  }

  // Future<void> _startAnalysis() async {
  //   if (_finalVideoFile == null) return;
  //   if (_videoController != null && _videoController!.value.isPlaying) {
  //     await _videoController!.pause();
  //   }
  //   setState(() {
  //     _isLoading = true;
  //     _uploadProgress = 0.0;
  //   });

  //   try {
  //     final jobId = await UserService().uploadVideoJob(
  //       videoFile: _finalVideoFile!,
  //       filterType: filterToArabic(_selectedFilter),
  //       summaryType: _summaryLength == SummaryLength.long ? "طويل" : "قصير",
  //       onProgress: (progress) => setState(() => _uploadProgress = progress),
  //     );

  //     if (jobId != null && mounted) {
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(builder: (_) => AnalysisResultScreen(jobId: jobId)),
  //       // );
  //     }
  //   } catch (e) {
  //     log("Upload error: $e");
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  // 3. دالة لإظهار الأخطاء للمستخدم
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
  // Future<void> startFullProcess(File videoFile) async {
  //   if (_videoController != null && _videoController!.value.isPlaying) {
  //     await _videoController!.pause();
  //   }

  //   setState(() {
  //     _isLoading = true;
  //     _uploadProgress = 0.0;
  //   });

  //   try {
  //     // 1️⃣ رفع الفيديو (مرة واحدة فقط)
  //     Map<String, dynamic>? response = await _userService.uploadVideoJob(
  //       videoFile: videoFile,
  //       filterType: filterToArabic(_selectedFilter),
  //       summaryType: _summaryLength == SummaryLength.long ? "طويل" : "قصير",
  //       onProgress: (p) => setState(() => _uploadProgress = p),
  //     );

  //     if (response == null) {
  //       throw "فشل استلام الرد من السيرفر";
  //     }

  //     // 2️⃣ Polling طالما الحالة queued
  //     while (response!['status'] == 'queued') {
  //       await Future.delayed(const Duration(seconds: 2));
  //       log(response.toString());

  //       // response = await _userService.fetchAnalysisResults();

  //       if (response == null) {
  //         throw "فشل أثناء انتظار نتيجة التحليل";
  //       }

  //       log("Polling status: ${response['status']}");
  //     }

  //     // 3️⃣ عند الاكتمال
  //     final clipsDir = response['clips_dir'];

  //     if (clipsDir == null || clipsDir.toString().isEmpty) {
  //       throw "لم يتم استلام مسار الكليبات";
  //     }

  //     // 4️⃣ الانتقال للواجهة التالية
  //     if (!mounted) return;
  //     final response_highlight =await _userService.fetchAnalysisResults(clipsDir: clipsDir);

  //     // Navigator.pushReplacement(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //     builder: (_) => VideoResultsScreen(clipsDir: clipsDir),
  //     //   ),
  //     // );
  //   } catch (e) {
  //     showError(e.toString());
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  // Future<void> startFullProcess(File videoFile) async {
  //   if (_videoController != null && _videoController!.value.isPlaying) {
  //     await _videoController!.pause();
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _isLoading = true;
  //     _uploadProgress = 0.0;
  //   });

  //   try {
  //     // 1️⃣ رفع الفيديو
  //     final response = await _userService.uploadVideoJob(
  //       videoFile: videoFile,
  //       filterType: filterToArabic(_selectedFilter),
  //       summaryType: _summaryLength == SummaryLength.long ? "طويل" : "قصير",
  //       onProgress: (p) {
  //         if (mounted) {
  //           setState(() => _uploadProgress = p * 0.3); // upload = 30%
  //         }
  //       },
  //     );

  //     if (response == null) {
  //       throw "فشل رفع الفيديو";
  //     }

  //     final String jobId = response['job_id'].toString();

  //     // 2️⃣ Polling progress (processing)
  //     await _pollVideoProgress(jobId);

  //     // 3️⃣ بعد الاكتمال → جلب النتيجة
  //     final jobResult = await _userService.getJobResult(jobId);

  //     if (jobResult == null) {
  //       throw "فشل جلب النتيجة";
  //     }

  //     if (!mounted) return;

  //     // 4️⃣ الانتقال للنتائج
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => const HomeScreen(),
  //         // أو VideoResultsScreen(...)
  //       ),
  //     );
  //   } catch (e) {
  //     if (mounted) showError(e.toString());
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //         _uploadProgress = 1.0;
  //       });
  //     }
  //   }
  // }
  // Future<void> startFullProcess(File videoFile) async {
  //   if (_videoController != null && _videoController!.value.isPlaying) {
  //     await _videoController!.pause();
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _isLoading = true;
  //     _uploadProgress = 0.0;
  //   });

  //   try {
  //     // 1️⃣ Upload
  //     final uploadResponse = await _userService.uploadVideoJob(
  //       videoFile: videoFile,
  //       filterType: filterToArabic(_selectedFilter),
  //       summaryType: _summaryLength == SummaryLength.long ? "طويل" : "قصير",
  //       onProgress: (p) {
  //         if (mounted) {
  //           setState(() => _uploadProgress = p * 0.3); // upload = 30%
  //         }
  //       },
  //     );

  //     if (uploadResponse == null) {
  //       throw "فشل رفع الفيديو";
  //     }

  //     final String uploadJobId = uploadResponse['job_id'].toString();

  //     final String videoId = uploadResponse['video']['id'].toString();

  //     final String clipsDir = uploadResponse['clips_dir']['absolute'];

  //     // 2️⃣ Poll upload/processing
  //     await _pollUploadProgress(uploadJobId);

  //     // 3️⃣ Generate summary (بعد 100%)
  //     if (!mounted) return;

  //     setState(() {
  //       _uploadProgress = 0.9; // نبلش generate
  //     });

  //     final generateResponse = await _userService.generateSummary(
  //       clipsDir: clipsDir,
  //       summaryType: filterToArabic(_selectedFilter),
  //       summaryLength: _summaryLength == SummaryLength.long ? "طويل" : "قصير",
  //       videoId: videoId,
  //     );

  //     if (generateResponse == null) {
  //       throw "فشل generate summary";
  //     }

  //     final String generateJobId = generateResponse['job_id'];

  //     log("Generate job started: $generateJobId");

  //     // 4️⃣ (اختياري لاحقًا) polling generate job

  //     if (!mounted) return;

  //     setState(() {
  //       _uploadProgress = 1.0;
  //       _isLoading = false;
  //     });

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => const HomeScreen()),
  //     );
  //   } catch (e) {
  //     if (mounted) showError(e.toString());
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  Future<void> startFullProcess(File videoFile) async {
    if (_videoController != null && _videoController!.value.isPlaying) {
      await _videoController!.pause();
    }

    setState(() {
      _isLoading = true;
      _uploadProgress = 0.0;
    });

    try {
      // 1️⃣ رفع الفيديو
      Map<String, dynamic>? uploadResponse = await _userService.uploadVideoJob(
        videoFile: videoFile,
        filterType: filterToArabic(_selectedFilter),
        summaryType: _summaryLength == SummaryLength.long ? "طويل" : "قصير",
        onProgress: (p) {
          if (mounted) {
            setState(() => _uploadProgress = p);
          }
        },
      );

      if (uploadResponse == null) throw "فشل استلام الرد من السيرفر";

      final String videoJobId = uploadResponse['job_id'].toString();
      final String clipsDir = uploadResponse['clips_dir']['absolute'] ?? '';

      if (clipsDir.isEmpty) throw "لم يتم استلام clips_dir";

      // 2️⃣ Polling على حالة الـ upload حتى يصبح progress = 100
      bool uploadCompleted = false;
      while (!uploadCompleted) {
        await Future.delayed(const Duration(seconds: 2));

        final Map<String, dynamic>? progressResponse = await _userService
            .fetchUploadProgress(videoJobId);

        if (progressResponse == null)
          throw "فشل أثناء انتظار الـ upload progress";

        final int progress = progressResponse['progress'] ?? 0;
        final String status = progressResponse['status'] ?? '';

        if (mounted) setState(() => _uploadProgress = progress / 100);

        if (progress >= 100 && status == "completed") {
          uploadCompleted = true;
        }

        log("Upload progress: $progress%, status: $status");
      }

      // 3️⃣ Generate summary بعد اكتمال الرفع
      final Map<String, dynamic>? generateResponse = await _userService
          .generateVideoSummary(
            clipsDir: clipsDir,
            summaryType: filterToArabic(_selectedFilter),
            summaryLength:
                _summaryLength == SummaryLength.long ? "طويل" : "قصير",
            videoId: uploadResponse['video']['id'].toString(),
          );

      if (generateResponse == null || !generateResponse.containsKey('job_id')) {
        throw "فشل أثناء إنشاء الـ summary";
      }

      final String generateJobId = generateResponse['job_id'];

      // 4️⃣ Polling على الـ generate result
      bool generateCompleted = false;
      Map<String, dynamic>? finalResult;

      while (!generateCompleted) {
        await Future.delayed(const Duration(seconds: 2));

        final Map<String, dynamic>? resultResponse = await _userService
            .getGenerateResult(generateJobId);

        if (resultResponse == null) throw "فشل أثناء انتظار نتيجة الـ summary";

        finalResult = resultResponse['result'];
        final int progress = resultResponse['progress'] ?? 0;
        final String status = resultResponse['status'] ?? '';

        if (mounted) setState(() => _uploadProgress = progress / 100);

        // if (progress >= 100) {
        if (progress >= 100 && status == "completed") {
          generateCompleted = true;
        }

        // log("Generate progress: $progress");
        log("Generate progress: $progress%, status: $status");
      }

      if (finalResult == null || !finalResult.containsKey('video_path')) {
        throw "فشل استلام الفيديو النهائي";
      }

      // final String finalVideoPath = finalResult['video_path'];
      // log("Final video path: $finalVideoPath");
      final String rawVideoPath = finalResult['video_path'];
      final String finalVideoUrl = buildFullUrl(rawVideoPath);

      log("Raw video path: $rawVideoPath");
      log("Final video URL: $finalVideoUrl");
      if (!mounted) return;

      // 5️⃣ الانتقال إلى شاشة عرض الفيديو أو العودة للـ HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VideoResultScreen(videoUrl: finalVideoUrl),
          // builder: (_) => VideoResultScreen(videoPath: finalVideoPath),
        ),
      );
    } catch (e) {
      showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Future<void> startFullProcess(File videoFile) async {
  //   if (_videoController != null && _videoController!.value.isPlaying) {
  //     await _videoController!.pause();
  //   }

  //   setState(() {
  //     _isLoading = true;
  //     _uploadProgress = 0.0;
  //   });

  //   try {
  //     // 1️⃣ رفع الفيديو
  //     Map<String, dynamic>? uploadResponse = await _userService.uploadVideoJob(
  //       videoFile: videoFile,
  //       filterType: filterToArabic(_selectedFilter),
  //       summaryType: _summaryLength == SummaryLength.long ? "طويل" : "قصير",
  //       onProgress: (p) {
  //         if (mounted) {
  //           setState(() => _uploadProgress = p);
  //         }
  //       },
  //     );

  //     if (uploadResponse == null) throw "فشل استلام الرد من السيرفر";

  //     final String videoJobId = uploadResponse['job_id'].toString();
  //     final String clipsDir = uploadResponse['clips_dir']['absolute'] ?? '';

  //     if (clipsDir.isEmpty) throw "لم يتم استلام clips_dir";

  //     // 2️⃣ Polling على حالة الـ upload حتى يصبح progress = 100
  //     bool uploadCompleted = false;
  //     while (!uploadCompleted) {
  //       await Future.delayed(const Duration(seconds: 2));

  //       final Map<String, dynamic>? progressResponse = await _userService
  //           .fetchUploadProgress(videoJobId);

  //       if (progressResponse == null)
  //         throw "فشل أثناء انتظار الـ upload progress";

  //       final int progress = progressResponse['progress'] ?? 0;
  //       final String status = progressResponse['status'] ?? '';

  //       if (mounted) setState(() => _uploadProgress = progress / 100);

  //       if (progress >= 100 && status == "completed") {
  //         uploadCompleted = true;
  //       }

  //       log("Upload progress: $progress%, status: $status");
  //     }

  //     // 3️⃣ Generate summary بعد اكتمال الرفع
  //     final Map<String, dynamic>? generateResponse = await _userService
  //         .generateVideoSummary(
  //           clipsDir: clipsDir,
  //           summaryType: filterToArabic(_selectedFilter),
  //           summaryLength:
  //               _summaryLength == SummaryLength.long ? "طويل" : "قصير",
  //           videoId: uploadResponse['video']['id'].toString(),
  //         );

  //     if (generateResponse == null || !generateResponse.containsKey('job_id')) {
  //       throw "فشل أثناء إنشاء الـ summary";
  //     }

  //     final String generateJobId = generateResponse['job_id'];

  //     // 4️⃣ Polling على الـ generate result
  //     bool generateCompleted = false;
  //     Map<String, dynamic>? finalResult;

  //     while (!generateCompleted) {
  //       await Future.delayed(const Duration(seconds: 2));

  //       final Map<String, dynamic>? resultResponse = await _userService
  //           .getGenerateResult(generateJobId);

  //       if (resultResponse == null) throw "فشل أثناء انتظار نتيجة الـ summary";

  //       finalResult = resultResponse['result'];
  //       final int progress = resultResponse['progress'] ?? 0;
  //       final String status = resultResponse['status'] ?? '';

  //       if (mounted) setState(() => _uploadProgress = progress / 100);

  //       if (progress >= 100 && status == "completed") {
  //         generateCompleted = true;
  //       }

  //       log("Generate progress: $progress%, status: $status");
  //     }

  //     if (finalResult == null || !finalResult.containsKey('video_path')) {
  //       throw "فشل استلام الفيديو النهائي";
  //     }

  //     final String finalVideoPath = finalResult['video_path'];
  //     log("Final video path: $finalVideoPath");

  //     if (!mounted) return;

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => HomeScreen(),
  //         // أو يمكن تمرير finalVideoPath لأي واجهة تعرض الفيديو
  //       ),
  //     );
  //   } catch (e) {
  //     showError(e.toString());
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  //   Future<void> startFullProcess(File videoFile) async {
  //   if (_videoController != null && _videoController!.value.isPlaying) {
  //     await _videoController!.pause();
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _isLoading = true;
  //     _uploadProgress = 0.0;
  //   });

  //   try {
  //     // 1️⃣ Upload video
  //     final uploadResponse = await _userService.uploadVideoJob(
  //       videoFile: videoFile,
  //       filterType: filterToArabic(_selectedFilter),
  //       summaryType: _summaryLength == SummaryLength.long ? "طويل" : "قصير",
  //       onProgress: (p) {
  //         if (mounted) {
  //           setState(() => _uploadProgress = p * 0.3); // upload = 30%
  //         }
  //       },
  //     );

  //     if (uploadResponse == null) throw "فشل رفع الفيديو";

  //     final String uploadJobId = uploadResponse['job_id'].toString();
  //     final String videoId = uploadResponse['video']['id'].toString();
  //     final String clipsDir = uploadResponse['clips_dir']['absolute'];

  //     // 2️⃣ Poll upload progress
  //     await _pollUploadProgress(uploadJobId);

  //     // 3️⃣ Generate summary
  //     if (!mounted) return;
  //     setState(() => _uploadProgress = 0.9);

  //     final generateResponse = await _userService.generateSummary(
  //       clipsDir: clipsDir,
  //       summaryType: filterToArabic(_selectedFilter),
  //       summaryLength: _summaryLength == SummaryLength.long ? "طويل" : "قصير",
  //       videoId: videoId,
  //     );

  //     if (generateResponse == null) throw "فشل generate summary";

  //     final String generateJobId = generateResponse['job_id'];

  //     // 4️⃣ Poll generate result
  //     Map<String, dynamic>? resultResponse;
  //     while (true) {
  //       await Future.delayed(const Duration(seconds: 2));

  //       resultResponse = await _userService.getGenerateResult(generateJobId);

  //       if (resultResponse == null) throw "فشل جلب result";

  //       final status = resultResponse['status'] ?? '';
  //       final progress = resultResponse['progress'] ?? 0;

  //       if (!mounted) return;

  //       setState(() => _uploadProgress = 0.9 + progress / 100 * 0.1); // 10% للـ generate

  //       log("Generate progress: $progress%, status: $status");

  //       if (status == 'completed' && progress >= 100) break;
  //     }

  //     // 5️⃣ عند الاكتمال: نحصل video_path النهائي
  //     final String videoPath = resultResponse['result']?['video_path'] ?? '';
  //     log("Final highlight video path: $videoPath");

  //     if (!mounted) return;

  //     setState(() {
  //       _uploadProgress = 1.0;
  //       _isLoading = false;
  //     });

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => HomeScreen(), // أو شاشة عرض الفيديو
  //       ),
  //     );
  //   } catch (e) {
  //     if (mounted) showError(e.toString());
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  // Future<void> startFullProcess(File videoFile) async {
  //   if (_videoController != null && _videoController!.value.isPlaying) {
  //     await _videoController!.pause();
  //   }

  //   setState(() {
  //     _isLoading = true;
  //     _uploadProgress = 0.0;
  //   });

  //   try {
  //     // 1️⃣ رفع الفيديو
  //     Map<String, dynamic>? response = await _userService.uploadVideoJob(
  //       videoFile: videoFile,
  //       filterType: filterToArabic(_selectedFilter),
  //       summaryType: _summaryLength == SummaryLength.long ? "طويل" : "قصير",
  //       onProgress: (p) => setState(() => _uploadProgress = p),
  //     );

  //     if (response == null) {
  //       throw "فشل استلام الرد من السيرفر";
  //     }

  //     final String jobId = response['job_id'];

  //     // 2️⃣ Polling طالما status = queued
  //     // while (response!['status'] == 'queued') {
  //     //   await Future.delayed(const Duration(seconds: 2));

  //     //   // response = await _userService.uploadVideoJobStatus(jobId);

  //     //   if (response == null) {
  //     //     throw "فشل أثناء الانتظار";
  //     //   }

  //     //   // تحديث progress
  //     //   if (response.containsKey('progress')) {
  //     //     setState(() {
  //     //       _uploadProgress = (response['progress'] ?? 0) / 100;
  //     //     });
  //     //   }

  //     //   log("Polling status: ${response['status']}");
  //     // }
  //     while (response!['status'] == 'queued') {
  //       await Future.delayed(const Duration(seconds: 2));
  //       log(response.toString());

  //       // response = await _userService.fetchAnalysisResults();

  //       if (response == null) {
  //         throw "فشل أثناء انتظار نتيجة التحليل";
  //       }

  //       log("Polling status: ${response['status']}");
  //     }
  //     // 3️⃣ عند الاكتمال نأخذ clips_dir
  //     final String? clipsDir = response['clips_dir'];

  //     if (clipsDir == null || clipsDir.isEmpty) {
  //       throw "لم يتم استلام clips_dir";
  //     }

  //     // 4️⃣ clips_dir → highlights (أولاً)
  //     final highlightsResponse = await _userService.fetchAnalysisResults(
  //       clipsDir: clipsDir,
  //     );
  //     log(highlightsResponse.toString());
  //     if (highlightsResponse == null) {
  //       throw "فشل أثناء الانتظار";
  //     }

  //     // تحديث progress
  //     if (highlightsResponse.containsKey('progress')) {
  //       setState(() {
  //         _uploadProgress = (highlightsResponse['progress'] ?? 0) / 100;
  //       });
  //     }

  //     log("Polling status: ${highlightsResponse['status']}");
  //     // if (highlightsResponse == null) {
  //     //   throw "فشل جلب highlights";
  //     // }

  //     // 5️⃣ بعدها getJobResult باستخدام jobId
  //     final jobResult = await _userService.getJobResult(jobId);

  //     if (jobResult == null) {
  //       throw "فشل getJobResult";
  //     }

  //     if (!mounted) return;

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => HomeScreen(),
  //         // VideoResultsScreen(
  //         //   highlights: highlightsResponse,
  //         //   clipsDir: clipsDir,
  //         // ),
  //       ),
  //     );
  //   } catch (e) {
  //     showError(e.toString());
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }
  Future<void> _pollUploadProgress(String jobId) async {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));

      final progressResponse = await _userService.getVideoProgress(jobId);

      if (progressResponse == null) {
        throw "فشل جلب progress";
      }

      final int progress = progressResponse['progress'] ?? 0;
      final String status = progressResponse['status'] ?? '';

      if (!mounted) return;

      setState(() {
        _uploadProgress = progress / 100;
      });

      log("Upload progress: $progress%, status: $status");

      if (progress >= 100 && status == 'completed') {
        break;
      }
    }
  }

  Future<void> _pollVideoProgress(String jobId) async {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));

      final progressResponse = await _userService.getVideoProgress(jobId);

      if (progressResponse == null) {
        throw "فشل جلب progress";
      }

      final int progress = progressResponse['progress'] ?? 0;
      final String status = progressResponse['status'] ?? '';

      if (!mounted) return;

      setState(() {
        _uploadProgress = progress / 100;
      });

      log("Progress: $progress%, status: $status");

      if (progress >= 100 && status == 'completed') {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundScaffold(
      // return Scaffold(
      // backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        title: const Text(
          "تحليل المباراة",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم اختيار الفيديو
            const Text(
              "فيديو المباراة",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickVideo,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 5, 30, 132).withOpacity(0.6),
                  // color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10, width: 1),
                ),
                child:
                    _videoController != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              ),
                              Container(
                                color: Colors.black26,
                                child: const Icon(
                                  Icons.edit_note,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.video_call,
                              color: const Color.fromARGB(
                                255,
                                114,
                                116,
                                228,
                              ).withOpacity(0.8),
                              // ).withOpacity(0.5),
                              size: 50,
                            ),
                            // Icon(Icons.add_video_sharp, color: const Color(0xFFE0B0FF).withOpacity(0.5), size: 50),
                            const SizedBox(height: 10),
                            const Text(
                              "اضغط لرفع فيديو المباراة",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
            const SizedBox(height: 30),

            // قسم الخيارات
            const Text(
              "خيارات التحليل",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // خيار نوع الفلتر
            _buildOptionContainer(
              title: "نوع الحدث المطلوب",
              child: DropdownButton<FilterType>(
                value: _selectedFilter,
                dropdownColor: const Color(0xFF28283D),
                // dropdownColor: const Color(0xFF28283D),
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: Color.fromARGB(255, 114, 116, 228),
                  // color: Color(0xFFE0B0FF),
                ),
                isExpanded: true,
                style: const TextStyle(
                  color: Color.fromARGB(255, 114, 116, 228),
                  fontWeight: FontWeight.bold,
                ),
                items:
                    FilterType.values
                        .map(
                          (f) => DropdownMenuItem(
                            value: f,
                            child: Text(filterToArabic(f)),
                          ),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _selectedFilter = v!),
              ),
            ),
            const SizedBox(height: 16),

            // خيار طول الملخص
            _buildOptionContainer(
              title: "طول ملخص الفيديو",
              child: Row(
                children: [
                  _buildChoiceChip(
                    "طويل",
                    _summaryLength == SummaryLength.short,
                    () => setState(() => _summaryLength = SummaryLength.short),
                  ),
                  const SizedBox(width: 10),
                  _buildChoiceChip(
                    "قصير",
                    _summaryLength == SummaryLength.long,
                    () => setState(() => _summaryLength = SummaryLength.long),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // زر البدء
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                onPressed:
                    // _finalVideoFile == null || _isLoading
                    //     ? null
                    //     : startFullProcess,
                    _finalVideoFile == null || _isLoading
                        ? null
                        : () => startFullProcess(_finalVideoFile!),
                // : _startAnalysis,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 114, 116, 228),
                  // backgroundColor: const Color(0xFFE0B0FF),
                  disabledBackgroundColor: const Color.fromARGB(
                    26,
                    133,
                    133,
                    158,
                  ),
                  // disabledBackgroundColor: Colors.white10,
                  // foregroundColor: const Color.fromARGB(255, 114, 116, 228),
                  foregroundColor: const Color(0xFF1E1E2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child:
                    _isLoading
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 114, 116, 228),
                                // color: Color(0xFF1E1E2E),
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "جارٍ التحليل ${(_uploadProgress * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                        : const Text(
                          "رفع الفيديو وبدء التحليل",
                          //  "بدء المعالجة الذكية",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 5, 55, 116).withOpacity(0.4),
        // color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color.fromARGB(0, 5, 55, 116).withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color.fromARGB(255, 114, 116, 228)
                    : Colors.transparent,
            // color: isSelected ? const Color(0xFF8A2BE2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.white12,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white38,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:matchifiy/widgets/anlysis_result_screen.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_trimmer/video_trimmer.dart';
// import 'package:matchifiy/services/user_service.dart';

// enum FilterType { goalsOnly, redCard, yellowCard }

// enum SummaryLength { long, short }

// class MatchAnalysisScreen extends StatefulWidget {
//   const MatchAnalysisScreen({super.key});

//   @override
//   State<MatchAnalysisScreen> createState() => _MatchAnalysisScreenState();
// }

// class _MatchAnalysisScreenState extends State<MatchAnalysisScreen> {
//   Trimmer? _trimmer;
//   File? _finalVideoFile;
//   VideoPlayerController? _videoController;

//   double _startValue = 0.0;
//   double _endValue = 0.0;
//   bool _isPlaying = false;
//   bool _isTrimming = false;
//   bool _isLoading = false;
//   double _uploadProgress = 0.0;

//   FilterType _selectedFilter = FilterType.goalsOnly;
//   SummaryLength _summaryLength = SummaryLength.long;

//   @override
//   void dispose() {
//     _disposeVideoResources();
//     super.dispose();
//   }

//   Future<void> _disposeVideoResources() async {
//     try {
//       if (_videoController != null) {
//         await _videoController!.pause();
//         await _videoController!.dispose();
//         _videoController = null;
//       }
//     } catch (e) {
//       log("Dispose error: $e");
//     }
//   }

//   String filterToArabic(FilterType type) {
//     switch (type) {
//       case FilterType.goalsOnly:
//         return "أهداف";
//       case FilterType.redCard:
//         return "بطاقة حمراء";
//       case FilterType.yellowCard:
//         return "بطاقة صفراء";
//     }
//   }

//   // ================= PICK VIDEO =================
//   Future<void> _pickVideo() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.video,
//         allowCompression: false,
//       );

//       if (result?.files.single.path == null) return;

//       final file = File(result!.files.single.path!);
//       await _disposeVideoResources();

//       _trimmer = Trimmer();
//       await _trimmer!.loadVideo(videoFile: file);

//       final duration =
//           _trimmer!.videoPlayerController!.value.duration.inMilliseconds;

//       _startValue = 0.0;
//       _endValue = duration.toDouble();

//       if (mounted) _showTrimmer();
//     } catch (e) {
//       log("Pick video error: $e");
//     }
//   }

//   // ================= TRIMMER =================
//   void _showTrimmer() {
//     if (_trimmer == null) return;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFF1E1E2E),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (modalContext) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Container(
//               height: MediaQuery.of(context).size.height * 0.85,
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: VideoViewer(trimmer: _trimmer!),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TrimViewer(
//                     trimmer: _trimmer!,
//                     viewerHeight: 50,
//                     viewerWidth: MediaQuery.of(context).size.width,
//                     durationStyle: DurationStyle.FORMAT_MM_SS,
//                     onChangeStart: (v) => _startValue = v,
//                     onChangeEnd: (v) => _endValue = v,
//                     onChangePlaybackState:
//                         (v) => setModalState(() => _isPlaying = v),
//                   ),
//                   const SizedBox(height: 20),
//                   IconButton(
//                     iconSize: 60,
//                     color: Colors.white,
//                     icon: Icon(
//                       _isPlaying ? Icons.pause_circle : Icons.play_circle,
//                     ),
//                     onPressed: () async {
//                       final p = await _trimmer!.videoPlaybackControl(
//                         startValue: _startValue,
//                         endValue: _endValue,
//                       );
//                       setModalState(() => _isPlaying = p);
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 55,
//                     child: ElevatedButton(
//                       onPressed:
//                           _isTrimming
//                               ? null
//                               : () => _saveTrimmedVideo(
//                                 modalContext,
//                                 setModalState,
//                               ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF8A2BE2),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       child:
//                           _isTrimming
//                               ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                               : const Text(
//                                 "حفظ المقطع المختار",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // ================= SAVE VIDEO =================
//   Future<void> _saveTrimmedVideo(
//     BuildContext modalContext,
//     void Function(void Function()) setModalState,
//   ) async {
//     if (_endValue <= _startValue) return;

//     setModalState(() => _isTrimming = true);

//     try {
//       await _trimmer!.saveTrimmedVideo(
//         startValue: _startValue,
//         endValue: _endValue,
//         onSave: (path) async {
//           if (path == null) return;

//           await _disposeVideoResources();

//           final file = File(path);
//           final controller = VideoPlayerController.file(file);

//           await controller.initialize();
//           await controller.setLooping(true);
//           await controller.play();

//           if (mounted) {
//             setState(() {
//               _finalVideoFile = file;
//               _videoController = controller;
//             });
//           }

//           setModalState(() => _isTrimming = false);
//           Navigator.pop(modalContext);
//         },
//       );
//     } catch (e) {
//       log("Trim error: $e");
//       setModalState(() => _isTrimming = false);
//     }
//   }

//   // ================= START ANALYSIS =================
//   // Future<void> _startAnalysis() async {
//   //   if (_finalVideoFile == null) return;

//   //   setState(() => _isLoading = true);

//   //   try {
//   //     final jobId = await UserService().uploadVideoJob(
//   //       videoFile: _finalVideoFile!,
//   //       filterType: "اهداف".toString(),
//   //       // filterType: filterToArabic(_selectedFilter),
//   //       summaryType: _summaryLength == SummaryLength.long ? "طويل" : "قصير",

//   //       onProgress: (progress) {
//   //         log("Upload progress: ${(progress * 100).toStringAsFixed(0)}%");
//   //       },
//   //     );

//   //     if (jobId != null && mounted) {
//   //       Navigator.push(
//   //         context,
//   //         MaterialPageRoute(builder: (_) => AnalysisResultScreen(jobId: jobId)),
//   //       );
//   //     }
//   //   } catch (e) {
//   //     log("Upload error: $e");
//   //   } finally {
//   //     if (mounted) setState(() => _isLoading = false);
//   //   }
//   // }

//   Future<void> _startAnalysis() async {
//     if (_finalVideoFile == null) return;

//     //  أوقف تشغيل الفيديو فورًا
//     if (_videoController != null && _videoController!.value.isPlaying) {
//       await _videoController!.pause();
//     }

//     setState(() {
//       _isLoading = true;
//       _uploadProgress = 0.0;
//     });

//     try {
//       final jobId = await UserService().uploadVideoJob(
//         videoFile: _finalVideoFile!,
//         filterType: "اهداف",
//         summaryType: _summaryLength == SummaryLength.long ? "طويل" : "قصير",
//         onProgress: (progress) {
//           setState(() {
//             _uploadProgress = progress;
//           });
//         },
//       );

//       if (jobId != null && mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => AnalysisResultScreen(jobId: jobId)),
//         );
//       }
//     } catch (e) {
//       log("Upload error: $e");
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E2E),
//       appBar: AppBar(
//         title: const Text("تحليل المباراة"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickVideo,
//               child: Container(
//                 height: 220,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child:
//                     _videoController != null
//                         ? ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: VideoPlayer(_videoController!),
//                         )
//                         : const Center(
//                           child: Text(
//                             "اضغط لاختيار فيديو المباراة",
//                             style: TextStyle(color: Colors.white38),
//                           ),
//                         ),
//               ),
//             ),
//             const SizedBox(height: 40),
//             SizedBox(
//               width: double.infinity,
//               height: 60,
//               child: ElevatedButton(
//                 onPressed:
//                     _finalVideoFile == null || _isLoading
//                         ? null
//                         : _startAnalysis,
//                 child:
//                     _isLoading
//                         ? const CircularProgressIndicator()
//                         : const Text("بدء المعالجة الذكية"),
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               height: 60,
//               child: ElevatedButton(
//                 onPressed:
//                     _finalVideoFile == null || _isLoading
//                         ? null
//                         : _startAnalysis,
//                 child:
//                     _isLoading
//                         ? Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const CircularProgressIndicator(
//                               color: Colors.white,
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               "جارٍ الرفع ${(_uploadProgress * 100).toStringAsFixed(0)}%",
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         )
//                         : const Text("بدء المعالجة الذكية"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ================= OLD CODE =================
//الاسااسي
// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:matchifiy/models/Video_Filter.dart';
// import 'package:matchifiy/services/user_service.dart';
// import 'package:matchifiy/services/app_localizations.dart';
// import 'package:matchifiy/widgets/anlysis_result_screen.dart';

// enum FilterType { goalsOnly, redCard, yellowCard }

// enum SummaryLength { long, short }

// class MatchAnalysisScreen extends StatefulWidget {
//   const MatchAnalysisScreen({super.key});

//   @override
//   State<MatchAnalysisScreen> createState() => _MatchAnalysisScreenState();
// }

// class _MatchAnalysisScreenState extends State<MatchAnalysisScreen> {
//   static const Color inputFieldBg = Color(0xFF28283D);
//   static const Color gradientStart = Color(0xFF8A2BE2);
//   static const Color gradientEnd = Color(0xFFE0B0FF);

//   FilterType? _selectedFilter = FilterType.goalsOnly;
//   SummaryLength? _selectedSummaryLength = SummaryLength.long;
//   bool _isLoading = false;

//   final TextEditingController _videoLinkController = TextEditingController();
//   // final TextEditingController _playerNameController = TextEditingController();

//   // تحويل الفلتر إلى نص عربي للباكند (ثابت بغض النظر عن لغة التطبيق)
//   String filterToArabic(FilterType type) {
//     switch (type) {
//       case FilterType.goalsOnly:
//         return "اهداف";
//       case FilterType.redCard:
//         return "بطاقة حمراء";
//       case FilterType.yellowCard:
//         return "بطاقة صفراء";
//     }
//   }

//   void _startAnalysis() async {
//     final loc = AppLocalizations.of(context);
//     if (_videoLinkController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(loc.pleaseEnterLink)));
//       return;
//     }

//     setState(() => _isLoading = true);

//     final videoFilter = VideoFilterModel(
//       url: _videoLinkController.text,
//       type: filterToArabic(_selectedFilter!),
//       summaryType:
//           _selectedSummaryLength == SummaryLength.long ? "طويل" : "قصير",
//       // playerName:
//       //     _playerNameController.text.isEmpty
//       //         ? null
//       //         : _playerNameController.text,
//     );

//     log(jsonEncode(videoFilter.toJson()));

//     try {
//       await UserService().sendFilter(videoFilter);
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "${loc.analysisFinished}: ${videoFilter.type}, ${loc.summaryLabel}: ${videoFilter.summaryType}",
//           ),
//           backgroundColor: gradientStart,
//         ),
//       );
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) => AnalysisResultScreen(
//                 video: videoFilter,
//                 // extractedText: extractedText,
//                 // يمكنك تمرير الفيديو أو البيانات كاملة إذا عدلت constructor شاشة النتائج
//                 // videoUrl: videoFilter.url,
//                 // rawData: response is Map ? response : {},
//               ),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("${loc.errorLabel}: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loc = AppLocalizations.of(context);
//     final isArabic = Localizations.localeOf(context).languageCode == 'ar';

//     return Directionality(
//       textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
//       child: Scaffold(
//         backgroundColor: const Color(0xFF1E1E2E),
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(
//               isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
//               color: Colors.white,
//             ),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: Text(
//             loc.matchAnalysis,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           backgroundColor: const Color(0xFF1E1E2E),
//           elevation: 0,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _buildInputSection(
//                 loc.videoLinkLabel,
//                 loc.videoLinkHint,
//                 _videoLinkController,
//               ),
//               const SizedBox(height: 15),
//               // _buildInputSection(
//               //   loc.playerNameLabel,
//               //   loc.playerNameHint,
//               //   _playerNameController,
//               // ),
//               const SizedBox(height: 30),
//               _buildFilterSelection(loc),
//               const SizedBox(height: 30),
//               _buildSummaryLengthSelection(loc),
//               const SizedBox(height: 40),
//               _buildStartButton(loc),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputSection(
//     String label,
//     String hint,
//     TextEditingController controller,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white70, fontSize: 14),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: const TextStyle(color: Colors.white30),
//             fillColor: inputFieldBg,
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFilterSelection(AppLocalizations loc) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           loc.selectFilterType,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 10),
//         _buildFilterRadioTile(loc.filterGoals, FilterType.goalsOnly),
//         _buildFilterRadioTile(loc.filterRedCard, FilterType.redCard),
//         _buildFilterRadioTile(loc.filterYellowCard, FilterType.yellowCard),
//       ],
//     );
//   }

//   Widget _buildSummaryLengthSelection(AppLocalizations loc) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           loc.selectSummaryLength,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 10),
//         _buildSummaryRadioTile(loc.summaryLong, SummaryLength.long),
//         _buildSummaryRadioTile(loc.summaryShort, SummaryLength.short),
//       ],
//     );
//   }

//   Widget _buildFilterRadioTile(String title, FilterType value) {
//     return RadioListTile<FilterType>(
//       title: Text(title, style: const TextStyle(color: Colors.white)),
//       value: value,
//       groupValue: _selectedFilter,
//       activeColor: gradientEnd,
//       onChanged: (v) => setState(() => _selectedFilter = v),
//     );
//   }

//   Widget _buildSummaryRadioTile(String title, SummaryLength value) {
//     return RadioListTile<SummaryLength>(
//       title: Text(title, style: const TextStyle(color: Colors.white)),
//       value: value,
//       groupValue: _selectedSummaryLength,
//       activeColor: gradientEnd,
//       onChanged: (v) => setState(() => _selectedSummaryLength = v),
//     );
//   }

//   Widget _buildStartButton(AppLocalizations loc) {
//     return Container(
//       height: 55,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(colors: [gradientStart, gradientEnd]),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ElevatedButton(
//         onPressed: _isLoading ? null : _startAnalysis,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//         ),
//         child:
//             _isLoading
//                 ? const CircularProgressIndicator(color: Colors.white)
//                 : Text(
//                   loc.startAnalysis,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//       ),
//     );
//   }
// }
