// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:matchifiy/main.dart';
// import 'package:matchifiy/models/team_news_model.dart';
// import 'package:matchifiy/services/news_service.dart';
// import 'package:matchifiy/services/token_storage.dart';
// import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
// import 'package:matchifiy/widgets/change_password_screen.dart';
// import 'package:matchifiy/widgets/favotite_team_screen.dart';
// import 'package:matchifiy/widgets/match_analysis_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final NewsService _api = NewsService();

//   TeamNews? _news;
//   bool _isLoading = false;
//   String? _errorMessage;

//   String _userName = "user";
//   String _userEmail = "user@gmail.com";
//   String _usernameHandle = "user12";

//   @override
//   void initState() {
//     super.initState();
//     _loadUserFromStorage();
//     _fetchNews();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   // Future<void> _loadUserFromStorage() async {
//   //   final userData = await TokenStorage.getUserData();
//   //   log(userData.toString());
//   //   setState(() {
//   //     _userName = userData['name'] ?? "user";
//   //     _userEmail = userData['email'] ?? "user@gmail.com";
//   //     _usernameHandle = userData['username'] ?? "user12";
//   //   });
//   // }
//   Future<void> _loadUserFromStorage() async {
//     final userData = await TokenStorage.getUserData();

//     if (!mounted) return;

//     setState(() {
//       _userName = userData['name'] ?? "user";
//       _userEmail = userData['email'] ?? "user@gmail.com";
//       _usernameHandle = userData['username'] ?? "user12";
//     });
//   }

//   Future<void> _fetchNews() async {
//     if (!mounted) return;

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final TeamNews? newsData = await _api.getNews();
//       if (newsData != null) {
//         log(
//           "News fetched: Team=${newsData.team?.name}, Articles count=${newsData.articles.length}",
//         );
//       } else {
//         log("No news received");
//       }

//       setState(() {
//         _news = newsData;
//         _isLoading = false;
//       });
//     } catch (e) {
//       log("Error fetching news: $e");
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.toString();
//       });
//     }
//   }

//   void _toggleLanguage() {
//     final currentLocale = Localizations.localeOf(context);
//     final newLocale =
//         currentLocale.languageCode == 'ar'
//             ? const Locale('en', '')
//             : const Locale('ar', '');
//     MyApp.of(context).setLocale(newLocale);
//   }

//   void _changeLanguage() => _toggleLanguage();

//   @override
//   Widget build(BuildContext context) {
//     final isArabic = Localizations.localeOf(context).languageCode == 'ar';
//     return Directionality(
//       textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
//       child: CustomBackgroundScaffold(
//         appBar: AppBar(
//           title: Text(
//             isArabic ? "أخبار الرياضة" : "Sports News",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           centerTitle: true,
//           iconTheme: const IconThemeData(color: Colors.white),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.refresh, color: Colors.blueAccent),
//               onPressed: _fetchNews,
//             ),
//           ],
//         ),
//         drawer: _buildDrawer(context, isArabic),
//         body:
//             _isLoading
//                 ? const Center(
//                   child: CircularProgressIndicator(color: Colors.blueAccent),
//                 )
//                 : _errorMessage != null
//                 ? _buildErrorUI(isArabic)
//                 : _buildNewsContentGroupedByTeam(isArabic),
//       ),
//     );
//   }

