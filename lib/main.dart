import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:matchifiy/services/app_localizations.dart';
import 'package:matchifiy/services/fcm_service.dart';
import 'package:matchifiy/widgets/SplashScreen.dart';
import 'package:matchifiy/widgets/admin_dashboard_screen.dart';
import 'package:matchifiy/widgets/change_password_screen.dart';
import 'package:matchifiy/widgets/forgate_password_screen.dart';
import 'package:matchifiy/widgets/news_screen.dart';
import 'package:matchifiy/widgets/match_analysis_screen.dart';
import 'package:matchifiy/widgets/reset_password_screen.dart';
import 'package:matchifiy/widgets/user_management_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matchifiy/widgets/register_screen.dart';
import 'package:matchifiy/widgets/sign_in_screen.dart';
import 'package:matchifiy/services/token_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log(' Notification received (foreground)');
      log('Title: ${message.notification?.title}');
      log('Body: ${message.notification?.body}');
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      FcmService.sendTokenToBackend(newToken);
    });
  }

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
        primaryColor: Color.fromARGB(255, 137, 182, 217),
        scaffoldBackgroundColor: const Color(0xFF1E1E2E),
        fontFamily: 'Roboto',
      ),

      //  منطق التوكن + الرول
      home: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          TokenStorage.getToken(),
          TokenStorage.getUserData(),
        ]),
        builder: (context, snapshot) {
          //  انتظار
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 137, 182, 217),
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            final token = snapshot.data![0] as String?;
            final userData = snapshot.data![1] as Map<String, dynamic>?;
            final role = userData?['role'];

            log('Retrieved token: $token');
            log('Retrieved role: $role');

            if (token != null && token.isNotEmpty) {
              if (role == 'admin') {
                return const AdminDashboardScreen();
              } else {
                return const MatchAnalysisScreen();
              }
            }
          }

          //  لا يوجد توكن
          return const SplashScreen();
        },
      ),

      routes: {
        '/signin': (context) => const SignInScreen(),
        '/user_management': (context) => const UsersManagementScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const NewsScreen(),
        '/analysis': (context) => const MatchAnalysisScreen(),
        '/login': (context) => const SignInScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/admin-dashboard': (context) => const AdminDashboardScreen(),
        '/reset-password':
            (context) => const ResetPasswordScreen(
              emailFromEmail: '',
              tokenFromEmail: '',
            ),
      },
    );
  }
}
