import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:matchifiy/widgets/login_screen.dart';
import 'package:matchifiy/widgets/register_screen.dart';
import 'services/firebase_options.dart'; // إذا استخدمت flutterfire cli

import 'package:flutter/material.dart';
// يجب عليك استيراد الحزم الضرورية لـ Firebase
// تأكد من أن هذه الملفات موجودة في مشروعك
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart'; // هذا الملف يتم توليده عند إعداد Firebase

// استيراد الشاشات التي قمنا بإنشائها مسبقًا
import 'widgets/sign_in_screen.dart';
import 'widgets/match_analysis_screen.dart';

// **********************************************
// ********* دالة main() مع تهيئة Firebase *******
// **********************************************
void main() async {
  // التأكد من تهيئة Flutter قبل أي عملية تهيئة
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

// **********************************************
// ********* تطبيق MainApp() مع نظام التوجيه *******
// **********************************************
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // تحديد الألوان المستخدمة لتعيين الثيم العام للتطبيق
    const Color primaryDark = Color(0xFF1E1E2E);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matchify App',

      // *** 1. تحديد الثيم العام (Dark Theme) ***
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: primaryDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        // يمكنك إضافة ثيم حقول الإدخال هنا إذا أردت
      ),

      // *** 2. تحديد مسارات التوجيه (Routes) ***
      initialRoute: '/', // تبدأ بشاشة تسجيل الدخول
      routes: {
        // الشاشة الرئيسية: تسجيل الدخول (SignInScreen)
        '/': (context) => const SignInScreen(),
        // الشاشة الثانية: تحليل المباراة (MatchAnalysisScreen)
        '/analysis': (context) => const MatchAnalysisScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: LoginScreen(),
//       //  Scaffold(
//       //   body: LoginScreen(),
//       //   //  Center(
//       //   //   child: OutlinedButton(
//       //   //     child: Text('Hello World!'),
//       //   //     onPressed: () async {
//       //   //       Navigator.push(
//       //   //         context,
//       //   //         MaterialPageRoute(builder: (context) => LoginScreen()),
//       //   //       );
//       //   //     },
//       //   //   ),
//       //   // ),
//       // ),
//     );
//   }
// }
