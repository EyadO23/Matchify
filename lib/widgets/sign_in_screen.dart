// // // import 'dart:developer';

// // // import 'package:flutter/material.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:google_sign_in/google_sign_in.dart';
// // // import 'package:matchifiy/services/auth_service.dart';
// // // import 'package:matchifiy/services/token_storage.dart';

// // // // تحويل الشاشة إلى StatefulWidget للتحكم بالحالة والعمليات غير المتزامنة
// // // class SignInScreen extends StatefulWidget {
// // //   const SignInScreen({super.key});

// // //   @override
// // //   State<SignInScreen> createState() => _SignInScreenState();
// // // }

// // // class _SignInScreenState extends State<SignInScreen> {
// // //   // ********** الألوان المستخدمة (Colors) **********
// // //   static const Color primaryDark = Color(0xFF1E1E2E);
// // //   static const Color inputFieldBg = Color(0xFF28283D);
// // //   static const Color gradientStart = Color(0xFF8A2BE2);
// // //   static const Color gradientEnd = Color(0xFFE0B0FF);

// // //   Widget state = const Text(
// // //     'SIGN IN',
// // //     style: TextStyle(
// // //       fontSize: 16,
// // //       fontWeight: FontWeight.bold,
// // //       color: Colors.white,
// // //     ),
// // //   );
// // //   // const Text('LOGIN', style: TextStyle(color: Colors.white));

// // //   bool _isSigningIn = false; // لمؤشر التحميل على زر جوجل
// // //   bool _obscurePassword = true;

// // //   final TextEditingController emailController = TextEditingController();
// // //   final TextEditingController passwordController = TextEditingController();

// // //   void restate() {
// // //     setState(() {
// // //       state = const Text(
// // //         'SIGN IN',
// // //         style: TextStyle(
// // //           fontSize: 16,
// // //           fontWeight: FontWeight.bold,
// // //           color: Colors.white,
// // //         ),
// // //       );
// // //       //const Text('SIGN IN', style: TextStyle(color: Colors.white));
// // //     });
// // //   }

// // //   void handleLogin() async {
// // //     final email = emailController.text.trim();
// // //     final password = passwordController.text.trim();

// // //     if (email.isEmpty || password.isEmpty) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //           content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور'),
// // //         ),
// // //       );
// // //       restate();
// // //       return;
// // //     }

// // //     // if (!ContractorValidator.isEmailValid(email)) {
// // //     //   ScaffoldMessenger.of(context).showSnackBar(
// // //     //     const SnackBar(content: Text('يرجى إدخال بريد إلكتروني صالح')),
// // //     //   );
// // //     //   restate();
// // //     //   return;
// // //     // }

// // //     final result = await AuthService.login(email, password);
// // //     log(result.toString());
// // //     if (result != null) {
// // //       final token = result['token'];
// // //       final role = result['role'];
// // //       final userId = result['user_id'];
// // //       // log(token);
// // //       await TokenStorage.saveToken(token);
// // //       // await TokenStorage.saveRole(role);
// // //       // await TokenStorage.saveUserrId(userId.toString());

// // //       // await FirebaseMessagingService().init();

// // //       Navigator.pushReplacementNamed(context, '/analysis');
// // //     } else {
// // //       restate();
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //           content: Text('البريد الإلكتروني أو كلمة المرور غير صحيحة'),
// // //         ),
// // //       );
// // //     }
// // //   }

// // //   //////
// // //   ///
// // //   // Future<void> _handleGoogleSignIn() async {
// // //   //   setState(() {
// // //   //     _isSigningIn = true;
// // //   //   });

// // //   //   try {
// // //   //     //  تسجيل الدخول عبر Google
// // //   //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

// // //   //     if (googleUser == null) {
// // //   //       setState(() => _isSigningIn = false);
// // //   //       return;
// // //   //     }

// // //   //     final googleAuth = await googleUser.authentication;

// // //   //     //  إنشاء Credential لـ Firebase
// // //   //     final credential = GoogleAuthProvider.credential(
// // //   //       accessToken: googleAuth.accessToken,
// // //   //       idToken: googleAuth.idToken,
// // //   //     );

// // //   //     final userCredential = await FirebaseAuth.instance.signInWithCredential(
// // //   //       credential,
// // //   //     );

// // //   //     final firebaseUser = userCredential.user;

// // //   //     if (firebaseUser == null) {
// // //   //       throw Exception("Firebase user is null");
// // //   //     }

// // //   //     //  انتقل للشاشة التالية فور نجاح تسجيل الدخول
// // //   //     if (mounted) {
// // //   //       Navigator.pushReplacementNamed(context, '/analysis');
// // //   //     }

// // //   //     //  أرسل التوكين للباكند في الخلفية
// // //   //     final idToken = await firebaseUser.getIdToken();
// // //   //     print(" Firebase ID Token (sending in background): $idToken");

