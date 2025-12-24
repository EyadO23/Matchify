// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/app_localizations.dart';
// import 'package:matchifiy/services/news_service.dart';
// import 'package:matchifiy/widgets/favotite_team_screen.dart';
// import 'package:matchifiy/widgets/match_analysis_screen.dart';

// import 'package:matchifiy/models/team_news_model.dart';
// import 'package:matchifiy/services/favorite_team_service.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final NewsService _api = NewsService();
//   final FavoriteTeamService _favoriteService = FavoriteTeamService();

//   TeamNews? _news;
//   bool _isLoading = false;
//   String? _errorMessage;
//   bool _hasNoFavoriteTeam = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkTeamAndFetchNews();
//   }

//   Future<void> _checkTeamAndFetchNews() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//       _hasNoFavoriteTeam = false;
//     });

//     try {
//       // فحص الفريق المفضل من الباك آند
//       final favoriteTeam = await _favoriteService.getFavoriteTeam();

//       // إذا كانت القيمة null أو فارغة، نظهر واجهة الاختيار
//       if (favoriteTeam == null || favoriteTeam.isEmpty) {
//         setState(() {
//           _hasNoFavoriteTeam = true;
//           _isLoading = false;
//         });
//         return;
//       }

//       // إذا وجدت قيمة، نرسلها لـ api_service لجلب الأخبار
//       final newsData = await _api.getTeamNews(favoriteTeam);

//       setState(() {
//         _news = newsData;
//         _isLoading = false;
//         _hasNoFavoriteTeam = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loc = AppLocalizations.of(context);
//     final isArabic = Localizations.localeOf(context).languageCode == 'ar';

//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E2E),
//       appBar: AppBar(
//         title: Text(isArabic ? "أخبار الرياضة" : "Sports News"),
//         backgroundColor: const Color(0xFF1E1E2E),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _checkTeamAndFetchNews,
//           ),
//         ],
//       ),
//       // إضافة القائمة الجانبية هنا
//       drawer: _buildDrawer(context, isArabic),
//       body:
//           _isLoading
//               ? const Center(
//                 child: CircularProgressIndicator(color: Color(0xFF8A2BE2)),
//               )
//               : _hasNoFavoriteTeam
//               ? _buildNoTeamUI(isArabic)
//               : _errorMessage != null
//               ? _buildErrorUI(isArabic)
//               : _buildNewsContent(isArabic),
//     );
//   }

