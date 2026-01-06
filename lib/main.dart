// // import 'package:flutter/material.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:matchifiy/widgets/register_screen.dart';
// // import 'services/firebase_options.dart'; // إذا استخدمت flutterfire cli

// // import 'package:flutter/material.dart';
// // // يجب عليك استيراد الحزم الضرورية لـ Firebase
// // // تأكد من أن هذه الملفات موجودة في مشروعك
// // import 'package:firebase_core/firebase_core.dart';
// // import 'services/firebase_options.dart'; // هذا الملف يتم توليده عند إعداد Firebase

// // // استيراد الشاشات التي قمنا بإنشائها مسبقًا
// // import 'widgets/sign_in_screen.dart';
// // import 'widgets/match_analysis_screen.dart';

// // // **********************************************
// // // ********* دالة main() مع تهيئة Firebase *******
// // // **********************************************
// // void main() async {
// //   // التأكد من تهيئة Flutter قبل أي عملية تهيئة
// //   WidgetsFlutterBinding.ensureInitialized();

// //   // تهيئة Firebase
// //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// //   runApp(const MainApp());
// // }

// // // **********************************************
// // // ********* تطبيق MainApp() مع نظام التوجيه *******
// // // **********************************************
// // class MainApp extends StatelessWidget {
// //   const MainApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     // تحديد الألوان المستخدمة لتعيين الثيم العام للتطبيق
// //     const Color primaryDark = Color(0xFF1E1E2E);

// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Matchify App',

// //       // *** 1. تحديد الثيم العام (Dark Theme) ***
// //       theme: ThemeData(
// //         brightness: Brightness.dark,
// //         scaffoldBackgroundColor: primaryDark,
// //         appBarTheme: const AppBarTheme(
// //           backgroundColor: Colors.transparent,
// //           elevation: 0,
// //           iconTheme: IconThemeData(color: Colors.white),
// //         ),
// //         // يمكنك إضافة ثيم حقول الإدخال هنا إذا أردت
// //       ),

// //       // *** 2. تحديد مسارات التوجيه (Routes) ***
// //       initialRoute: '/', // تبدأ بشاشة تسجيل الدخول
// //       routes: {
// //         // الشاشة الرئيسية: تسجيل الدخول (SignInScreen)
// //         '/': (context) => const SignInScreen(),
// //         // الشاشة الثانية: تحليل المباراة (MatchAnalysisScreen)
// //         '/analysis': (context) => const MatchAnalysisScreen(),
// //         '/register': (context) => const RegisterScreen(),
// //       },
// //     );
// //   }
// // }
// // // void main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// // //   runApp(const MainApp());
// // // }

// // // class MainApp extends StatelessWidget {
// // //   const MainApp({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       home: LoginScreen(),
// // //       //  Scaffold(
// // //       //   body: LoginScreen(),
// // //       //   //  Center(
// // //       //   //   child: OutlinedButton(
// // //       //   //     child: Text('Hello World!'),
// // //       //   //     onPressed: () async {
// // //       //   //       Navigator.push(
// // //       //   //         context,
// // //       //   //         MaterialPageRoute(builder: (context) => LoginScreen()),
// // //       //   //       );
// // //       //   //     },
// // //       //   //   ),
// // //       //   // ),
// // //       // ),
// // //     );
// // //   }
// // // }
// // يجب نسخ هذا المحتوى ولصقه في ملف lib/main.dart الخاص بك
// // import 'package:flutter_localizations/flutter_localizations.dart';
// // import 'package:flutter/material.dart';
// // import 'package:matchifiy/widgets/app_localizations.dart';
// // import 'package:matchifiy/widgets/register_screen.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatefulWidget {
// //   const MyApp({super.key});

// //   @override
// //   State<MyApp> createState() => _MyAppState();

// //   // دالة ستاتيكية للوصول إلى حالة MyApp لتغيير اللغة
// //   static _MyAppState of(BuildContext context) =>
// //       context.findAncestorStateOfType<_MyAppState>()!;
// // }

// // class _MyAppState extends State<MyApp> {
// //   // اللغة الافتراضية
// //   Locale _locale = const Locale('ar', '');

