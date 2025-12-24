// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/app_localizations.dart';

// class FavoriteTeamScreen extends StatefulWidget {
//   const FavoriteTeamScreen({super.key});

//   @override
//   State<FavoriteTeamScreen> createState() => _FavoriteTeamScreenState();
// }

// class _FavoriteTeamScreenState extends State<FavoriteTeamScreen> {
//   // قائمة الفرق المنظمة
//   final List<String> _teams = [
//     // أوروبا - إسبانيا
//     "Real Madrid", "FC Barcelona", "Atletico Madrid", "Sevilla FC",
//     // أوروبا - إنجلترا
//     "Manchester City",
//     "Liverpool FC",
//     "Arsenal FC",
//     "Manchester United",
//     "Chelsea FC",
//     "Tottenham Hotspur",
//     // أوروبا - ألمانيا
//     "Bayern Munich", "Borussia Dortmund", "Bayer Leverkusen",
//     // أوروبا - إيطاليا
//     "AC Milan", "Inter Milan", "Juventus", "AS Roma", "SSC Napoli",
//     // أوروبا - فرنسا
//     "Paris Saint-Germain", "Olympique Marseille",
//     // السعودية
//     "Al Hilal", "Al Nassr", "Al Ittihad", "Al Ahli Saudi", "Al Shabab",
//     // مصر
//     "Al Ahly SC", "Zamalek SC", "Pyramids FC",
//     // المغرب
//     "Wydad AC", "Raja CA", "AS FAR",
//     // تونس
//     "Esperance ST", "Club Africain", "Etoile du Sahel",
//     // الإمارات
//     "Al Ain FC", "Al Wahda", "Shabab Al Ahli",
//     // قطر
//     "Al Sadd SC", "Al Duhail",
//   ];
//   // final List<String> _teams = [
//   //   "Real Madrid",
//   //   "FC Barcelona",
//   //   "Manchester City",
//   //   "Liverpool FC",
//   //   "Manchester United",
//   //   "Arsenal FC",
//   //   "Bayern Munich",
//   //   "AC Milan",
//   //   "Inter Milan",
//   //   "Juventus",
//   //   "Paris Saint-Germain",
//   //   "Al Hilal",
//   //   "Al Nassr",
//   //   "Al Ahly SC",
//   //   "Zamalek SC",
//   // ];

//   String? _selectedTeam;
//   bool _isUpdating = false;
//   bool _hasFavoriteTeam = false; // سنقوم بمحاكاة وجود فريق مسبقاً

//   @override
//   void initState() {
//     super.initState();
//     _checkExistingFavorite();
//   }

//   // محاكاة جلب الفريق المفضل الحالي من الباك اند
//   void _checkExistingFavorite() async {
//     // هنا يتم استدعاء API لاحقاً
//     await Future.delayed(const Duration(milliseconds: 500));
//     setState(() {
//       // محاكاة: لنفترض أن المستخدم لم يحدد فريقاً بعد
//       _hasFavoriteTeam = false;
//     });
//   }

//   void _handleSaveTeam() async {
//     if (_selectedTeam == null) return;

//     setState(() => _isUpdating = true);

//     // محاكاة إرسال البيانات للباك اند
//     await Future.delayed(const Duration(seconds: 2));

//     if (mounted) {
//       setState(() {
//         _isUpdating = false;
//         _hasFavoriteTeam = true;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Success: Favorite team updated!"),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loc = AppLocalizations.of(context);
//     final isArabic = Localizations.localeOf(context).languageCode == 'ar';

//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E2E),
//       appBar: AppBar(
//         title: Text(isArabic ? "الفريق المفضل" : "Favorite Team"),
//         backgroundColor: const Color(0xFF1E1E2E),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               isArabic
//                   ? "اختر فريقك المفضل لتخصيص تجربتك"
//                   : "Select your favorite team to personalize your experience",
//               style: const TextStyle(color: Colors.white70, fontSize: 16),
//             ),
//             const SizedBox(height: 30),