// // //   //     // fire-and-forget: لا ننتظر الرد
// // //   //     AuthService.sendFirebaseIdToken(idToken!)
// // //   //         .then((response) {
// // //   //           if (response != null && response["success"] == true) {
// // //   //             log(" Backend accepted Firebase ID Token");
// // //   //             TokenStorage.saveToken(response["token"]);
// // //   //           } else {
// // //   //             log(" Backend rejected Firebase ID Token");
// // //   //           }
// // //   //         })
// // //   //         .catchError((e) {
// // //   //           log(" Error sending Firebase ID Token: $e");
// // //   //         });
// // //   //   } catch (e) {
// // //   //     log("Google Sign In Error: $e");
// // //   //     ScaffoldMessenger.of(
// // //   //       context,
// // //   //     ).showSnackBar(SnackBar(content: Text('Failed to sign in: $e')));
// // //   //   } finally {
// // //   //     if (mounted) {
// // //   //       setState(() => _isSigningIn = false);
// // //   //     }
// // //   //   }
// // //   // }

// // //   Future<void> _handleGoogleSignIn() async {
// // //     setState(() {
// // //       _isSigningIn = true;
// // //     });

// // //     try {
// // //       // تسجيل الدخول عبر Google
// // //       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

// // //       if (googleUser == null) {
// // //         setState(() => _isSigningIn = false);
// // //         return;
// // //       }

// // //       final googleAuth = await googleUser.authentication;

// // //       // إنشاء Credential لـ Firebase
// // //       final credential = GoogleAuthProvider.credential(
// // //         accessToken: googleAuth.accessToken,
// // //         idToken: googleAuth.idToken,
// // //       );

// // //       final userCredential = await FirebaseAuth.instance.signInWithCredential(
// // //         credential,
// // //       );

// // //       final firebaseUser = userCredential.user;

// // //       // 🔥 هذا التوكين الذي يجب إرساله للباك (Firebase ID Token)
// // //       final idToken = await firebaseUser?.getIdToken();

// // //       print(" Firebase ID Token: $idToken");

// // //       //  أرسل التوكين إلى الباك عبر AuthService
// // //       final response = await AuthService.sendFirebaseIdToken(idToken!);

// // //       print(" Backend Response: $response");

// // //       if (response != null && response["success"] == true) {
// // //         // خزّن التوكين إذا كنت تحتاجه
// // //         await TokenStorage.saveToken(response["token"]);

// // //         // انتقل للصفحة التالية
// // //         if (mounted) {
// // //           Navigator.pushReplacementNamed(context, '/analysis');
// // //         }
// // //       } else {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text('Google login failed on backend')),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       print("Google Sign In Error: $e");
// // //       ScaffoldMessenger.of(
// // //         context,
// // //       ).showSnackBar(SnackBar(content: Text('Failed to sign in: $e')));
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() => _isSigningIn = false);
// // //       }
// // //     }
// // //   }

// // //   // **************************************************
// // //   // ********** منطق تسجيل الدخول عبر جوجل ************
// // //   // **************************************************
// // //   // Future<void> _handleGoogleSignIn() async {
// // //   //   setState(() {
// // //   //     _isSigningIn = true; // تفعيل مؤشر التحميل
// // //   //   });

// // //   //   try {
// // //   //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

// // //   //     // إذا ألغى المستخدم عملية تسجيل الدخول
// // //   //     if (googleUser == null) {
// // //   //       setState(() {
// // //   //         _isSigningIn = false;
// // //   //       });
// // //   //       return;
// // //   //     }

// // //   //     final GoogleSignInAuthentication googleAuth =
// // //   //         await googleUser.authentication;

// // //   //     // إنشاء بيانات الاعتماد الخاصة بـ Firebase
// // //   //     final AuthCredential credential = GoogleAuthProvider.credential(
// // //   //       accessToken: googleAuth.accessToken,
// // //   //       idToken: googleAuth.idToken,
// // //   //     );

// // //   //     // تسجيل الدخول باستخدام Firebase
// // //   //     await FirebaseAuth.instance.signInWithCredential(credential);

// // //   //     // إذا نجح تسجيل الدخول: الانتقال إلى شاشة التحليل
// // //   //     if (mounted) {
// // //   //       Navigator.pushReplacementNamed(context, '/analysis');
// // //   //     }
// // //   //   } on Exception catch (e) {
// // //   //     // إظهار رسالة خطأ للمستخدم (يمكنك استخدام SnackBar)
// // //   //     print("Google Sign In Error: $e");
// // //   //     ScaffoldMessenger.of(context).showSnackBar(
// // //   //       SnackBar(content: Text('Failed to sign in with Google: $e')),
// // //   //     );
// // //   //   } finally {
// // //   //     // إيقاف مؤشر التحميل دائماً
// // //   //     if (mounted) {
// // //   //       setState(() {
// // //   //         _isSigningIn = false;
// // //   //       });
// // //   //     }
// // //   //   }
// // //   // }

// // //   //   Future<void> _handleGoogleSignIn() async {
// // //   //   setState(() {
// // //   //     _isSigningIn = true;
// // //   //   });

// // //   //   try {
// // //   //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

// // //   //     if (googleUser == null) {
// // //   //       setState(() => _isSigningIn = false);
// // //   //       return;
// // //   //     }

// // //   //     final googleAuth = await googleUser.authentication;

// // //   //     final credential = GoogleAuthProvider.credential(
// // //   //       accessToken: googleAuth.accessToken,
// // //   //       idToken: googleAuth.idToken,
// // //   //     );

// // //   //     final userCredential =
// // //   //         await FirebaseAuth.instance.signInWithCredential(credential);

// // //   //     final firebaseUser = userCredential.user;