// //   void setLocale(Locale newLocale) {
// //     setState(() {
// //       _locale = newLocale;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Registration Demo',
// //       theme: ThemeData(primarySwatch: Colors.blue),
// //       // إعدادات التوطين
// //       locale: _locale,
// //       supportedLocales: const [Locale('en', ''), Locale('ar', '')],
// //       localizationsDelegates: const [
// //         AppLocalizations.delegate, // مندوب التوطين المخصص
// //         // **الحل:** هذه المندوبون العالميون ضروريون لحل مشكلة "No MaterialLocalizations found" ودعم RTL.
// //         GlobalMaterialLocalizations.delegate,
// //         GlobalWidgetsLocalizations.delegate,
// //         GlobalCupertinoLocalizations.delegate,
// //       ],
// //       // استخدام الاتجاه المناسب للغة
// //       home: const RegisterScreen(),
// //     );
// //   }
// // }
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter/material.dart';

// // استيراد الملفات الضرورية للمسارات
// import 'package:matchifiy/widgets/app_localizations.dart';
// import 'package:matchifiy/widgets/register_screen.dart';
// import 'package:matchifiy/widgets/sign_in_screen.dart';
// import 'package:matchifiy/widgets/match_analysis_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// // الكلاس الحافظ للحالة (Locale)
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();

//   // دالة ستاتيكية للوصول إلى حالة MyApp لتغيير اللغة
//   static _MyAppState of(BuildContext context) =>
//       context.findAncestorStateOfType<_MyAppState>()!;
// }

// class _MyAppState extends State<MyApp> {
//   // اللغة الافتراضية
//   Locale _locale = const Locale('ar', '');

//   void setLocale(Locale newLocale) {
//     setState(() {
//       _locale = newLocale;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // تحديد الألوان المستخدمة لتعيين الثيم العام للتطبيق
//     const Color primaryDark = Color(0xFF1E1E2E);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Matchify App',

//       // *** 1. تحديد الثيم العام (Dark Theme) ***
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: primaryDark,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           iconTheme: IconThemeData(color: Colors.white),
//         ),
//       ),

//       // *** 2. إعدادات التوطين (ضرورية لدعم اللغة العربية) ***
//       locale: _locale,
//       supportedLocales: const [Locale('en', ''), Locale('ar', '')],
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],

//       // *** 3. تحديد مسارات التوجيه (Routes) ***
//       initialRoute: '/', // سيبدأ بشاشة تسجيل الدخول
//       routes: {
//         // الشاشة الرئيسية: تسجيل الدخول (SignInScreen)
//         '/': (context) => const SignInScreen(),
//         // شاشة التسجيل (RegisterScreen)
//         '/register': (context) => const RegisterScreen(),
//         // الشاشة الثانية: تحليل المباراة (MatchAnalysisScreen)
//         '/analysis': (context) => const MatchAnalysisScreen(),
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/token_storage.dart';
// import 'package:matchifiy/widgets/change_password_screen.dart';
// import 'package:matchifiy/widgets/home_screen.dart';
// import 'package:matchifiy/widgets/match_analysis_screen.dart';
// import 'package:matchifiy/widgets/register_screen.dart';
// import 'package:matchifiy/widgets/sign_in_screen.dart';

// void main() async {
//   // التأكد من تهيئة أدوات فلاتر قبل جلب التوكن
//   WidgetsFlutterBinding.ensureInitialized();

//   // جلب التوكن المحفوظ من الذاكرة الدائمة
//   final String? token = await TokenStorage.getToken();

//   // تشغيل التطبيق وتمرير الصفحة الابتدائية بناءً على وجود التوكن
//   runApp(
//     MyApp(
//       initialScreen:
//           (token != null && token.isNotEmpty)
//               ? const HomeScreen()
//               : const SignInScreen(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   final Widget initialScreen;
//   const MyApp({super.key, required this.initialScreen});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Matchifiy',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: const Color(0xFF0F172A),
//       ),

//       // الصفحة التي ستبدأ أولاً بناءً على الشرط في دالة main
//       home: initialScreen,

//       // تعريف المسارات لسهولة التنقل
//       routes: {
//         '/home': (context) => const HomeScreen(),
//         '/change-password': (context) => const ChangePasswordScreen(),
//         '/register': (context) => const RegisterScreen(),
//         '/analysis': (context) => const MatchAnalysisScreen(),
//         '/login': (context) => const SignInScreen(),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:matchifiy/services/app_localizations.dart';
import 'package:matchifiy/widgets/SplashScreen.dart';
import 'package:matchifiy/widgets/change_password_screen.dart';
import 'package:matchifiy/widgets/forgate_password_screen.dart';
import 'package:matchifiy/widgets/home_screen.dart';
import 'package:matchifiy/widgets/match_analysis_screen.dart';
import 'package:matchifiy/widgets/reset_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matchifiy/widgets/register_screen.dart';
import 'package:matchifiy/widgets/sign_in_screen.dart';
import 'package:matchifiy/services/token_storage.dart';