//   Widget _buildDrawer(BuildContext context, bool isArabic) {
//     return Drawer(
//       backgroundColor: const Color.fromARGB(255, 27, 28, 28),
//       child: Column(
//         children: [
//           UserAccountsDrawerHeader(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color.fromARGB(255, 114, 116, 228),
//                   Color.fromARGB(255, 146, 163, 208),
//                 ],
//               ),
//             ),
//             currentAccountPicture: CircleAvatar(
//               backgroundColor: Colors.white24,
//               child: Text(
//                 _userName[0].toUpperCase(),
//                 style: const TextStyle(
//                   fontSize: 32,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             accountName: Text(
//               _userName,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             accountEmail: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(_userEmail),
//                 Text(
//                   _usernameHandle,
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.5),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _buildDrawerItem(
//                   Icons.home_rounded,
//                   isArabic ? "الرئيسية" : "Home",
//                   () => Navigator.pop(context),
//                 ),
//                 _buildDrawerItem(
//                   Icons.analytics_outlined,
//                   isArabic ? "تحليل المباريات" : "Match Analysis",
//                   () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const MatchAnalysisScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildDrawerItem(
//                   Icons.favorite_rounded,
//                   isArabic ? "فريقي المفضل" : "Favorite Team",
//                   () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const FavoriteTeamScreen(),
//                       ),
//                     ).then((_) => _fetchNews());
//                   },
//                 ),
//                 _buildDrawerItem(
//                   Icons.language_rounded,
//                   isArabic ? 'تغيير اللغة' : 'Change Language',
//                   () {
//                     Navigator.pop(context);
//                     _changeLanguage();
//                   },
//                 ),
//                 const Divider(color: Colors.white10, indent: 20, endIndent: 20),
//                 _buildDrawerItem(
//                   Icons.lock_reset_rounded,
//                   isArabic ? "تغيير كلمة المرور" : "Change Password",
//                   () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ChangePasswordScreen(),
//                       ),
//                     );
//                   },
//                   iconColor: Colors.amberAccent,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: ElevatedButton.icon(
//               onPressed: () async {
//                 await TokenStorage.deleteToken();
//                 if (context.mounted)
//                   Navigator.of(
//                     context,
//                   ).pushNamedAndRemoveUntil('/login', (route) => false);
//               },
//               icon: const Icon(Icons.logout_rounded),
//               label: Text(isArabic ? "تسجيل الخروج" : "Logout"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent.withOpacity(0.1),
//                 foregroundColor: Colors.redAccent,
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 0,
//               ),
//             ),
//           ),
//           const SizedBox(height: 50),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//     IconData icon,
//     String title,
//     VoidCallback onTap, {
//     Color? iconColor,
//   }) {
//     return ListTile(
//       leading: Icon(
//         icon,
//         color: iconColor ?? const Color.fromARGB(255, 114, 116, 228),
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(color: Colors.white, fontSize: 16),
//       ),
//       onTap: onTap,
//     );
//   }

//   Widget _buildNewsContentGroupedByTeam(bool isArabic) {
//     if (_news == null || _news!.articles.isEmpty) {
//       return Center(
//         child: Text(
//           isArabic ? "لا توجد أخبار" : "No news",
//           style: const TextStyle(color: Colors.white54),
//         ),
//       );
//     }

//     // فصل الأخبار حسب الفريق
//     Map<int, List<dynamic>> teamArticlesMap = {};
//     for (var article in _news!.articles) {
//       final teamId = article.teamId ?? 0;
//       if (!teamArticlesMap.containsKey(teamId)) {
//         teamArticlesMap[teamId] = [];
//       }
//       teamArticlesMap[teamId]!.add(article);
//     }

//     return RefreshIndicator(
//       onRefresh: _fetchNews,
//       child: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         children:
//             teamArticlesMap.entries.map((entry) {
//               final articles = entry.value;
//               final teamName = articles.first.teamName ?? '';
//               final teamLogo = articles.first.teamLogo ?? '';

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (teamName.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       child: Row(
//                         children: [
//                           // if (teamLogo.isNotEmpty)
//                           //   Image.network(
//                           //     teamLogo,
//                           //     height: 30,
//                           //     width: 30,
//                           //     errorBuilder:
//                           //         (_, __, ___) => const SizedBox.shrink(),
//                           //   ),
//                           // const SizedBox(width: 8),
//                           Text(
//                             teamName,
//                             style: const TextStyle(
//                               color: Colors.blueAccent,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ...articles.map(
//                     (article) => _buildNewsCard(article, isArabic),
//                   ),
//                 ],
//               );
//             }).toList(),
//       ),
//     );
//   }

//   Widget _buildNewsCard(dynamic article, bool isArabic) {
//     final imageUrl = article.imageUrl ?? '';
//     final title = article.title ?? '';
//     final description = article.description ?? '';
//     final publishedAt = article.publishedAt ?? '';

//     return Container(
//       margin: const EdgeInsets.only(bottom: 18),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(22),
//       ),
//       padding: const EdgeInsets.all(18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (imageUrl.isNotEmpty)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder:
//                     (_, __, ___) => Container(
//                       height: 150,
//                       color: Colors.white12,
//                       child: const Icon(
//                         Icons.broken_image,
//                         color: Colors.white30,
//                       ),
//                     ),
//               ),
//             ),
//           const SizedBox(height: 12),
//           Text(
//             title,
//             textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: 8),
//           if (description.isNotEmpty)
//             Text(
//               description,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 14,
//                 height: 1.4,
//               ),
//             ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Icon(
//                 Icons.access_time,
//                 color: Colors.white.withOpacity(0.4),
//                 size: 14,
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 publishedAt,
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.4),
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorUI(bool isArabic) => Center(
//     child: Text(
//       _errorMessage ?? "Error",
//       style: const TextStyle(color: Colors.white),
//     ),
//   );
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:matchifiy/main.dart';
import 'package:matchifiy/models/team_news_model.dart';
import 'package:matchifiy/services/news_service.dart';
import 'package:matchifiy/services/token_storage.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
import 'package:matchifiy/widgets/change_password_screen.dart';
import 'package:matchifiy/widgets/favotite_team_screen.dart';
import 'package:matchifiy/widgets/match_analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _api = NewsService();

  TeamNews? _news;
  bool _isLoading = false;
  String? _errorMessage;

  String _userName = "user";
  String _userEmail = "user@gmail.com";
  String _usernameHandle = "user12";

  @override
  void initState() {
    super.initState();
    _loadUserFromStorage();
    _fetchNews();
  }

  // ================= USER =================
  Future<void> _loadUserFromStorage() async {
    final userData = await TokenStorage.getUserData();

    if (!mounted) return;

    setState(() {
      _userName = userData['name'] ?? "user";
      _userEmail = userData['email'] ?? "user@gmail.com";
      _usernameHandle = userData['username'] ?? "user12";
    });
  }

  // ================= NEWS =================
  Future<void> _fetchNews() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final TeamNews? newsData = await _api.getNews();

      if (!mounted) return;

      log("News fetched: articles=${newsData?.articles.length ?? 0}");

      setState(() {
        _news = newsData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      log("Error fetching news: $e");

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // ================= LANGUAGE =================
  void _toggleLanguage() {
    final currentLocale = Localizations.localeOf(context);
    final newLocale =
        currentLocale.languageCode == 'ar'
            ? const Locale('en')
            : const Locale('ar');
    MyApp.of(context).setLocale(newLocale);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: CustomBackgroundScaffold(
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
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.blueAccent),
              onPressed: _fetchNews,
            ),
          ],
        ),
        drawer: _buildDrawer(isArabic),
        body: _buildBody(isArabic),
      ),
    );
  }

  Widget _buildBody(bool isArabic) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorUI();
    }

    return _buildNewsContent(isArabic);
  }

  // ================= DRAWER =================
  Widget _buildDrawer(bool isArabic) {
    return Drawer(
      backgroundColor: const Color(0xFF1B1C1C),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7274E4), Color(0xFF92A3D0)],
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
                  isArabic ? "تحليل المباريات" : "Match Analysis",
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MatchAnalysisScreen(),
                      ),
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
                    ).then((_) {
                      if (mounted) _fetchNews();
                    });
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
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () async {
                await TokenStorage.deleteToken();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (_) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: Text(isArabic ? "تسجيل الخروج" : "Logout"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  // ================= NEWS UI =================
  Widget _buildNewsContent(bool isArabic) {
    if (_news == null || _news!.articles.isEmpty) {
      return Center(
        child: Text(
          isArabic ? "لا توجد أخبار" : "No news available",
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchNews,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _news!.articles.length,
        itemBuilder: (context, index) {
          final article = _news!.articles[index];
          return _buildNewsCard(article, isArabic);
        },
      ),
    );
  }

  Widget _buildNewsCard(dynamic article, bool isArabic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((article.teamName ?? '').isNotEmpty)
            Text(
              article.teamName!,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            article.title ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if ((article.description ?? '').isNotEmpty)
            Text(
              article.description!,
              style: const TextStyle(color: Colors.white70),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Text(
        _errorMessage ?? "Error",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

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

//   // دالة فحص الفريق وجلب الأخبار من الباك آند
//   Future<void> _checkTeamAndFetchNews() async {
//     if (!mounted) return;
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//       _hasNoFavoriteTeam = false;
//     });

//     try {
//       // 1. جلب الفريق المفضل من الخدمة
//       final favoriteTeam = await _favoriteService.getFavoriteTeam();

//       if (favoriteTeam == null || favoriteTeam.isEmpty) {
//         if (mounted) {
//           setState(() {
//             _hasNoFavoriteTeam = true;
//             _isLoading = false;
//           });
//         }
//         return;
//       }

//       // 2. جلب الأخبار الخاصة بهذا الفريق
//       final newsData = await _api.getTeamNews(favoriteTeam);

//       if (mounted) {
//         setState(() {
//           _news = newsData;
//           _isLoading = false;
//           _hasNoFavoriteTeam = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = e.toString();
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isArabic = Localizations.localeOf(context).languageCode == 'ar';

//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A), // اللون الداكن العصري
//       appBar: AppBar(
//         title: Text(
//           isArabic ? "أخبار الرياضة" : "Sports News",
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.blueAccent),
//             onPressed: _checkTeamAndFetchNews,
//           ),
//         ],
//       ),
//       drawer: _buildDrawer(context, isArabic),
//       body:
//           _isLoading
//               ? const Center(
//                 child: CircularProgressIndicator(color: Colors.blueAccent),
//               )
//               : _hasNoFavoriteTeam
//               ? _buildNoTeamUI(isArabic)
//               : _errorMessage != null
//               ? _buildErrorUI(isArabic)
//               : _buildNewsContent(isArabic),
//     );
//   }

//   // بناء قائمة الأخبار الديناميكية
//   Widget _buildNewsContent(bool isArabic) {
//     if (_news == null || _news!.articles.isEmpty) {
//       return Center(
//         child: Text(
//           isArabic ? "لا توجد أخبار حالياً" : "No news available",
//           style: const TextStyle(color: Colors.white54),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _checkTeamAndFetchNews,
//       color: Colors.blueAccent,
//       child: ListView.builder(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         physics: const BouncingScrollPhysics(),
//         itemCount: _news!.articles.length + 1,
//         itemBuilder: (context, index) {
//           if (index == 0) {
//             // عرض اسم الفريق المفضل في الأعلى كعنوان
//             return Padding(
//               padding: const EdgeInsets.only(top: 8, bottom: 20),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.blueAccent.withOpacity(0.2),
//                       Colors.transparent,
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.stars, color: Colors.amber, size: 28),
//                     const SizedBox(width: 12),
//                     Text(
//                       _news!.team,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           // جلب المقال الحالي من القائمة القادمة من الباك آند
//           final article = _news!.articles[index - 1];
//           return _buildEnhancedNewsCard(article, isArabic);
//         },
//       ),
//     );
//   }

//   // ويدجت تصميم بطاقة الخبر (نفس التصميم الذي أعجبك)
//   Widget _buildEnhancedNewsCard(dynamic article, bool isArabic) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 18),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(color: Colors.white.withOpacity(0.05)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(22),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () {
//               // منطق فتح تفاصيل الخبر إذا توفرت
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(18.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.blueAccent.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(
//                             color: Colors.blueAccent.withOpacity(0.3),
//                           ),
//                         ),
//                         child: Text(
//                           article.source ?? (isArabic ? "مصدر" : "Source"),
//                           style: const TextStyle(
//                             color: Colors.blueAccent,
//                             fontSize: 11,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.share_outlined,
//                         color: Colors.white.withOpacity(0.3),
//                         size: 18,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 14),
//                   Text(
//                     article.title ?? "",
//                     textDirection:
//                         isArabic ? TextDirection.rtl : TextDirection.ltr,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       height: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.access_time,
//                         color: Colors.white.withOpacity(0.4),
//                         size: 14,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         article.publishedAt ?? "",
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.4),
//                           fontSize: 12,
//                         ),
//                       ),
//                       const Spacer(),
//                       Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         color: Colors.white.withOpacity(0.2),
//                         size: 14,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // بناء القائمة الجانبية (Drawer)
//   Widget _buildDrawer(BuildContext context, bool isArabic) {
//     return Drawer(
//       backgroundColor: const Color(0xFF0F172A),
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
//             onTap:
//                 () => Navigator.of(
//                   context,
//                 ).pushNamedAndRemoveUntil('/login', (route) => false),
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
//             ),
//             child: Text(
//               isArabic ? "اختر الآن" : "Choose Now",
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
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
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:matchifiy/main.dart';
// import 'package:matchifiy/models/team_news_model.dart';
// import 'package:matchifiy/services/app_localizations.dart';
// import 'package:matchifiy/services/news_service.dart';
// import 'package:matchifiy/services/token_storage.dart';
// import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
// import 'package:matchifiy/widgets/change_password_screen.dart';
// import 'package:matchifiy/widgets/favotite_team_screen.dart';
// import 'package:matchifiy/widgets/match_analysis_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final NewsService _api = NewsService();

//   TeamNews? _news;
//   bool _isLoading = false;
//   String? _errorMessage;

//   String _userName = "user";
//   String _userEmail = "user@gmail.com";
//   String _usernameHandle = "user12";

//   @override
//   void initState() {
//     super.initState();
//     _loadUserFromStorage();
//     _fetchNews();
//   }

//   void _toggleLanguage() {
//     final currentLocale = Localizations.localeOf(context);
//     final newLocale =
//         currentLocale.languageCode == 'ar'
//             ? const Locale('en', '')
//             : const Locale('ar', '');
//     MyApp.of(context).setLocale(newLocale);
//   }

//   void _changeLanguage() => _toggleLanguage();

//   Future<void> _loadUserFromStorage() async {
//     final userData = await TokenStorage.getUserData();
//     log(userData.toString());
//     setState(() {
//       _userName = userData['name'] ?? "user";
//       _userEmail = userData['email'] ?? "user@gmail.com";
//       _usernameHandle = userData['username'] ?? "user12";
//     });
//   }

//   Future<void> _fetchNews() async {
//     if (!mounted) return;

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       // استدعاء الأخبار مع الفريق المفضل مباشرة
//       final TeamNews? newsData = await _api.getNews(); // بدون ID

//       // log("News Data: ${newsData?.toJson() ?? 'No news'}");

//       setState(() {
//         _news = newsData;
//         _isLoading = false;
//       });
//     } catch (e) {
//       log("Error fetching news: $e");
//       setState(() {
//         _isLoading = false;
//         _errorMessage = e.toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isArabic = Localizations.localeOf(context).languageCode == 'ar';
//     return Directionality(
//       textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
//       child: CustomBackgroundScaffold(
//         appBar: AppBar(
//           title: Text(
//             isArabic ? "أخبار الرياضة" : "Sports News",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           centerTitle: true,
//           iconTheme: const IconThemeData(color: Colors.white),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.refresh, color: Colors.blueAccent),
//               onPressed: _fetchNews,
//             ),
//           ],
//         ),
//         drawer: _buildEnhancedDrawer(context, isArabic),
//         body:
//             _isLoading
//                 ? const Center(
//                   child: CircularProgressIndicator(color: Colors.blueAccent),
//                 )
//                 : _errorMessage != null
//                 ? _buildErrorUI(isArabic)
//                 : _buildNewsContent(isArabic),
//       ),
//     );
//   }

//   Widget _buildEnhancedDrawer(BuildContext context, bool isArabic) {
//     return Drawer(
//       backgroundColor: const Color.fromARGB(255, 27, 28, 28),
//       child: Column(
//         children: [
//           UserAccountsDrawerHeader(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color.fromARGB(255, 114, 116, 228),
//                   Color.fromARGB(255, 146, 163, 208),
//                 ],
//               ),
//             ),
//             currentAccountPicture: CircleAvatar(
//               backgroundColor: Colors.white24,
//               child: Text(
//                 _userName[0].toUpperCase(),
//                 style: const TextStyle(
//                   fontSize: 32,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             accountName: Text(
//               _userName,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             accountEmail: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(_userEmail),
//                 Text(
//                   _usernameHandle,
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.5),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _buildDrawerItem(
//                   icon: Icons.home_rounded,
//                   title: isArabic ? "الرئيسية" : "Home",
//                   onTap: () => Navigator.pop(context),
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.analytics_outlined,
//                   title: isArabic ? "تحليل المباريات" : "Match Analysis",
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const MatchAnalysisScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.favorite_rounded,
//                   title: isArabic ? "فريقي المفضل" : "Favorite Team",
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const FavoriteTeamScreen(),
//                       ),
//                     ).then((_) => _fetchNews());
//                   },
//                 ),
//                 _buildDrawerItem(
//                   icon: Icons.language_rounded,
//                   title: isArabic ? 'تغيير اللغة' : 'Change Language',
//                   onTap: () {
//                     Navigator.pop(context);
//                     _changeLanguage();
//                   },
//                 ),
//                 const Divider(color: Colors.white10, indent: 20, endIndent: 20),
//                 _buildDrawerItem(
//                   icon: Icons.lock_reset_rounded,
//                   title: isArabic ? "تغيير كلمة المرور" : "Change Password",
//                   iconColor: Colors.amberAccent,
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const ChangePasswordScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: ElevatedButton.icon(
//               onPressed: () async {
//                 await TokenStorage.deleteToken();
//                 if (context.mounted)
//                   Navigator.of(
//                     context,
//                   ).pushNamedAndRemoveUntil('/login', (route) => false);
//               },
//               icon: const Icon(Icons.logout_rounded),
//               label: Text(isArabic ? "تسجيل الخروج" : "Logout"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent.withOpacity(0.1),
//                 foregroundColor: Colors.redAccent,
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 0,
//               ),
//             ),
//           ),
//           const SizedBox(height: 50),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? iconColor,
//   }) {
//     return ListTile(
//       leading: Icon(
//         icon,
//         color: iconColor ?? const Color.fromARGB(255, 114, 116, 228),
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(color: Colors.white, fontSize: 16),
//       ),
//       onTap: onTap,
//     );
//   }

//   Widget _buildNewsContent(bool isArabic) {
//     if (_news == null || _news!.articles.isEmpty) {
//       return Center(
//         child: Text(
//           isArabic ? "لا توجد أخبار" : "No news",
//           style: const TextStyle(color: Colors.white54),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _fetchNews,
//       child: ListView.builder(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         itemCount: _news!.articles.length + 1,
//         itemBuilder: (context, index) {
//           if (index == 0) {
//             final teamName = _news!.team?.name ?? '';
//             if (teamName.isEmpty) return const SizedBox.shrink();
//             return Padding(
//               padding: const EdgeInsets.only(top: 8, bottom: 20),
//               child: Text(
//                 teamName,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             );
//           }

//           final article = _news!.articles[index - 1];
//           return _buildEnhancedNewsCard(article, isArabic);
//         },
//       ),
//     );
//   }

//   Widget _buildEnhancedNewsCard(dynamic article, bool isArabic) {
//     final imageUrl = article.imageUrl ?? '';
//     final title = article.title ?? '';
//     final description = article.description ?? '';
//     final publishedAt = article.publishedAt ?? '';

//     return Container(
//       margin: const EdgeInsets.only(bottom: 18),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(22),
//       ),
//       padding: const EdgeInsets.all(18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (imageUrl.isNotEmpty)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder:
//                     (_, __, ___) => Container(
//                       height: 150,
//                       color: Colors.white12,
//                       child: const Icon(
//                         Icons.broken_image,
//                         color: Colors.white30,
//                       ),
//                     ),
//               ),
//             ),
//           const SizedBox(height: 12),
//           Text(
//             title,
//             textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: 8),
//           if (description.isNotEmpty)
//             Text(
//               description,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 14,
//                 height: 1.4,
//               ),
//             ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Icon(
//                 Icons.access_time,
//                 color: Colors.white.withOpacity(0.4),
//                 size: 14,
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 publishedAt,
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.4),
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorUI(bool isArabic) => Center(
//     child: Text(
//       _errorMessage ?? "Error",
//       style: const TextStyle(color: Colors.white),
//     ),
//   );
// }