// // //   //     //  هذا ما يحتاجه الباكند
// // //   //     final idToken = await firebaseUser?.getIdToken();

// // //   //     print(" Firebase ID Token: $idToken");

// // //   //     // إرسال التوكن للباك
// // //   //     final response = await http.post(
// // //   //       Uri.parse("http://YOUR_BACKEND/api/google-login"),
// // //   //       headers: {"Content-Type": "application/json"},
// // //   //       body: jsonEncode({"id_token": idToken}),
// // //   //     );

// // //   //     print("📌 Backend Response: ${response.body}");

// // //   //     if (mounted) {
// // //   //       Navigator.pushReplacementNamed(context, '/analysis');
// // //   //     }
// // //   //   } catch (e) {
// // //   //     print("Google Sign In Error: $e");
// // //   //     ScaffoldMessenger.of(context)
// // //   //         .showSnackBar(SnackBar(content: Text('Failed to sign in: $e')));
// // //   //   } finally {
// // //   //     if (mounted) {
// // //   //       setState(() => _isSigningIn = false);
// // //   //     }
// // //   //   }
// // //   // }

// // //   // **************************************************
// // //   // ********** بناء واجهة المستخدم (UI) *************
// // //   // **************************************************
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: primaryDark,
// // //       body: Stack(
// // //         children: <Widget>[
// // //           _buildBackgroundImage(),
// // //           SafeArea(
// // //             child: SingleChildScrollView(
// // //               padding: const EdgeInsets.symmetric(
// // //                 horizontal: 24.0,
// // //                 vertical: 40.0,
// // //               ),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.stretch,
// // //                 children: <Widget>[
// // //                   _buildWelcomeSection(),
// // //                   const SizedBox(height: 30),
// // //                   _buildInputFields(),
// // //                   const SizedBox(height: 15),
// // //                   _buildForgotPasswordLink(),
// // //                   const SizedBox(height: 30),
// // //                   _buildSignInButtons(context),
// // //                   const SizedBox(height: 40),
// // //                   _buildRegisterLink(),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // ... (باقي دوال البناء مثل _buildBackgroundImage و _buildWelcomeSection تبقى كما هي) ...

// // //   Widget _buildBackgroundImage() {
// // //     return Positioned.fill(
// // //       child: Opacity(
// // //         opacity: 0.1,
// // //         child: Image.asset('assets/background_image.png', fit: BoxFit.cover),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildWelcomeSection() {
// // //     return const Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         Text(
// // //           'Welcome to\nMatchify',
// // //           style: TextStyle(
// // //             color: Colors.white,
// // //             fontSize: 32,
// // //             fontWeight: FontWeight.bold,
// // //           ),
// // //         ),
// // //         SizedBox(height: 8),
// // //         Text(
// // //           'Enter your email address and password to use the application',
// // //           style: TextStyle(color: Colors.white70, fontSize: 14),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildInputFields() {
// // //     return Column(
// // //       children: [
// // //         TextFormField(
// // //           controller: emailController,
// // //           decoration: InputDecoration(
// // //             labelText: 'Username',
// // //             labelStyle: const TextStyle(color: Colors.white70),
// // //             fillColor: inputFieldBg,

// // //             filled: true,
// // //             border: OutlineInputBorder(
// // //               borderRadius: BorderRadius.circular(10.0),
// // //               borderSide: BorderSide.none,
// // //             ),
// // //           ),
// // //           style: const TextStyle(color: Colors.white),
// // //         ),
// // //         const SizedBox(height: 20),
// // //         TextFormField(
// // //           obscureText: _obscurePassword,
// // //           controller: passwordController,

// // //           decoration: InputDecoration(
// // //             labelText: 'Password',
// // //             labelStyle: const TextStyle(color: Colors.white70),
// // //             suffixIcon: IconButton(
// // //               icon: Icon(
// // //                 _obscurePassword ? Icons.visibility_off : Icons.visibility,
// // //               ),
// // //               onPressed: () {
// // //                 setState(() {
// // //                   _obscurePassword = !_obscurePassword;
// // //                 });
// // //               },
// // //             ),
// // //             // suffixIcon: const Icon(Icons.remove_red_eye, color: Colors.white70),
// // //             fillColor: inputFieldBg,
// // //             filled: true,
// // //             border: OutlineInputBorder(
// // //               borderRadius: BorderRadius.circular(10.0),
// // //               borderSide: BorderSide.none,
// // //             ),
// // //           ),
// // //           style: const TextStyle(color: Colors.white),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildForgotPasswordLink() {
// // //     return Align(
// // //       alignment: Alignment.centerRight,
// // //       child: TextButton(
// // //         onPressed: () {},
// // //         child: const Text(
// // //           'Forgot Password?',
// // //           style: TextStyle(color: Colors.white70, fontSize: 14),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildSignInButtons(BuildContext context) {
// // //     return Column(
// // //       children: [
// // //         // زر التسجيل الرئيسي (SIGN IN) - لا يزال وهمياً
// // //         Container(
// // //           height: 50,
// // //           decoration: BoxDecoration(
// // //             gradient: const LinearGradient(
// // //               colors: [gradientStart, gradientEnd],
// // //               begin: Alignment.centerLeft,
// // //               end: Alignment.centerRight,
// // //             ),
// // //             borderRadius: BorderRadius.circular(10.0),
// // //           ),
// // //           child: ElevatedButton(
// // //             onPressed: () {
// // //               setState(() {
// // //                 state = const SizedBox(
// // //                   width: 20,
// // //                   height: 20,
// // //                   child: CircularProgressIndicator(
// // //                     color: Colors.white,
// // //                     strokeWidth: 2,
// // //                   ),
// // //                 );
// // //               });
// // //               handleLogin();
// // //               // هذا هو الانتقال الوهمي الذي طلبته
// // //               // Navigator.pushReplacementNamed(context, '/analysis');
// // //             },
// // //             style: ElevatedButton.styleFrom(
// // //               backgroundColor: Colors.transparent,
// // //               shadowColor: Colors.transparent,
// // //               shape: RoundedRectangleBorder(
// // //                 borderRadius: BorderRadius.circular(10.0),
// // //               ),
// // //             ),
// // //             child: state,
// // //             //  const Text(
// // //             //   'SIGN IN',
// // //             //   style: TextStyle(
// // //             //     fontSize: 16,
// // //             //     fontWeight: FontWeight.bold,
// // //             //     color: Colors.white,
// // //             //   ),
// // //             // ),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 20),
// // //         const Text('Or Login With', style: TextStyle(color: Colors.white70)),
// // //         const SizedBox(height: 20),
// // //         // زر Google - أصبح يعمل الآن مع Firebase
// // //         OutlinedButton.icon(
// // //           // منع الضغط إذا كانت عملية التسجيل جارية
// // //           onPressed: _isSigningIn ? null : _handleGoogleSignIn,

