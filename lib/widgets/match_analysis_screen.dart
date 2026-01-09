import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:matchifiy/main.dart';
import 'package:matchifiy/services/token_storage.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
import 'package:matchifiy/widgets/change_password_screen.dart';
import 'package:matchifiy/widgets/favotite_team_screen.dart';
import 'package:matchifiy/widgets/myHighlights_screen.dart';
import 'package:matchifiy/widgets/news_screen.dart';
import 'package:matchifiy/widgets/video_result_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:matchifiy/services/user_service.dart';

enum FilterType { goalsOnly, cardsOnly }

enum SummaryLength { long, short }

class MatchAnalysisScreen extends StatefulWidget {
  const MatchAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<MatchAnalysisScreen> createState() => _MatchAnalysisScreenState();
}

class _MatchAnalysisScreenState extends State<MatchAnalysisScreen> {
  String ip = TokenStorage.getIp();
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
  String _userName = "user";
  String _userEmail = "user@gmail.com";
  String _usernameHandle = "user12";

  @override
  void initState() {
    super.initState();
    _loadUserFromStorage();
    _checkIfVideoReady();
    // _fetchNews();
  }

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

  String filterToArabic(FilterType type) {
    switch (type) {
      case FilterType.goalsOnly:
        return "goals";
      case FilterType.cardsOnly:
        return "cards";
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
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.black.withOpacity(0.9),
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
                    color: Color.fromARGB(255, 137, 182, 217),
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
                        backgroundColor: Color.fromARGB(255, 137, 182, 217),

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

  // 3. دالة لإظهار الأخطاء للمستخدم
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> startFullProcess(File videoFile) async {
    if (_videoController != null && _videoController!.value.isPlaying) {
      await _videoController!.pause();
    }

    setState(() {
      _isLoading = true;
      _uploadProgress = 0.0;
    });

    try {
      Map<String, dynamic>? uploadResponse = await _userService.uploadVideoJob(
        videoFile: videoFile,
        filterType: filterToArabic(_selectedFilter),
        onProgress: (p) {
          if (mounted) setState(() => _uploadProgress = p);
        },
      );

      log(videoFile.toString());
      log(FilterType.values.toString());
      log(uploadResponse.toString());

      if (uploadResponse == null) throw "فشل استلام الرد من السيرفر";

      final String videoJobId = uploadResponse['job_id'].toString();
      final String clipsDir = uploadResponse['clips_dir']['absolute'] ?? '';

      if (clipsDir.isEmpty) throw "لم يتم استلام clips_dir";

      bool uploadCompleted = false;
      while (!uploadCompleted) {
        await Future.delayed(const Duration(seconds: 2));

        final Map<String, dynamic>? progressResponse = await _userService
            .fetchUploadProgress(videoJobId);

        if (progressResponse == null) {
          throw "فشل أثناء انتظار الـ upload progress";
        }

        final int progress = progressResponse['progress'] ?? 0;
        final String status = progressResponse['status'] ?? '';

        if (mounted) setState(() => _uploadProgress = progress / 100);

        if (progress >= 100 && status == "completed") {
          uploadCompleted = true;
        }

        log("Upload progress: $progress%, status: $status");
      }

      final Map<String, dynamic>? generateResponse = await _userService
          .generateVideoSummary(
            clipsDir: clipsDir,
            videoId: uploadResponse['video']['id'].toString(),
          );

      if (generateResponse == null || !generateResponse.containsKey('job_id')) {
        throw "فشل أثناء إنشاء الـ summary";
      }

      final String generateJobId = generateResponse['job_id'];

      Map<String, dynamic>? finalResult;
      bool generateCompleted = false;

      while (!generateCompleted) {
        await Future.delayed(const Duration(seconds: 2));

        final Map<String, dynamic>? resultResponse = await _userService
            .getGenerateResult(generateJobId);

        if (resultResponse == null) {
          throw "فشل أثناء انتظار نتيجة الـ summary";
        }

        final int progress = resultResponse['progress'] ?? 0;
        final String status = resultResponse['status'] ?? '';

        if (mounted) setState(() => _uploadProgress = progress / 100);

        if (resultResponse.containsKey('result') &&
            resultResponse['result'] != null) {
          finalResult = resultResponse['result'];
        }

        if (status == "completed") {
          generateCompleted = true;
        }
        log(finalResult.toString());
        log("Generate progress: $progress%, status: $status");
      }

      if (finalResult == null || !finalResult.containsKey('video_path')) {
        throw "فشل استلام الفيديو النهائي";
      }

      final String rawVideoPath = finalResult['video_path'];
      final String finalVideoUrl = '$ip$rawVideoPath';

      log("Raw video path: $rawVideoPath");
      log("Final video URL: $finalVideoUrl");
      log('$ip$rawVideoPath');
      if (!mounted) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoResultScreen(videoUrl: '$ip$rawVideoPath'),
          ),
        );
      });
    } catch (e) {
      showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _checkIfVideoReady() async {
    final url = await TokenStorage.getLastVideoResult();

    if (url != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoResultScreen(videoUrl: url)),
      );
    }
  }

  void _toggleLanguage() {
    final currentLocale = Localizations.localeOf(context);
    final newLocale =
        currentLocale.languageCode == 'ar'
            ? const Locale('en')
            : const Locale('ar');
    MyApp.of(context).setLocale(newLocale);
  }

  Future<void> _loadUserFromStorage() async {
    final userData = await TokenStorage.getUserData();

    if (!mounted) return;

    setState(() {
      _userName = userData['name'] ?? "user";
      _userEmail = userData['email'] ?? "user@gmail.com";
      _usernameHandle = userData['username'] ?? "user12";
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: CustomBackgroundScaffold(
        drawer: _buildDrawer(isArabic),
        appBar: AppBar(
          title: Text(
            isArabic ? "تحليل المباراة" : "Match Analysis",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
              Text(
                isArabic ? "فيديو المباراة" : "Match Video",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _pickVideo,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2E).withOpacity(0.8),
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
                              const Icon(
                                Icons.video_call,
                                color: Color.fromARGB(255, 137, 182, 217),
                                size: 50,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                isArabic
                                    ? "اضغط لرفع فيديو المباراة"
                                    : "Tap to upload match video",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                isArabic ? "خيارات التحليل" : "Analysis Options",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _buildOptionContainer(
                title: isArabic ? "نوع الحدث المطلوب" : "Event Type",
                child: DropdownButton<FilterType>(
                  value: _selectedFilter,
                  dropdownColor: const Color(0xFF28283D),
                  underline: const SizedBox(),
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Color.fromARGB(255, 137, 182, 217),
                  ),
                  isExpanded: true,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 137, 182, 217),
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

              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed:
                      _finalVideoFile == null || _isLoading
                          ? null
                          : () => startFullProcess(_finalVideoFile!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 114, 116, 228),
                    disabledBackgroundColor: const Color.fromARGB(
                      26,
                      133,
                      133,
                      158,
                    ),
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
                                  color: Color.fromARGB(255, 137, 182, 217),
                                  strokeWidth: 3,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                _uploadProgress < 1.0
                                    ? (isArabic
                                        ? "جارٍ رفع الفيديو"
                                        : "Uploading video")
                                    : (isArabic
                                        ? "جارٍ التحليل"
                                        : "Analyzing video"),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                          : Text(
                            isArabic
                                ? "رفع الفيديو وبدء التحليل"
                                : "Upload video and start analysis",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E).withOpacity(0.8),
        // color: const Color.fromARGB(0, 5, 55, 116).withOpacity(0.4),
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

  Widget _buildDrawer(bool isArabic) {
    return Drawer(
      backgroundColor: const Color(0xFF1B1C1C).withOpacity(0.9),
      // backgroundColor: const Color(0xFF1B1C1C),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            // arrowColor: Colors.transparent,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 137, 182, 217), Color(0xFF92A3D0)],
                // colors: [Color(0xFF7274E4), Color(0xFF92A3D0)],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(
                _userName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            accountName: Text(_userName),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_userEmail),
                Text(
                  _usernameHandle,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _drawerItem(
                  Icons.home,
                  isArabic ? "الرئيسية" : "Home",
                  () => Navigator.pop(context),
                ),
                _drawerItem(
                  Icons.analytics,
                  isArabic ? "اخر الأخبار" : "News",
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NewsScreen()),
                    );
                  },
                ),
                _drawerItem(
                  Icons.favorite,
                  isArabic ? "فريقي المفضل" : "Favorite Team",
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FavoriteTeamScreen(),
                      ),
                    );
                    // .then((_) {
                    //   if (mounted) _fetchNews();
                    // });
                  },
                ),
                _drawerItem(
                  Icons.language,
                  isArabic ? "تغيير اللغة" : "Change Language",
                  () {
                    Navigator.pop(context);
                    _toggleLanguage();
                  },
                ),
                _drawerItem(
                  Icons.language,
                  isArabic ? " اللغة" : "Change Language",
                  () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin-dashboard');
                  },
                ),
                _drawerItem(
                  Icons.video_library,
                  isArabic ? "ملخصاتي" : "My Summaries",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHighlightsScreen(),
                      ),
                    );
                    // Navigator.pop(context);
                    // _toggleLanguage();
                  },
                ),
                const Divider(color: Colors.white24),
                _drawerItem(
                  Icons.lock_reset,
                  isArabic ? "تغيير كلمة المرور" : "Change Password",
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await TokenStorage.deleteToken();
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
              icon: const Icon(Icons.logout_rounded),
              label: Text(isArabic ? "تسجيل الخروج" : "Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                foregroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 137, 182, 217)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
