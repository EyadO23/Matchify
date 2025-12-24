import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:matchifiy/models/Video_Filter.dart';
import 'package:matchifiy/services/user_service.dart';

class AnalysisResultScreen extends StatefulWidget {
  final VideoFilterModel video;

  const AnalysisResultScreen({super.key, required this.video});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  final UserService _service = UserService();

  String? extractedText;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExtractText();
  }

  Future<void> _loadExtractText() async {
    final result = await _service.sendFilter(widget.video);
    log("Extracted Text: $result");

    setState(() {
      extractedText = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    const Color primaryPurple = Color(0xFF8A2BE2);
    const Color bgCard = Color(0xFF28283D);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        title: Text(isArabic ? "نتائج التحليل" : "Analysis Results"),
        backgroundColor: const Color(0xFF1E1E2E),
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : extractedText == null
              ? Center(
                child: Text(
                  isArabic ? "لا يوجد نتائج" : "No results found",
                  style: const TextStyle(color: Colors.white),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: bgCard,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SelectableText(
                    extractedText!,
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.8,
                    ),
                  ),
                ),
              ),
    );
  }
}