// // //           icon:
// // //               _isSigningIn
// // //                   ? const SizedBox(
// // //                     width: 20,
// // //                     height: 20,
// // //                     child: CircularProgressIndicator(
// // //                       strokeWidth: 2,
// // //                       color: Colors.white,
// // //                     ),
// // //                   )
// // //                   : Image.asset(
// // //                     'assets/google_logo.png',
// // //                     height: 24,
// // //                     width: 24,
// // //                   ),

// // //           label: Text(
// // //             _isSigningIn ? 'Signing In...' : 'Google',
// // //             style: const TextStyle(color: Colors.white, fontSize: 16),
// // //           ),
// // //           style: OutlinedButton.styleFrom(
// // //             side: const BorderSide(color: Colors.white30),
// // //             padding: const EdgeInsets.symmetric(vertical: 12),
// // //             minimumSize: const Size(double.infinity, 50),
// // //             shape: RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(10),
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildRegisterLink() {
// // //     return Row(
// // //       mainAxisAlignment: MainAxisAlignment.center,
// // //       children: [
// // //         const Text(
// // //           "Don't have an account?",
// // //           style: TextStyle(color: Colors.white70),
// // //         ),
// // //         TextButton(
// // //           onPressed: () {
// // //             Navigator.pushNamed(context, '/register');
// // //             // ... الانتقال لشاشة التسجيل
// // //           },
// // //           child: const Text(
// // //             'Register Now',
// // //             style: TextStyle(color: gradientEnd, fontWeight: FontWeight.bold),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }
// // import 'dart:developer';
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:google_sign_in/google_sign_in.dart';
// // import 'package:matchifiy/services/auth_service.dart';
// // import 'package:matchifiy/services/token_storage.dart';
// // import 'package:matchifiy/main.dart'; // import MyApp
// // import 'package:matchifiy/widgets/app_localizations.dart'; // import AppLocalizations

// // class AppColors {
// //   static const Color primaryDark = Color(0xFF1E1E2E);
// //   static const Color inputFieldBg = Color(0xFF28283D);
// //   static const Color gradientStart = Color(0xFF8A2BE2);
// //   static const Color gradientEnd = Color(0xFFE0B0FF);
// // }

// // // تحويل الشاشة إلى StatefulWidget للتحكم بالحالة والعمليات غير المتزامنة
// // class SignInScreen extends StatefulWidget {
// //   const SignInScreen({super.key});

// //   @override
// //   State<SignInScreen> createState() => _SignInScreenState();
// // }

// // class _SignInScreenState extends State<SignInScreen> {
// //   // ********** الألوان المستخدمة (Colors) **********
// //   static const Color primaryDark = AppColors.primaryDark;
// //   static const Color inputFieldBg = AppColors.inputFieldBg;
// //   static const Color gradientStart = AppColors.gradientStart;
// //   static const Color gradientEnd = AppColors.gradientEnd;

// //   Widget state = const Text(
// //     'SIGN IN',
// //     style: TextStyle(
// //       fontSize: 16,
// //       fontWeight: FontWeight.bold,
// //       color: Colors.white,
// //     ),
// //   );

// //   bool _isSigningIn = false; // لمؤشر التحميل على زر جوجل
// //   bool _obscurePassword = true;

// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();

// //   // ********** دالة تبديل اللغة **********
// //   void _toggleLanguage() {
// //     final currentLocale = Localizations.localeOf(context);
// //     final newLocale =
// //         currentLocale.languageCode == 'ar'
// //             ? const Locale('en', '')
// //             : const Locale('ar', '');
// //     MyApp.of(context).setLocale(newLocale);
// //   }

// //   void restate() {
// //     final loc = AppLocalizations.of(context);
// //     setState(() {
// //       state = Text(
// //         loc.signIn,
// //         style: const TextStyle(
// //           fontSize: 16,
// //           fontWeight: FontWeight.bold,
// //           color: Colors.white,
// //         ),
// //       );
// //     });
// //   }

// //   void handleLogin() async {
// //     final loc = AppLocalizations.of(context);
// //     final email = emailController.text.trim();
// //     final password = passwordController.text.trim();

// //     if (email.isEmpty || password.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           // تم استخدام نص ثابت كبديل (Fallback) لتجنب أخطاء loc.pleaseFillFields
// //           content: const Text('Please fill in all fields.'),
// //         ),
// //       );
// //       restate();
// //       return;
// //     }

// //     setState(() {
// //       state = const SizedBox(
// //         width: 20,
// //         height: 20,
// //         child: CircularProgressIndicator(
// //           color: Colors.white,
// //           strokeWidth: 2,
// //         ),
// //       );
// //     });

// //     final result = await AuthService.login(email, password);
// //     log(result.toString());

// //     if (!mounted) return;

// //     if (result != null) {
// //       final token = result['token'];
// //       // final role = result['role'];
// //       // final userId = result['user_id'];
// //       await TokenStorage.saveToken(token);
// //       Navigator.pushReplacementNamed(context, '/analysis');
// //     } else {
// //       restate();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           // تم استخدام نص ثابت كبديل (Fallback) لتجنب أخطاء loc.loginFailedMessage
// //           content: const Text('Login failed. Please check your credentials.'),
// //         ),
// //       );
// //     }
// //   }

// //   Future<void> _handleGoogleSignIn() async {
// //     final loc = AppLocalizations.of(context);

// //     setState(() {
// //       _isSigningIn = true;
// //     });

// //     try {
// //       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

// //       if (googleUser == null) {
// //         setState(() => _isSigningIn = false);
// //         return;
// //       }

// //       final googleAuth = await googleUser.authentication;
// //       final credential = GoogleAuthProvider.credential(
// //         accessToken: googleAuth.accessToken,
// //         idToken: googleAuth.idToken,
// //       );

// //       final userCredential = await FirebaseAuth.instance.signInWithCredential(
// //         credential,
// //       );

// //       final firebaseUser = userCredential.user;
// //       final idToken = await firebaseUser?.getIdToken();

// //       log(" Firebase ID Token: $idToken");

// //       final response = await AuthService.sendFirebaseIdToken(idToken!);

// //       log(" Backend Response: $response");

// //       if (!mounted) return;

// //       if (response != null && response["success"] == true) {
// //         await TokenStorage.saveToken(response["token"]);
// //         Navigator.pushReplacementNamed(context, '/analysis');
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(loc.googleLoginFailed)),
// //         );
// //       }
// //     } catch (e) {
// //       log("Google Sign In Error: $e");
// //       if (!mounted) return;
// //       // تم استبدال loc.error بنص ثابت مؤقتاً لتجنب NoSuchMethodError
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(SnackBar(content: Text('Error: $e')));
// //     } finally {
// //       if (mounted) {
// //         setState(() => _isSigningIn = false);
// //       }
// //     }
// //   }