//   Widget _buildDrawer(BuildContext context, bool isArabic) {
//     return Drawer(
//       backgroundColor: const Color(0xFF1E1E2E),
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF8A2BE2), Color(0xFFE0B0FF)],
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const CircleAvatar(
//                   radius: 35,
//                   backgroundColor: Colors.white24,
//                   child: Icon(Icons.person, color: Colors.white, size: 40),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   isArabic ? "مرحباً بك" : "Welcome",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildDrawerItem(
//             icon: Icons.home,
//             title: isArabic ? "الرئيسية" : "Home",
//             onTap: () => Navigator.pop(context),
//           ),
//           _buildDrawerItem(
//             icon: Icons.analytics,
//             title: isArabic ? "تحليل المباريات" : "Match Analysis",
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const MatchAnalysisScreen(),
//                 ),
//               );
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.favorite,
//             title: isArabic ? "فريقي المفضل" : "Favorite Team",
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const FavoriteTeamScreen(),
//                 ),
//               ).then((_) => _checkTeamAndFetchNews());
//             },
//           ),
//           const Divider(color: Colors.white10),
//           _buildDrawerItem(
//             icon: Icons.logout,
//             title: isArabic ? "تسجيل الخروج" : "Logout",
//             onTap: () {
//               // منطق تسجيل الخروج
//               Navigator.of(
//                 context,
//               ).pushNamedAndRemoveUntil('/login', (route) => false);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: const Color(0xFFE0B0FF)),
//       title: Text(title, style: const TextStyle(color: Colors.white)),
//       onTap: onTap,
//     );
//   }

//   Widget _buildNoTeamUI(bool isArabic) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.favorite_border, color: Colors.white54, size: 80),
//           const SizedBox(height: 16),
//           Text(
//             isArabic
//                 ? "يرجى اختيار فريقك المفضل"
//                 : "Please select your favorite team",
//             style: const TextStyle(color: Colors.white, fontSize: 18),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const FavoriteTeamScreen(),
//                 ),
//               ).then((_) => _checkTeamAndFetchNews());
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF8A2BE2),
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: Text(isArabic ? "اختر الآن" : "Choose Now"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNewsContent(bool isArabic) {
//     if (_news == null) return const SizedBox();
//     return RefreshIndicator(
//       onRefresh: _checkTeamAndFetchNews,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.star, color: Colors.amber, size: 28),
//                 const SizedBox(width: 8),
//                 Text(
//                   _news!.team,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             // مثال لعرض الأخبار
//             _buildNewsItem(
//               "آخر النتائج والتحليلات لمباريات الفريق في الدوري...",
//             ),
//             _buildNewsItem(
//               "تقارير عن إصابات اللاعبين والتشكيل المتوقع للمواجهة القادمة...",
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNewsItem(String text) {
//     return Card(
//       color: const Color(0xFF28283D),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Text(
//           text,
//           style: const TextStyle(color: Colors.white70, fontSize: 16),
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorUI(bool isArabic) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             _errorMessage ?? "Error",
//             style: const TextStyle(color: Colors.white),
//           ),
//           const SizedBox(height: 10),
//           TextButton(
//             onPressed: _checkTeamAndFetchNews,
//             child: const Text("Retry"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:matchifiy/services/app_localizations.dart';
import 'package:matchifiy/services/news_service.dart';
import 'package:matchifiy/widgets/favotite_team_screen.dart';
import 'package:matchifiy/widgets/match_analysis_screen.dart';
import 'package:matchifiy/models/team_news_model.dart';
import 'package:matchifiy/services/favorite_team_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _api = NewsService();
  final FavoriteTeamService _favoriteService = FavoriteTeamService();

  TeamNews? _news;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasNoFavoriteTeam = false;

  @override
  void initState() {
    super.initState();
    _checkTeamAndFetchNews();
  }

  // دالة فحص الفريق وجلب الأخبار من الباك آند
  Future<void> _checkTeamAndFetchNews() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _hasNoFavoriteTeam = false;
    });

    try {
      // 1. جلب الفريق المفضل من الخدمة
      final favoriteTeam = await _favoriteService.getFavoriteTeam();

      if (favoriteTeam == null || favoriteTeam.isEmpty) {
        if (mounted) {
          setState(() {
            _hasNoFavoriteTeam = true;
            _isLoading = false;
          });
        }
        return;
      }

      // 2. جلب الأخبار الخاصة بهذا الفريق
      final newsData = await _api.getTeamNews(favoriteTeam);

      if (mounted) {
        setState(() {
          _news = newsData;
          _isLoading = false;
          _hasNoFavoriteTeam = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // اللون الداكن العصري
      appBar: AppBar(
        title: Text(
          isArabic ? "أخبار الرياضة" : "Sports News",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blueAccent),
            onPressed: _checkTeamAndFetchNews,
          ),
        ],
      ),
      drawer: _buildDrawer(context, isArabic),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
              : _hasNoFavoriteTeam
              ? _buildNoTeamUI(isArabic)
              : _errorMessage != null
              ? _buildErrorUI(isArabic)
              : _buildNewsContent(isArabic),
    );
  }

  // بناء قائمة الأخبار الديناميكية
  Widget _buildNewsContent(bool isArabic) {
    if (_news == null || _news!.articles.isEmpty) {
      return Center(
        child: Text(
          isArabic ? "لا توجد أخبار حالياً" : "No news available",
          style: const TextStyle(color: Colors.white54),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _checkTeamAndFetchNews,
      color: Colors.blueAccent,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        itemCount: _news!.articles.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // عرض اسم الفريق المفضل في الأعلى كعنوان
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      _news!.team,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // جلب المقال الحالي من القائمة القادمة من الباك آند
          final article = _news!.articles[index - 1];
          return _buildEnhancedNewsCard(article, isArabic);
        },
      ),
    );
  }

  // ويدجت تصميم بطاقة الخبر (نفس التصميم الذي أعجبك)
  Widget _buildEnhancedNewsCard(dynamic article, bool isArabic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // منطق فتح تفاصيل الخبر إذا توفرت
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.blueAccent.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          article.source ?? (isArabic ? "مصدر" : "Source"),
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.share_outlined,
                        color: Colors.white.withOpacity(0.3),
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    article.title ?? "",
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white.withOpacity(0.4),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        article.publishedAt ?? "",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white.withOpacity(0.2),
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // بناء القائمة الجانبية (Drawer)
  Widget _buildDrawer(BuildContext context, bool isArabic) {
    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8A2BE2), Color(0xFFE0B0FF)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 10),
                Text(
                  isArabic ? "مرحباً بك" : "Welcome",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            title: isArabic ? "الرئيسية" : "Home",
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            icon: Icons.analytics,
            title: isArabic ? "تحليل المباريات" : "Match Analysis",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MatchAnalysisScreen(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.favorite,
            title: isArabic ? "فريقي المفضل" : "Favorite Team",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteTeamScreen(),
                ),
              ).then((_) => _checkTeamAndFetchNews());
            },
          ),
          const Divider(color: Colors.white10),
          _buildDrawerItem(
            icon: Icons.logout,
            title: isArabic ? "تسجيل الخروج" : "Logout",
            onTap:
                () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE0B0FF)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildNoTeamUI(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, color: Colors.white54, size: 80),
          const SizedBox(height: 16),
          Text(
            isArabic
                ? "يرجى اختيار فريقك المفضل"
                : "Please select your favorite team",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteTeamScreen(),
                ),
              ).then((_) => _checkTeamAndFetchNews());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A2BE2),
            ),
            child: Text(
              isArabic ? "اختر الآن" : "Choose Now",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorUI(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _errorMessage ?? "Error",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _checkTeamAndFetchNews,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
