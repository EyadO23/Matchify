import 'package:flutter/material.dart';
import 'package:matchifiy/services/admin_service.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

class UserDetailsScreen extends StatefulWidget {
  final int userId;
  final String userName;

  const UserDetailsScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final AdminService _adminService = AdminService();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final data = await _adminService.getUserReport(widget.userId);
      if (!mounted) return;
      setState(() {
        _userData = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return CustomBackgroundScaffold(
      appBar: AppBar(
        title: Text(
          "${isArabic ? 'تقارير' : 'Reports'}: ${widget.userName}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildReportsList(isArabic),
    );
  }

  Widget _buildReportsList(bool isArabic) {
    final List videos = _userData?['videos'] ?? [];

    if (videos.isEmpty) {
      return Center(
        child: Text(
          isArabic
              ? "لا توجد فيديوهات لهذا المستخدم"
              : "No videos for this user",
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Card(
          margin: const EdgeInsets.all(10),
          color: Colors.black.withOpacity(0.4),
          child: ListTile(
            title: Text(
              isArabic
                  ? "فيديو ID: ${video['video_id']}"
                  : "Video ID: ${video['video_id']}",
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              isArabic
                  ? "النوع: ${video['summary_type']} - الحالة: ${video['processing_status']}"
                  : "Type: ${video['summary_type']} - Status: ${video['processing_status']}",
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        );
      },
    );
  }
}