// //   // **************************************************
// //   // ********** بناء واجهة المستخدم (UI) *************
// //   // **************************************************
// //   @override
// //   Widget build(BuildContext context) {
// //     final loc = AppLocalizations.of(context);
// //     final isArabic = Localizations.localeOf(context).languageCode == 'ar';

// //     return Directionality(
// //       textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
// //       child: Scaffold(
// //         backgroundColor: primaryDark,
// //         appBar: AppBar(
// //           backgroundColor: Colors.transparent,
// //           elevation: 0,
// //           actions: [
// //             // زر تبديل اللغة
// //             TextButton(
// //               onPressed: _toggleLanguage,
// //               child: Text(
// //                 isArabic ? 'English' : 'العربية',
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //         body: Stack(
// //           children: <Widget>[
// //             _buildBackgroundImage(),
// //             SafeArea(
// //               child: SingleChildScrollView(
// //                 padding: const EdgeInsets.symmetric(
// //                   horizontal: 24.0,
// //                   vertical: 0.0,
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.stretch,
// //                   children: <Widget>[
// //                     _buildWelcomeSection(loc),
// //                     const SizedBox(height: 30),
// //                     _buildInputFields(loc),
// //                     const SizedBox(height: 15),
// //                     _buildForgotPasswordLink(loc),
// //                     const SizedBox(height: 30),
// //                     _buildSignInButtons(context, loc),
// //                     const SizedBox(height: 40),
// //                     _buildRegisterLink(loc),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildBackgroundImage() {
// //     // استخدم صورة وهمية أو placeholder لتجنب خطأ asset
// //     return Positioned.fill(
// //       child: Opacity(
// //         opacity: 0.1,
// //         child: Container(color: Colors.black), // Placeholder for Image.asset
// //       ),
// //     );
// //   }

