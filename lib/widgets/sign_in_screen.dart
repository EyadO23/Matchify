import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:matchifiy/services/auth_service.dart';
import 'package:matchifiy/services/token_storage.dart';

// تحويل الشاشة إلى StatefulWidget للتحكم بالحالة والعمليات غير المتزامنة
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // ********** الألوان المستخدمة (Colors) **********
  static const Color primaryDark = Color(0xFF1E1E2E);
  static const Color inputFieldBg = Color(0xFF28283D);
  static const Color gradientStart = Color(0xFF8A2BE2);
  static const Color gradientEnd = Color(0xFFE0B0FF);

  Widget state = const Text(
    'SIGN IN',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
  // const Text('LOGIN', style: TextStyle(color: Colors.white));

  bool _isSigningIn = false; // لمؤشر التحميل على زر جوجل
  bool _obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void restate() {
    setState(() {
      state = const Text(
        'SIGN IN',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
      //const Text('SIGN IN', style: TextStyle(color: Colors.white));
    });
  }

  void handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور'),
        ),
      );
      restate();
      return;
    }

    // if (!ContractorValidator.isEmailValid(email)) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('يرجى إدخال بريد إلكتروني صالح')),
    //   );
    //   restate();
    //   return;
    // }

    final result = await AuthService.login(email, password);
    log(result.toString());
    if (result != null) {
      final token = result['token'];
      final role = result['role'];
      final userId = result['user_id'];
      // log(token);
      await TokenStorage.saveToken(token);
      // await TokenStorage.saveRole(role);
      // await TokenStorage.saveUserrId(userId.toString());

      // await FirebaseMessagingService().init();

      Navigator.pushReplacementNamed(context, '/analysis');
    } else {
      restate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('البريد الإلكتروني أو كلمة المرور غير صحيحة'),
        ),
      );
    }
  }

  //////
  ///
  // Future<void> _handleGoogleSignIn() async {
  //   setState(() {
  //     _isSigningIn = true;
  //   });

  //   try {
  //     //  تسجيل الدخول عبر Google
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     if (googleUser == null) {
  //       setState(() => _isSigningIn = false);
  //       return;
  //     }

  //     final googleAuth = await googleUser.authentication;

  //     //  إنشاء Credential لـ Firebase
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final userCredential = await FirebaseAuth.instance.signInWithCredential(
  //       credential,
  //     );

  //     final firebaseUser = userCredential.user;

  //     if (firebaseUser == null) {
  //       throw Exception("Firebase user is null");
  //     }

  //     //  انتقل للشاشة التالية فور نجاح تسجيل الدخول
  //     if (mounted) {
  //       Navigator.pushReplacementNamed(context, '/analysis');
  //     }

  //     //  أرسل التوكين للباكند في الخلفية
  //     final idToken = await firebaseUser.getIdToken();
  //     print(" Firebase ID Token (sending in background): $idToken");

  //     // fire-and-forget: لا ننتظر الرد
  //     AuthService.sendFirebaseIdToken(idToken!)
  //         .then((response) {
  //           if (response != null && response["success"] == true) {
  //             log(" Backend accepted Firebase ID Token");
  //             TokenStorage.saveToken(response["token"]);
  //           } else {
  //             log(" Backend rejected Firebase ID Token");
  //           }
  //         })
  //         .catchError((e) {
  //           log(" Error sending Firebase ID Token: $e");
  //         });
  //   } catch (e) {
  //     log("Google Sign In Error: $e");
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Failed to sign in: $e')));
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isSigningIn = false);
  //     }
  //   }
  // }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      // تسجيل الدخول عبر Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        setState(() => _isSigningIn = false);
        return;
      }

      final googleAuth = await googleUser.authentication;

      // إنشاء Credential لـ Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final firebaseUser = userCredential.user;

      // 🔥 هذا التوكين الذي يجب إرساله للباك (Firebase ID Token)
      final idToken = await firebaseUser?.getIdToken();

      print(" Firebase ID Token: $idToken");

      //  أرسل التوكين إلى الباك عبر AuthService
      final response = await AuthService.sendFirebaseIdToken(idToken!);

      print(" Backend Response: $response");

      if (response != null && response["success"] == true) {
        // خزّن التوكين إذا كنت تحتاجه
        await TokenStorage.saveToken(response["token"]);

        // انتقل للصفحة التالية
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/analysis');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google login failed on backend')),
        );
      }
    } catch (e) {
      print("Google Sign In Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to sign in: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSigningIn = false);
      }
    }
  }

  // **************************************************
  // ********** منطق تسجيل الدخول عبر جوجل ************
  // **************************************************
  // Future<void> _handleGoogleSignIn() async {
  //   setState(() {
  //     _isSigningIn = true; // تفعيل مؤشر التحميل
  //   });

  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     // إذا ألغى المستخدم عملية تسجيل الدخول
  //     if (googleUser == null) {
  //       setState(() {
  //         _isSigningIn = false;
  //       });
  //       return;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // إنشاء بيانات الاعتماد الخاصة بـ Firebase
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // تسجيل الدخول باستخدام Firebase
  //     await FirebaseAuth.instance.signInWithCredential(credential);

  //     // إذا نجح تسجيل الدخول: الانتقال إلى شاشة التحليل
  //     if (mounted) {
  //       Navigator.pushReplacementNamed(context, '/analysis');
  //     }
  //   } on Exception catch (e) {
  //     // إظهار رسالة خطأ للمستخدم (يمكنك استخدام SnackBar)
  //     print("Google Sign In Error: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to sign in with Google: $e')),
  //     );
  //   } finally {
  //     // إيقاف مؤشر التحميل دائماً
  //     if (mounted) {
  //       setState(() {
  //         _isSigningIn = false;
  //       });
  //     }
  //   }
  // }

  //   Future<void> _handleGoogleSignIn() async {
  //   setState(() {
  //     _isSigningIn = true;
  //   });

  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     if (googleUser == null) {
  //       setState(() => _isSigningIn = false);
  //       return;
  //     }

  //     final googleAuth = await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     final firebaseUser = userCredential.user;

  //     //  هذا ما يحتاجه الباكند
  //     final idToken = await firebaseUser?.getIdToken();

  //     print(" Firebase ID Token: $idToken");

  //     // إرسال التوكن للباك
  //     final response = await http.post(
  //       Uri.parse("http://YOUR_BACKEND/api/google-login"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"id_token": idToken}),
  //     );

  //     print("📌 Backend Response: ${response.body}");

  //     if (mounted) {
  //       Navigator.pushReplacementNamed(context, '/analysis');
  //     }
  //   } catch (e) {
  //     print("Google Sign In Error: $e");
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Failed to sign in: $e')));
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isSigningIn = false);
  //     }
  //   }
  // }

  // **************************************************
  // ********** بناء واجهة المستخدم (UI) *************
  // **************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      body: Stack(
        children: <Widget>[
          _buildBackgroundImage(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildWelcomeSection(),
                  const SizedBox(height: 30),
                  _buildInputFields(),
                  const SizedBox(height: 15),
                  _buildForgotPasswordLink(),
                  const SizedBox(height: 30),
                  _buildSignInButtons(context),
                  const SizedBox(height: 40),
                  _buildRegisterLink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ... (باقي دوال البناء مثل _buildBackgroundImage و _buildWelcomeSection تبقى كما هي) ...

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: Image.asset('assets/background_image.png', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to\nMatchify',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Enter your email address and password to use the application',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: const TextStyle(color: Colors.white70),
            fillColor: inputFieldBg,

            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        TextFormField(
          obscureText: _obscurePassword,
          controller: passwordController,

          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: const TextStyle(color: Colors.white70),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            // suffixIcon: const Icon(Icons.remove_red_eye, color: Colors.white70),
            fillColor: inputFieldBg,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSignInButtons(BuildContext context) {
    return Column(
      children: [
        // زر التسجيل الرئيسي (SIGN IN) - لا يزال وهمياً
        Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [gradientStart, gradientEnd],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                state = const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                );
              });
              handleLogin();
              // هذا هو الانتقال الوهمي الذي طلبته
              // Navigator.pushReplacementNamed(context, '/analysis');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: state,
            //  const Text(
            //   'SIGN IN',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Or Login With', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 20),
        // زر Google - أصبح يعمل الآن مع Firebase
        OutlinedButton.icon(
          // منع الضغط إذا كانت عملية التسجيل جارية
          onPressed: _isSigningIn ? null : _handleGoogleSignIn,

          icon:
              _isSigningIn
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Image.asset(
                    'assets/google_logo.png',
                    height: 24,
                    width: 24,
                  ),

          label: Text(
            _isSigningIn ? 'Signing In...' : 'Google',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white30),
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white70),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
            // ... الانتقال لشاشة التسجيل
          },
          child: const Text(
            'Register Now',
            style: TextStyle(color: gradientEnd, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