//             // قائمة منسدلة أنيقة
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF28283D),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.white12),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   isExpanded: true,
//                   dropdownColor: const Color(0xFF28283D),
//                   hint: Text(
//                     isArabic ? "اختر الفريق" : "Select Team",
//                     style: const TextStyle(color: Colors.white54),
//                   ),
//                   value: _selectedTeam,
//                   items:
//                       _teams.map((String team) {
//                         return DropdownMenuItem<String>(
//                           value: team,
//                           child: Text(
//                             team,
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         );
//                       }).toList(),
//                   onChanged: (value) {
//                     setState(() => _selectedTeam = value);
//                   },
//                 ),
//               ),
//             ),

//             const SizedBox(height: 40),

//             // الزر الديناميكي
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed:
//                     _selectedTeam == null || _isUpdating
//                         ? null
//                         : _handleSaveTeam,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF8A2BE2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child:
//                     _isUpdating
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : Text(
//                           _hasFavoriteTeam
//                               ? (isArabic
//                                   ? "تغيير الفريق المفضل"
//                                   : "Change Favorite Team")
//                               : (isArabic
//                                   ? "حفظ الفريق المفضل"
//                                   : "Save Favorite Team"),
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:matchifiy/services/favorite_team_service.dart';

class FavoriteTeamScreen extends StatefulWidget {
  const FavoriteTeamScreen({super.key});

  @override
  State<FavoriteTeamScreen> createState() => _FavoriteTeamScreenState();
}

class _FavoriteTeamScreenState extends State<FavoriteTeamScreen> {
  final FavoriteTeamService _favoriteService = FavoriteTeamService();

  String? _currentFavoriteTeam;
  String? _selectedTeam;
  bool _isLoading = true;
  bool _isSaving = false;

  // قائمة تجريبية للأندية
  final List<String> _teams = [
    "Real Madrid",
    "Barcelona",
    "Manchester City",
    "Liverpool",
    "Bayern Munich",
    "Al Hilal",
    "Al Nassr",
    "Al Ahly",
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentTeam();
  }

  Future<void> _loadCurrentTeam() async {
    try {
      final team = await _favoriteService.getFavoriteTeam();
      setState(() {
        _currentFavoriteTeam = (team != null && team.isNotEmpty) ? team : null;
        _selectedTeam = _currentFavoriteTeam;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveTeam() async {
    if (_selectedTeam == null) return;

    setState(() => _isSaving = true);
    try {
      await _favoriteService.saveFavoriteTeam(_selectedTeam!);
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("تمت العملية بنجاح")));
      Navigator.pop(context);
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("خطأ: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // تحديد نص الزر بناءً على وجود فريق مفضل مسبقاً أم لا
    final String buttonText =
        _currentFavoriteTeam == null
            ? (isArabic ? "حفظ الفريق" : "Save Team")
            : (isArabic ? "تعديل الفريق" : "Edit Team");

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        title: Text(isArabic ? "فريقك المفضل" : "Favorite Team"),
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF8A2BE2)),
              )
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isArabic
                          ? "اختر ناديك المفضل لمتابعة أخباره:"
                          : "Select your favorite club:",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _teams.length,
                        itemBuilder: (context, index) {
                          final team = _teams[index];
                          final isSelected = _selectedTeam == team;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFF8A2BE2).withOpacity(0.2)
                                      : const Color(0xFF28283D),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? const Color(0xFF8A2BE2)
                                        : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                team,
                                style: const TextStyle(color: Colors.white),
                              ),
                              leading: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color:
                                    isSelected
                                        ? const Color(0xFF8A2BE2)
                                        : Colors.white24,
                              ),
                              onTap: () => setState(() => _selectedTeam = team),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveTeam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A2BE2),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          _isSaving
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                buttonText,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ],
                ),
              ),
    );
  }
}
