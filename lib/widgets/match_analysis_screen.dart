import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

// // تعريف قائمة أنواع الفلتر
// enum FilterType { goalsOnly, redCard, favoritePlayerShots }

// class MatchAnalysisScreen extends StatefulWidget {
//   const MatchAnalysisScreen({super.key});

//   @override
//   State<MatchAnalysisScreen> createState() => _MatchAnalysisScreenState();
// }

// class _MatchAnalysisScreenState extends State<MatchAnalysisScreen> {
//   // ********** الألوان المستخدمة (Colors) **********
//   static const Color inputFieldBg = Color(0xFF28283D);
//   static const Color gradientStart = Color(0xFF8A2BE2);
//   static const Color gradientEnd = Color(0xFFE0B0FF);

//   FilterType? _selectedFilter = FilterType.goalsOnly;
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // زر العودة: Navigator.pushReplacementNamed يمنع العودة إلى شاشة التسجيل
//         // لذلك هذا الزر سيقوم بالرجوع في حال كان هناك شاشة سابقة (مثل صفحة رئيسية)
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: const Text(
//           'Match Analysis',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             _buildVideoLinkInput(),
//             const SizedBox(height: 30),
//             _buildFilterSelection(),
//             const SizedBox(height: 40),
//             _buildStartAnalysisButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoLinkInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Enter the video link here',
//           style: TextStyle(color: Colors.white70, fontSize: 14),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           decoration: InputDecoration(
//             hintText: 'https://example.com/match.mp4',
//             hintStyle: const TextStyle(color: Colors.white30),
//             fillColor: inputFieldBg,
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: BorderSide.none,
//             ),
//           ),
//           style: const TextStyle(color: Colors.white),
//         ),
//       ],
//     );
//   }

//   Widget _buildFilterSelection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Select Filter Type',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 15),
//         _buildRadioTile(title: 'Goals Only', value: FilterType.goalsOnly),
//         _buildRadioTile(title: 'Red Card', value: FilterType.redCard),
//         _buildRadioTile(
//           title: 'Favorite player shots',
//           value: FilterType.favoritePlayerShots,
//         ),
//       ],
//     );
//   }

//   Widget _buildRadioTile({required String title, required FilterType value}) {
//     return Theme(
//       data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white70),
//       child: RadioListTile<FilterType>(
//         title: Text(
//           title,
//           style: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         value: value,
//         groupValue: _selectedFilter,
//         onChanged: (FilterType? newValue) {
//           setState(() {
//             _selectedFilter = newValue;
//           });
//         },
//         activeColor: gradientEnd,
//         contentPadding: EdgeInsets.zero,
//       ),
//     );
//   }

//   Widget _buildStartAnalysisButton() {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [gradientStart, gradientEnd],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: ElevatedButton(
//         onPressed:
//             _isLoading
//                 ? null
//                 : () {
//                   setState(() {
//                     _isLoading = true;
//                   });
//                   // محاكاة عملية التحليل (يمكنك وضع الكود الخاص بك هنا)
//                   Future.delayed(const Duration(seconds: 3), () {
//                     if (mounted) {
//                       setState(() {
//                         _isLoading = false;
//                       });
//                     }
//                   });
//                 },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//         child:
//             _isLoading
//                 ? const SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 3,
//                   ),
//                 )
//                 : const Text(
//                   'Start Analysis',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//       ),
//     );
//   }
// }
///////////////////////////////////////////////
// import 'package:flutter/material.dart';
// import 'package:matchifiy/models/Video_Filter.dart';
// import 'package:matchifiy/services/token_storage.dart';
// import 'package:matchifiy/services/user_service.dart';

// enum FilterType { goalsOnly, redCard, favoritePlayerShots }

// enum SummaryLength { long, short }

// class MatchAnalysisScreen extends StatefulWidget {
//   const MatchAnalysisScreen({super.key});

//   @override
//   State<MatchAnalysisScreen> createState() => _MatchAnalysisScreenState();
// }

// class _MatchAnalysisScreenState extends State<MatchAnalysisScreen> {
//   // ********** الألوان المستخدمة **********
//   static const Color inputFieldBg = Color(0xFF28283D);
//   static const Color gradientStart = Color(0xFF8A2BE2);
//   static const Color gradientEnd = Color(0xFFE0B0FF);

//   // متغيرات الحالة
//   FilterType? _selectedFilter = FilterType.goalsOnly;
//   SummaryLength? _selectedSummaryLength = SummaryLength.long;
//   bool _isLoading = false;
//   final TextEditingController _videoLinkController = TextEditingController();
//   final TextEditingController _playerNameController =
//       TextEditingController(); // إضافة اختيار اللاعب

//   // ********** دالة إرسال البيانات والتحليل **********
//   void _startAnalysis() async {
//     if (_videoLinkController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a video link.')),
//       );
//       return;
//     }
//     if (_selectedFilter == null || _selectedSummaryLength == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select both filter and summary length.'),
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     final videoFilter = VideoFilterModel(
//       url: _videoLinkController.text,
//       type: _selectedFilter.toString().split('.').last,
//       summaryType: _selectedSummaryLength.toString().split('.').last,
//       playerName:
//           _playerNameController.text.isEmpty
//               ? null
//               : _playerNameController.text,
//     );

//     try {
//       await UserService().sendFilter(videoFilter);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Analysis finished. Filter: ${videoFilter.type}, Length: ${videoFilter.summaryType}',
//             ),
//             backgroundColor: gradientStart,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error sending filter: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E2E),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text(
//           'Match Analysis',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFF1E1E2E),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             _buildVideoLinkInput(),
//             const SizedBox(height: 15),
//             _buildPlayerNameInput(),
//             const SizedBox(height: 30),
//             _buildFilterSelection(),
//             const SizedBox(height: 30),
//             _buildSummaryLengthSelection(),
//             const SizedBox(height: 40),
//             _buildStartAnalysisButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoLinkInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Enter the video link',
//           style: TextStyle(color: Colors.white70, fontSize: 14),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _videoLinkController,
//           decoration: InputDecoration(
//             hintText: 'https://example.com/match.mp4',
//             hintStyle: const TextStyle(color: Colors.white30),
//             fillColor: inputFieldBg,
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: BorderSide.none,
//             ),
//           ),
//           style: const TextStyle(color: Colors.white),
//         ),
//       ],
//     );
//   }

//   Widget _buildPlayerNameInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Favorite Player Name (optional)',
//           style: TextStyle(color: Colors.white70, fontSize: 14),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: _playerNameController,
//           decoration: InputDecoration(
//             hintText: 'Enter player name',
//             hintStyle: const TextStyle(color: Colors.white30),
//             fillColor: inputFieldBg,
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: BorderSide.none,
//             ),
//           ),
//           style: const TextStyle(color: Colors.white),
//         ),
//       ],
//     );
//   }

//   Widget _buildFilterSelection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Select Filter Type',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 15),
//         _buildFilterRadioTile(title: 'Goals Only', value: FilterType.goalsOnly),
//         _buildFilterRadioTile(title: 'Red Card', value: FilterType.redCard),
//         _buildFilterRadioTile(
//           title: 'Favorite player shots',
//           value: FilterType.favoritePlayerShots,
//         ),
//       ],
//     );
//   }

//   Widget _buildSummaryLengthSelection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Select Summary Length',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 15),
//         _buildSummaryRadioTile(title: 'Long', value: SummaryLength.long),
//         _buildSummaryRadioTile(title: 'Short', value: SummaryLength.short),
//       ],
//     );
//   }

//   Widget _buildFilterRadioTile({
//     required String title,
//     required FilterType value,
//   }) {
//     return Theme(
//       data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white70),
//       child: RadioListTile<FilterType>(
//         title: Text(
//           title,
//           style: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         value: value,
//         groupValue: _selectedFilter,
//         onChanged: (FilterType? newValue) {
//           setState(() {
//             _selectedFilter = newValue;
//           });
//         },
//         activeColor: gradientEnd,
//         contentPadding: EdgeInsets.zero,
//       ),
//     );
//   }

//   Widget _buildSummaryRadioTile({
//     required String title,
//     required SummaryLength value,
//   }) {
//     return Theme(
//       data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white70),
//       child: RadioListTile<SummaryLength>(
//         title: Text(
//           title,
//           style: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         value: value,
//         groupValue: _selectedSummaryLength,
//         onChanged: (SummaryLength? newValue) {
//           setState(() {
//             _selectedSummaryLength = newValue;
//           });
//         },
//         activeColor: gradientEnd,
//         contentPadding: EdgeInsets.zero,
//       ),
//     );
//   }

//   Widget _buildStartAnalysisButton() {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [gradientStart, gradientEnd],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: ElevatedButton(
//         onPressed: _isLoading ? null : _startAnalysis,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//         child:
//             _isLoading
//                 ? const SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 3,
//                   ),
//                 )
//                 : const Text(
//                   'Start Analysis',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//       ),
//     );
//   }
// }
///////////////////////////////////////////////////////
///import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:matchifiy/models/Video_Filter.dart';
import 'package:matchifiy/services/user_service.dart';
import 'package:matchifiy/services/app_localizations.dart';
import 'package:matchifiy/widgets/anlysis_resultscreen.dart';

enum FilterType { goalsOnly, redCard, yellowCard }

enum SummaryLength { long, short }

class MatchAnalysisScreen extends StatefulWidget {
  const MatchAnalysisScreen({super.key});

  @override
  State<MatchAnalysisScreen> createState() => _MatchAnalysisScreenState();
}

class _MatchAnalysisScreenState extends State<MatchAnalysisScreen> {
  static const Color inputFieldBg = Color(0xFF28283D);
  static const Color gradientStart = Color(0xFF8A2BE2);
  static const Color gradientEnd = Color(0xFFE0B0FF);

  FilterType? _selectedFilter = FilterType.goalsOnly;
  SummaryLength? _selectedSummaryLength = SummaryLength.long;
  bool _isLoading = false;

  final TextEditingController _videoLinkController = TextEditingController();
  // final TextEditingController _playerNameController = TextEditingController();

  // تحويل الفلتر إلى نص عربي للباكند (ثابت بغض النظر عن لغة التطبيق)
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

  void _startAnalysis() async {
    final loc = AppLocalizations.of(context);
    if (_videoLinkController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.pleaseEnterLink)));
      return;
    }

    setState(() => _isLoading = true);

    final videoFilter = VideoFilterModel(
      url: _videoLinkController.text,
      type: filterToArabic(_selectedFilter!),
      summaryType:
          _selectedSummaryLength == SummaryLength.long ? "طويل" : "قصير",
      // playerName:
      //     _playerNameController.text.isEmpty
      //         ? null
      //         : _playerNameController.text,
    );

    log(jsonEncode(videoFilter.toJson()));

    try {
      await UserService().sendFilter(videoFilter);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${loc.analysisFinished}: ${videoFilter.type}, ${loc.summaryLabel}: ${videoFilter.summaryType}",
          ),
          backgroundColor: gradientStart,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => AnalysisResultScreen(
                video: videoFilter,
                // extractedText: extractedText,
                // يمكنك تمرير الفيديو أو البيانات كاملة إذا عدلت constructor شاشة النتائج
                // videoUrl: videoFilter.url,
                // rawData: response is Map ? response : {},
              ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${loc.errorLabel}: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E2E),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              isArabic ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            loc.matchAnalysis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF1E1E2E),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputSection(
                loc.videoLinkLabel,
                loc.videoLinkHint,
                _videoLinkController,
              ),
              const SizedBox(height: 15),
              // _buildInputSection(
              //   loc.playerNameLabel,
              //   loc.playerNameHint,
              //   _playerNameController,
              // ),
              const SizedBox(height: 30),
              _buildFilterSelection(loc),
              const SizedBox(height: 30),
              _buildSummaryLengthSelection(loc),
              const SizedBox(height: 40),
              _buildStartButton(loc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30),
            fillColor: inputFieldBg,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSelection(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.selectFilterType,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildFilterRadioTile(loc.filterGoals, FilterType.goalsOnly),
        _buildFilterRadioTile(loc.filterRedCard, FilterType.redCard),
        _buildFilterRadioTile(loc.filterYellowCard, FilterType.yellowCard),
      ],
    );
  }

  Widget _buildSummaryLengthSelection(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.selectSummaryLength,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildSummaryRadioTile(loc.summaryLong, SummaryLength.long),
        _buildSummaryRadioTile(loc.summaryShort, SummaryLength.short),
      ],
    );
  }

  Widget _buildFilterRadioTile(String title, FilterType value) {
    return RadioListTile<FilterType>(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      groupValue: _selectedFilter,
      activeColor: gradientEnd,
      onChanged: (v) => setState(() => _selectedFilter = v),
    );
  }

  Widget _buildSummaryRadioTile(String title, SummaryLength value) {
    return RadioListTile<SummaryLength>(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      groupValue: _selectedSummaryLength,
      activeColor: gradientEnd,
      onChanged: (v) => setState(() => _selectedSummaryLength = v),
    );
  }

  Widget _buildStartButton(AppLocalizations loc) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [gradientStart, gradientEnd]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _startAnalysis,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child:
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                  loc.startAnalysis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}
