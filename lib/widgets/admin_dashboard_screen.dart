import 'package:flutter/material.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
import 'package:matchifiy/widgets/reports_analytics_screen.dart';
import 'package:matchifiy/main.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return CustomBackgroundScaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? "لوحة تحكم الإدارة" : "Admin Dashboard",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            tooltip: isArabic ? "English" : "العربية",
            onPressed: () {
              final newLocale =
                  isArabic ? const Locale('en') : const Locale('ar');
              MyApp.of(context).setLocale(newLocale);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              isArabic ? "مرحباً بك، أيها المسؤول" : "Welcome, Administrator",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 2.5,
                mainAxisSpacing: 20,
                children: [
                  _buildAdminCard(
                    context,
                    title: isArabic ? "إدارة المستخدمين" : "User Management",
                    subtitle:
                        isArabic
                            ? "عرض، حذف، والتحكم في حسابات النظام"
                            : "View, delete, and manage system users",
                    icon: Icons.group_outlined,
                    color: const Color(0xFF7274E4),
                    onTap:
                        () => Navigator.pushNamed(context, '/user_management'),
                  ),
                  _buildAdminCard(
                    context,
                    title: isArabic ? "تقارير النظام" : "System Reports",
                    subtitle:
                        isArabic
                            ? "الإحصائيات، الفيديوهات، والنشاطات"
                            : "Statistics, videos, and activities",
                    icon: Icons.bar_chart_rounded,
                    color: const Color(0xFF4E94E4),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportsAnalyticsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    title: isArabic ? "تسجيل الخروج" : "Logout",
                    subtitle:
                        isArabic
                            ? "إنهاء الجلسة الحالية والعودة للأمان"
                            : "End the current session securely",
                    icon: Icons.logout_rounded,
                    color: Colors.redAccent,
                    onTap: () => _showLogoutDialog(context, isArabic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                icon,
                size: 100,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              isArabic ? "تسجيل الخروج" : "Logout",
              style: const TextStyle(color: Colors.white),
            ),
            content: Text(
              isArabic
                  ? "هل أنت متأكد من رغبتك في تسجيل الخروج؟"
                  : "Are you sure you want to log out?",
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(isArabic ? "إلغاء" : "Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: Text(isArabic ? "خروج" : "Logout"),
              ),
            ],
          ),
    );
  }
}
