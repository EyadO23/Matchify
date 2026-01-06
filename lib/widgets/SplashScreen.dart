import 'dart:async';
import 'package:flutter/material.dart';
import 'package:matchifiy/widgets/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // أنيميشن لظهور الشعار بهدوء
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // الانتقال للشاشة التالية بعد 3 ثوانٍ
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. صورة الخلفية (السبلاش الرائعة)
          Image.asset(
            "assets/images/final.jpg", // قم بتسمية صورة السبلاش بهذا الاسم
            // "assets/images/splash.jpg", // قم بتسمية صورة السبلاش بهذا الاسم
            // 'assets/images/splash_bg.png', // قم بتسمية صورة السبلاش بهذا الاسم
            fit: BoxFit.cover,
          ),

          // 2. طبقة تظليل خفيفة لجعل المحتوى أوضح
          Container(color: Colors.black.withOpacity(0.3)),

          // 3. الشعار والنص في المنتصف
          FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // اللوجو الصغير
                // Image.asset('assets/images/logo.jpg', width: 120, height: 120),
                const SizedBox(height: 20),
                const Text(
                  "MATCHIFY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "ذكاء الملاعب بين يديك",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          // 4. مؤشر التحميل في الأسفل
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8A2BE2),
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