// //   Widget _buildWelcomeSection(AppLocalizations loc) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           loc.welcomeTitle,
// //           style: const TextStyle(
// //             color: Colors.white,
// //             fontSize: 32,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(
// //           loc.welcomeSubtitle,
// //           style: const TextStyle(color: Colors.white70, fontSize: 14),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildInputFields(AppLocalizations loc) {
// //     return Column(
// //       children: [
// //         TextFormField(
// //           controller: emailController,
// //           style: const TextStyle(color: Colors.white),
// //           decoration: InputDecoration(
// //             labelText: loc.username,
// //             labelStyle: const TextStyle(color: Colors.white70),
// //             fillColor: inputFieldBg,
// //             filled: true,
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10.0),
// //               borderSide: BorderSide.none,
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 20),
// //         TextFormField(
// //           obscureText: _obscurePassword,
// //           controller: passwordController,
// //           style: const TextStyle(color: Colors.white),
// //           decoration: InputDecoration(
// //             labelText: loc.password,
// //             labelStyle: const TextStyle(color: Colors.white70),
// //             suffixIcon: IconButton(
// //               icon: Icon(
// //                 _obscurePassword ? Icons.visibility_off : Icons.visibility,
// //                 color: Colors.white70,
// //               ),
// //               onPressed: () {
// //                 setState(() {
// //                   _obscurePassword = !_obscurePassword;
// //                 });
// //               },
// //             ),
// //             fillColor: inputFieldBg,
// //             filled: true,
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10.0),
// //               borderSide: BorderSide.none,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildForgotPasswordLink(AppLocalizations loc) {
// //     return Align(
// //       alignment: Alignment.centerRight,
// //       child: TextButton(
// //         onPressed: () {},
// //         child: Text(
// //           loc.forgotPassword,
// //           style: const TextStyle(color: Colors.white70, fontSize: 14),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSignInButtons(BuildContext context, AppLocalizations loc) {
// //     return Column(
// //       children: [
// //         // زر التسجيل الرئيسي (SIGN IN)
// //         Container(
// //           height: 50,
// //           decoration: BoxDecoration(
// //             gradient: const LinearGradient(
// //               colors: [gradientStart, gradientEnd],
// //               begin: Alignment.centerLeft,
// //               end: Alignment.centerRight,
// //             ),
// //             borderRadius: BorderRadius.circular(10.0),
// //           ),
// //           child: ElevatedButton(
// //             onPressed: () {
// //               handleLogin();
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.transparent,
// //               shadowColor: Colors.transparent,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(10.0),
// //               ),
// //             ),
// //             child: state,
// //           ),
// //         ),
// //         const SizedBox(height: 20),
// //         Text(loc.orLoginWith, style: const TextStyle(color: Colors.white70)),
// //         const SizedBox(height: 20),
// //         // زر Google
// //         OutlinedButton.icon(
// //           onPressed: _isSigningIn ? null : _handleGoogleSignIn,
// //           icon: _isSigningIn
// //               ? const SizedBox(
// //                   width: 20,
// //                   height: 20,
// //                   child: CircularProgressIndicator(
// //                     strokeWidth: 2,
// //                     color: Colors.white,
// //                   ),
// //                 )
// //               // Placeholder for the Google logo image
// //               : const Icon(Icons.g_mobiledata, size: 30, color: Colors.white),

// //           label: Text(
// //             _isSigningIn ? loc.signingIn : loc.google,
// //             style: const TextStyle(color: Colors.white, fontSize: 16),
// //           ),
// //           style: OutlinedButton.styleFrom(
// //             side: const BorderSide(color: Colors.white30),
// //             padding: const EdgeInsets.symmetric(vertical: 12),
// //             minimumSize: const Size(double.infinity, 50),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildRegisterLink(AppLocalizations loc) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         Text(
// //           loc.noAccount,
// //           style: const TextStyle(color: Colors.white70),
// //         ),
// //         TextButton(
// //           onPressed: () {
// //             Navigator.pushNamed(context, '/register');
// //           },
// //           child: Text(
// //             loc.registerNow,
// //             style: const TextStyle(
// //                 color: gradientEnd, fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:matchifiy/services/auth_service.dart';
// import 'package:matchifiy/services/token_storage.dart';
// import 'package:matchifiy/main.dart'; // import MyApp
// import 'package:matchifiy/widgets/app_localizations.dart'; // import AppLocalizations

// class AppColors {
//   static const Color primaryDark = Color(0xFF1E1E2E);
//   static const Color inputFieldBg = Color(0xFF28283D);
//   static const Color gradientStart = Color(0xFF8A2BE2);
//   static const Color gradientEnd = Color(0xFFE0B0FF);
// }

// // تحويل الشاشة إلى StatefulWidget للتحكم بالحالة والعمليات غير المتزامنة
// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   // ********** الألوان المستخدمة (Colors) **********
//   static const Color primaryDark = AppColors.primaryDark;
//   static const Color inputFieldBg = AppColors.inputFieldBg;
//   static const Color gradientStart = AppColors.gradientStart;
//   static const Color gradientEnd = AppColors.gradientEnd;

//   Widget state = const Text(
//     'SIGN IN',
//     style: TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.bold,
//       color: Colors.white,
//     ),
//   );

//   bool _isSigningIn = false; // لمؤشر التحميل على زر جوجل
//   bool _obscurePassword = true;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   // ********** دالة تبديل اللغة **********
//   void _toggleLanguage() {
//     final currentLocale = Localizations.localeOf(context);
//     final newLocale =
//         currentLocale.languageCode == 'ar'
//             ? const Locale('en', '')
//             : const Locale('ar', '');
//     MyApp.of(context).setLocale(newLocale);
//   }

