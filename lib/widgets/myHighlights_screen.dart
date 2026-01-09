import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:matchifiy/models/user_highlight_model.dart';
import 'package:matchifiy/services/token_storage.dart';
import 'package:matchifiy/services/user_service.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
import 'package:matchifiy/widgets/video_result_screen.dart';

class MyHighlightsScreen extends StatefulWidget {
  const MyHighlightsScreen({super.key});

  @override
  State<MyHighlightsScreen> createState() => _MyHighlightsScreenState();
}

class _MyHighlightsScreenState extends State<MyHighlightsScreen> {
  final Color primaryColor = const Color(0xFF6C63FF);
  final Color accentColor = const Color(0xFF00D2FF);
  final Color cardColor = const Color(0xFF1E1E2E);

  List<UserHighlight> _highlights = [];
  bool _isLoading = true;

  final _userService = UserService();
  String ip = TokenStorage.getIp();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _userService.getMyHighlights();

    if (!mounted) return;

    setState(() {
      _highlights = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return CustomBackgroundScaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? "ملخصاتي" : "My Highlights",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            ),
          ),
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : _buildModernGrid(isArabic),
    );
  }

  Widget _buildModernGrid(bool isArabic) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 0.85,
      ),
      itemCount: _highlights.length,
      itemBuilder: (context, index) {
        final item = _highlights[index];
        return _buildFancyCard(item, isArabic);
      },
    );
  }

  Widget _buildFancyCard(UserHighlight highlight, bool isArabic) {
    return GestureDetector(
      onTap: () {
        log("Highlight path: ${highlight.path}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    VideoResultScreen(videoUrl: '$ip${highlight.path}'),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                left: -20,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: primaryColor.withOpacity(0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [primaryColor, accentColor],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isArabic
                          ? "مباراة #${highlight.videoId}"
                          : "Match #${highlight.videoId}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isArabic ? "جاهز للعرض" : "Ready to watch",
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Icon(
                  Icons.auto_awesome,
                  color: accentColor.withOpacity(0.5),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
