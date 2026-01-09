import 'package:flutter/material.dart';
import 'package:matchifiy/services/admin_service.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {
  final AdminService _service = AdminService();
  bool _isLoading = true;
  List<dynamic> _videos = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      final data = await _service.getAllReports();
      setState(() {
        _videos = data['videos'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return CustomBackgroundScaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? "إدارة وإحصائيات التقارير" : "Reports & Analytics",
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
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSummaryCards(isArabic), // بطاقات إحصائية علوية
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _videos.length,
                      itemBuilder:
                          (context, index) =>
                              _buildVideoDetailCard(_videos[index], isArabic),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildSummaryCards(bool isArabic) {
    int totalVideos = _videos.length;
    int completed =
        _videos.where((v) => v['processing_status'] == 'completed').length;

    return Row(
      children: [
        _statCard(
          isArabic ? "إجمالي الفيديوهات" : "Total Videos",
          totalVideos.toString(),
          const Color.fromARGB(255, 16, 93, 228).withOpacity(0.9),
        ),
        const SizedBox(width: 10),
        _statCard(
          isArabic ? "ناجحة" : "Completed",
          completed.toString(),
          const Color.fromARGB(255, 31, 108, 34),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoDetailCard(dynamic video, bool isArabic) {
    final result = video['result'];
    double originalTime =
        (result['total_duration_sec'] ?? video['duration_seconds']).toDouble();
    double reductionFactor =
        (result['time_reduction_factor'] ?? 1.0).toDouble();
    double savedTime = originalTime - (originalTime / reductionFactor);
    double processingTime = (video['processing_time_seconds'] ?? 0).toDouble();
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic
                    ? "فيديو #${video['video_id']} - ${video['user_name']}"
                    : "Video #${video['video_id']} - ${video['user_name']}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _statusBadge(video['processing_status']),
            ],
          ),
          const Divider(color: Colors.white10, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoItem(
                isArabic ? "الوقت الأصلي" : "Original Time",
                "${originalTime.toStringAsFixed(1)}s",
              ),
              _infoItem(
                isArabic ? "معامل الاختصار" : "Reduction Factor",
                "x${reductionFactor.toStringAsFixed(1)}",
              ),
              _infoItem(
                isArabic ? "توفير الوقت" : "Saved Time",
                "${savedTime.toStringAsFixed(1)}s",
              ),
              _infoItem(
                isArabic ? "زمن المعالجة" : "Processing Time",
                "${processingTime.toStringAsFixed(1)}s",
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 1 / reductionFactor,
              backgroundColor: Colors.white10,
              color: _getSummaryColor(video['summary_type']),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            (isArabic ? "نوع التلخيص: " : "Summary Type: ") +
                video['summary_type'],
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color color = status == 'completed' ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10),
      ),
    );
  }

  Color _getSummaryColor(String type) {
    if (type == 'goals') return Colors.orange;
    if (type == 'cards') return Colors.redAccent;
    return Color.fromARGB(255, 137, 182, 217);
    // return Colors.purple;
  }
}