//   void restate() {
//     final loc = AppLocalizations.of(context);
//     setState(() {
//       state = Text(
//         loc.signIn,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       );
//     });
//   }

//   void handleLogin() async {
//     final loc = AppLocalizations.of(context);
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           // تم العودة لاستخدام مفتاح التوطين الصحيح loc.pleaseFillFields
//           content: Text(loc.pleaseFillFields),
//         ),
//       );
//       restate();
//       return;
//     }

//     setState(() {
//       state = const SizedBox(
//         width: 20,
//         height: 20,
//         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//       );
//     });

//     final result = await AuthService.login(email, password);
//     log(result.toString());

//     if (!mounted) return;

//     if (result != null) {
//       final token = result['token'];
//       // final role = result['role'];
//       // final userId = result['user_id'];
//       await TokenStorage.saveToken(token);
//       Navigator.pushReplacementNamed(context, '/analysis');
//     } else {
//       restate();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           // تم العودة لاستخدام مفتاح التوطين الصحيح loc.loginFailedMessage
//           content: Text(loc.loginFailedMessage),
//         ),
//       );
//     }
//   }

//   Future<void> _handleGoogleSignIn() async {
//     final loc = AppLocalizations.of(context);

//     setState(() {
//       _isSigningIn = true;
//     });

//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       if (googleUser == null) {
//         setState(() => _isSigningIn = false);
//         return;
//       }

//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final userCredential = await FirebaseAuth.instance.signInWithCredential(
//         credential,
//       );

//       final firebaseUser = userCredential.user;
//       final idToken = await firebaseUser?.getIdToken();

//       log(" Firebase ID Token: $idToken");

//       final response = await AuthService.sendFirebaseIdToken(idToken!);

//       log(" Backend Response: $response");

//       if (!mounted) return;

//       if (response != null && response["success"] == true) {
//         await TokenStorage.saveToken(response["token"]);
//         Navigator.pushReplacementNamed(context, '/analysis');
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(loc.googleLoginFailed)));
//       }
//     } catch (e) {
//       log("Google Sign In Error: $e");
//       if (!mounted) return;
//       // تم العودة لاستخدام مفتاح التوطين الصحيح loc.error
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('${loc.error}: $e')));
//     } finally {
//       if (mounted) {
//         setState(() => _isSigningIn = false);
//       }
//     }
//   }

//   // **************************************************
//   // ********** بناء واجهة المستخدم (UI) *************
//   // **************************************************
//   @override
//   Widget build(BuildContext context) {
//     final loc = AppLocalizations.of(context);
//     final isArabic = Localizations.localeOf(context).languageCode == 'ar';

//     return Directionality(
//       textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
//       child: Scaffold(
//         backgroundColor: primaryDark,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           actions: [
//             // زر تبديل اللغة
//             TextButton(
//               onPressed: _toggleLanguage,
//               child: Text(
//                 isArabic ? 'English' : 'العربية',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: Stack(
//           children: <Widget>[
//             _buildBackgroundImage(),
//             SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24.0,
//                   vertical: 0.0,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: <Widget>[
//                     _buildWelcomeSection(loc),
//                     const SizedBox(height: 30),
//                     _buildInputFields(loc),
//                     const SizedBox(height: 15),
//                     _buildForgotPasswordLink(loc),
//                     const SizedBox(height: 30),
//                     _buildSignInButtons(context, loc),
//                     const SizedBox(height: 40),
//                     _buildRegisterLink(loc),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBackgroundImage() {
//     // استخدم صورة وهمية أو placeholder لتجنب خطأ asset
//     return Positioned.fill(
//       child: Opacity(
//         opacity: 0.1,
//         child: Container(color: Colors.black), // Placeholder for Image.asset
//       ),
//     );
//   }

//   Widget _buildWelcomeSection(AppLocalizations loc) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           loc.welcomeTitle,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           loc.welcomeSubtitle,
//           style: const TextStyle(color: Colors.white70, fontSize: 14),
//         ),
//       ],
//     );
//   }

