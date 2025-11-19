// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/auth_service.dart';
// import 'package:matchifiy/services/token_storage.dart';
// import '../services/google_sign_in_service.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final GoogleAuthService _googleAuthService = GoogleAuthService();

//   Widget state = const Text('LOGIN', style: TextStyle(color: Colors.white));
//   bool _obscurePassword = true;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   void restate() {
//     setState(() {
//       state = const Text('LOGIN', style: TextStyle(color: Colors.white));
//     });
//   }

//   void handleLogin() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور'),
//         ),
//       );
//       restate();
//       return;
//     }

//     // if (!ContractorValidator.isEmailValid(email)) {
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     const SnackBar(content: Text('يرجى إدخال بريد إلكتروني صالح')),
//     //   );
//     //   restate();
//     //   return;
//     // }

//     final result = await AuthService.login(email, password);

//     if (result != null) {
//       final token = result['token'];
//       final role = result['role'];
//       final userId = result['user_id'];

//       await TokenStorage.saveToken(token);
//       // await TokenStorage.saveRole(role);
//       // await TokenStorage.saveUserrId(userId.toString());

//       // await FirebaseMessagingService().init();

//       Navigator.pushReplacementNamed(context, '/tendersScreen');
//     } else {
//       restate();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('البريد الإلكتروني أو كلمة المرور غير صحيحة'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: ElevatedButton.icon(
//           icon: Image.asset('assets/google_logo.png', height: 24),
//           label: const Text("تسجيل الدخول عبر Google"),
//           onPressed: () async {
//             print(" بدأ تسجيل الدخول");
//             final user = await _googleAuthService.signInWithGoogle();
//             print(" تم الانتهاء من signInWithGoogle");
//             if (user != null) {
//               print(" تم تسجيل الدخول: ${user.displayName}");
//             } else {
//               print(" المستخدم لم يسجل الدخول");
//             }
//           },

//           // onPressed: () async {
//           //   final user = await _googleAuthService.signInWithGoogle();
//           //   if (user != null) {
//           //     print(" تم تسجيل الدخول: ${user.displayName}");
//           //     // انتقل إلى الصفحة الرئيسية أو احفظ المستخدم في الباكند
//           //   }
//           // },
//         ),
//       ),
//     );
//   }
// }