void main() async {
  // التأكد من تهيئة الـ Widgets قبل بدء التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  // قراءة اللغة المحفوظة من الجهاز
  final prefs = await SharedPreferences.getInstance();
  final String? languageCode = prefs.getString('language_code');

  runApp(
    MyApp(
      savedLocale:
          languageCode != null ? Locale(languageCode) : const Locale('ar'),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Locale savedLocale;
  const MyApp({super.key, required this.savedLocale});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.savedLocale;
  }

  // دالة لتغيير اللغة وحفظها محلياً
  void setLocale(Locale newLocale) async {
    setState(() {
      _locale = newLocale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLocale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matchify',
      locale: _locale,
      supportedLocales: const [Locale('en', ''), Locale('ar', '')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF8A2BE2),
        scaffoldBackgroundColor: const Color(0xFF1E1E2E),
        fontFamily: 'Roboto',
      ),
      // هنا دمجنا منطق فحص التوكن مع واجهة التطبيق
      home: FutureBuilder<String?>(
        future: TokenStorage.getToken(),
        builder: (context, snapshot) {
          // 1. حالة الانتظار أثناء جلب التوكن من الذاكرة
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF8A2BE2)),
              ),
            );
          }

          // 2. إذا وجدنا توكن غير فارغ، نتوجه مباشرة للرئيسية
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            return const HomeScreen();
          }

          // 3. إذا لم يوجد توكن، نتوجه لصفحة تسجيل الدخول
          return const SplashScreen();
          // return const SignInScreen();
        },
      ),
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/analysis': (context) => const MatchAnalysisScreen(),
        '/login': (context) => const SignInScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/reset-password':
            (context) => const ResetPasswordScreen(
              emailFromEmail: '',
              tokenFromEmail: '',
            ),
      },
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:matchifiy/services/app_localizations.dart';
// import 'package:matchifiy/widgets/home_screen.dart';
// import 'package:matchifiy/widgets/match_analysis_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:matchifiy/widgets/register_screen.dart';
// import 'package:matchifiy/widgets/sign_in_screen.dart';
// import 'package:matchifiy/services/token_storage.dart';

// void main() async {
//   // التأكد من تهيئة الـ Widgets قبل بدء التطبيق
//   WidgetsFlutterBinding.ensureInitialized();

//   // قراءة اللغة المحفوظة من الجهاز
//   final prefs = await SharedPreferences.getInstance();
//   final String? languageCode = prefs.getString('language_code');

//   runApp(
//     MyApp(
      
//       savedLocale:
//           languageCode != null ? Locale(languageCode) : const Locale('ar'),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   final Locale savedLocale;
//   const MyApp({super.key, required this.savedLocale});

//   @override
//   State<MyApp> createState() => _MyAppState();

//   static _MyAppState of(BuildContext context) =>
//       context.findAncestorStateOfType<_MyAppState>()!;
// }

// class _MyAppState extends State<MyApp> {
//   late Locale _locale;

//   @override
//   void initState() {
//     super.initState();
//     _locale = widget.savedLocale;
//   }

//   // دالة لتغيير اللغة وحفظها محلياً
//   void setLocale(Locale newLocale) async {
//     setState(() {
//       _locale = newLocale;
//     });
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('language_code', newLocale.languageCode);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Matchify',
//       locale: _locale,
//       supportedLocales: const [Locale('en', ''), Locale('ar', '')],
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         primaryColor: const Color(0xFF8A2BE2),
//         scaffoldBackgroundColor: const Color(0xFF1E1E2E),
//         fontFamily: 'Roboto',
//       ),
//       home: FutureBuilder<String?>(
//         future: TokenStorage.getToken(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(color: Color(0xFF8A2BE2)),
//               ),
//             );
//           }
//           return const SignInScreen();
//         },
//       ),
//       routes: {
//         '/signin': (context) => const SignInScreen(),
//         '/register': (context) => const RegisterScreen(),
//         '/home': (context) => const HomeScreen(),
//         '/analysis': (context) => const MatchAnalysisScreen(),
//         '/login': (context) => const SignInScreen(),
//       },
//     );
//   }
// }




























// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:matchifiy/widgets/app_localizations.dart';
// import 'package:matchifiy/widgets/match_analysis_screen.dart';
// import 'package:matchifiy/widgets/register_screen.dart';
// import 'package:matchifiy/widgets/sign_in_screen.dart';
// import 'package:matchifiy/services/token_storage.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();

//   static _MyAppState of(BuildContext context) =>
//       context.findAncestorStateOfType<_MyAppState>()!;
// }

// class _MyAppState extends State<MyApp> {
//   Locale _locale = const Locale('ar', '');

//   void setLocale(Locale newLocale) {
//     setState(() {
//       _locale = newLocale;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // الحل: اجعل MaterialApp هو الأب الأساسي دائماً، وضع الـ FutureBuilder داخله
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Matchify',
//       locale: _locale,
//       supportedLocales: const [Locale('en', ''), Locale('ar', '')],
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         primaryColor: const Color(0xFF8A2BE2),
//         scaffoldBackgroundColor: const Color(0xFF1E1E2E),
//         fontFamily: 'Roboto',
//       ),
//       home: FutureBuilder<String?>(
//         future: TokenStorage.getToken(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(color: Color(0xFF8A2BE2)),
//               ),
//             );
//           }

//           // إذا وجدنا توكن نذهب للتحليل، وإلا لشاشة تسجيل الدخول
//           if (snapshot.data != null) {
//             // ملاحظة: تأكد من إضافة شاشة التحليل هنا لاحقاً
//             return const SignInScreen();
//           } else {
//             return const SignInScreen();
//           }
//         },
//       ),
//       routes: {
//         '/signin': (context) => const SignInScreen(),
//         '/register': (context) => const RegisterScreen(),
//         '/analysis': (context) => const MatchAnalysisScreen(),
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:matchifiy/widgets/app_localizations.dart';
// import 'package:matchifiy/widgets/register_screen.dart';
// import 'package:matchifiy/widgets/sign_in_screen.dart';

// import 'package:matchifiy/services/token_storage.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();

//   // الوصول إلى حالة MyApp لتغيير اللغة من أي شاشة أخرى
//   static _MyAppState of(BuildContext context) =>
//       context.findAncestorStateOfType<_MyAppState>()!;
// }

// class _MyAppState extends State<MyApp> {
//   // اللغة الافتراضية للتطبيق (العربية)
//   Locale _locale = const Locale('ar', '');

//   // دالة تحديث اللغة وإعادة بناء الواجهات
//   void setLocale(Locale newLocale) {
//     setState(() {
//       _locale = newLocale;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String?>(
//       future: TokenStorage.getToken(),
//       builder: (context, snapshot) {
//         // شاشة انتظار بسيطة أثناء التحقق من التوكن
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const MaterialApp(
//             home: Scaffold(
//               backgroundColor: Color(0xFF1E1E2E),
//               body: Center(
//                 child: CircularProgressIndicator(color: Color(0xFF8A2BE2)),
//               ),
//             ),
//           );
//         }

//         // تحديد الشاشة الابتدائية بناءً على حالة تسجيل الدخول
//         final initialRoute = snapshot.data != null ? '/analysis' : '/signin';

//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Matchify',

//           // --- إعدادات اللغات والتوطين ---
//           locale: _locale,
//           supportedLocales: const [Locale('en', ''), Locale('ar', '')],
//           localizationsDelegates: const [
//             AppLocalizations.delegate,
//             GlobalMaterialLocalizations.delegate,
//             GlobalWidgetsLocalizations.delegate,
//             GlobalCupertinoLocalizations.delegate,
//           ],

//           theme: ThemeData(
//             brightness: Brightness.dark,
//             primaryColor: const Color(0xFF8A2BE2),
//             scaffoldBackgroundColor: const Color(0xFF1E1E2E),
//             fontFamily: 'Roboto',
//           ),

//           initialRoute: initialRoute,
//           routes: {
//             '/signin': (context) => const SignInScreen(),
//             '/register': (context) => const RegisterScreen(),
//             // ملاحظة: تأكد من استيراد MatchAnalysisScreen هنا إذا كانت موجودة
//             // '/analysis': (context) => const MatchAnalysisScreen(),
//           },
//         );
//       },
//     );
//   }
// }