//   Widget _buildInputFields(AppLocalizations loc) {
//     return Column(
//       children: [
//         TextFormField(
//           controller: emailController,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             labelText: loc.username,
//             labelStyle: const TextStyle(color: Colors.white70),
//             fillColor: inputFieldBg,
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         TextFormField(
//           obscureText: _obscurePassword,
//           controller: passwordController,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             labelText: loc.password,
//             labelStyle: const TextStyle(color: Colors.white70),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                 color: Colors.white70,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _obscurePassword = !_obscurePassword;
//                 });
//               },
//             ),
//             fillColor: inputFieldBg,
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildForgotPasswordLink(AppLocalizations loc) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: TextButton(
//         onPressed: () {},
//         child: Text(
//           loc.forgotPassword,
//           style: const TextStyle(color: Colors.white70, fontSize: 14),
//         ),
//       ),
//     );
//   }

//   Widget _buildSignInButtons(BuildContext context, AppLocalizations loc) {
//     return Column(
//       children: [
//         // زر التسجيل الرئيسي (SIGN IN)
//         Container(
//           height: 50,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [gradientStart, gradientEnd],
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/analysis');
//               handleLogin();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.transparent,
//               shadowColor: Colors.transparent,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//             ),
//             child: state,
//           ),
//         ),
//         const SizedBox(height: 20),
//         Text(loc.orLoginWith, style: const TextStyle(color: Colors.white70)),
//         const SizedBox(height: 20),
//         // زر Google
//         OutlinedButton.icon(
//           onPressed: _isSigningIn ? null : _handleGoogleSignIn,
//           icon:
//               _isSigningIn
//                   ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   )
//                   // Placeholder for the Google logo image
//                   : const Icon(
//                     Icons.g_mobiledata,
//                     size: 30,
//                     color: Colors.white,
//                   ),

//           label: Text(
//             _isSigningIn ? loc.signingIn : loc.google,
//             style: const TextStyle(color: Colors.white, fontSize: 16),
//           ),
//           style: OutlinedButton.styleFrom(
//             side: const BorderSide(color: Colors.white30),
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             minimumSize: const Size(double.infinity, 50),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRegisterLink(AppLocalizations loc) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(loc.noAccount, style: const TextStyle(color: Colors.white70)),
//         TextButton(
//           onPressed: () {
//             Navigator.pushNamed(context, '/register');
//           },
//           child: Text(
//             loc.registerNow,
//             style: const TextStyle(
//               color: gradientEnd,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:matchifiy/main.dart';
import 'package:matchifiy/services/app_localizations.dart';
import 'package:matchifiy/services/auth_service.dart';
import 'package:matchifiy/services/token_storage.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF1E1E2E);
  static const Color inputFieldBg = Color(0xFF28283D);
  static const Color gradientStart = Color(0xFF8A2BE2);
  static const Color gradientEnd = Color(0xFFE0B0FF);
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // دالة تبديل اللغة وتحديث حالة التطبيق بالكامل
  void _toggleLanguage() {
    final currentLocale = Localizations.localeOf(context);
    final newLocale =
        currentLocale.languageCode == 'ar'
            ? const Locale('en', '')
            : const Locale('ar', '');

    // استدعاء الميثود الموجودة في MyApp
    MyApp.of(context).setLocale(newLocale);
  }

  Future<void> _handleSignIn() async {
    final loc = AppLocalizations.of(context);

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.pleaseFillFields)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result != null && result.containsKey('token')) {
        await TokenStorage.saveToken(result['token']);
        // Navigator.pushReplacementNamed(context, '/analysis');
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.loginFailedMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loc.error}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: _toggleLanguage,
              child: Text(
                isArabic ? 'English' : 'العربية',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                loc.welcomeTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // قسم الأخبار (تم استبدال النصوص المفقودة بنصوص ثابتة لتجنب الخطأ)
              // _buildLatestNewsSection(isArabic),
              const SizedBox(height: 30),

              _buildTextField(
                label: loc.email,
                controller: _emailController,
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),

              _buildTextField(
                label: loc.password,
                controller: _passwordController,
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 10),

              Align(
                alignment:
                    isArabic ? Alignment.centerLeft : Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    loc.forgotPassword,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildSignInButton(loc.signIn),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    loc.noAccount + " ",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text(
                      loc.registerNow,
                      style: const TextStyle(
                        color: AppColors.gradientEnd,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildLatestNewsSection(bool isArabic) {
  //   String title = isArabic ? "آخر الأخبار" : "Latest News";
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             title,
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           const Icon(Icons.newspaper, color: AppColors.gradientEnd, size: 20),
  //         ],
  //       ),
  //       const SizedBox(height: 12),
  //       SizedBox(
  //         height: 140,
  //         child: ListView(
  //           scrollDirection: Axis.horizontal,
  //           children: [
  //             _buildNewsCard(
  //               isArabic ? "تحليل مباريات اليوم" : "Today's Match Analysis",
  //               "https://via.placeholder.com/300x150/8A2BE2/FFFFFF?text=Sports+News",
  //             ),
  //             _buildNewsCard(
  //               isArabic ? "توقعات الذكاء الاصطناعي" : "AI Predictions",
  //               "https://via.placeholder.com/300x150/E0B0FF/333333?text=AI+Football",
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildNewsCard(String title, String imageUrl) {
  //   return Container(
  //     width: 240,
  //     margin: const EdgeInsets.symmetric(horizontal: 8),
  //     decoration: BoxDecoration(
  //       color: AppColors.inputFieldBg,
  //       borderRadius: BorderRadius.circular(15),
  //       border: Border.all(color: Colors.white10),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         ClipRRect(
  //           borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
  //           child: Image.network(
  //             imageUrl,
  //             height: 80,
  //             width: double.infinity,
  //             fit: BoxFit.cover,
  //             errorBuilder:
  //                 (context, error, stackTrace) => Container(
  //                   height: 80,
  //                   color: Colors.grey[800],
  //                   child: const Icon(
  //                     Icons.image_not_supported,
  //                     color: Colors.white24,
  //                   ),
  //                 ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             title,
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,
  //             style: const TextStyle(color: Colors.white, fontSize: 12),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: AppColors.gradientEnd),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                  onPressed:
                      () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                )
                : null,
        filled: true,
        fillColor: AppColors.inputFieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSignInButton(String text) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        // onPressed: () {
        //   // Navigator.pushReplacementNamed(context, '/analysis');
        //   Navigator.pushReplacementNamed(context, '/home');
        // },
        onPressed: _isLoading ? null : _handleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            _isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  text,
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
