// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<User?> signInWithGoogle() async {
//     try {
//       // الخطوة 1: تسجيل الدخول في Google
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return null;

//       // الخطوة 2: الحصول على بيانات المصادقة
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // الخطوة 3: إنشاء بيانات اعتماد Firebase
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // الخطوة 4: تسجيل الدخول إلى Firebase
//       final UserCredential userCredential = await _auth.signInWithCredential(
//         credential,
//       );

//       return userCredential.user;
//     } catch (e) {
//       print(' خطأ أثناء تسجيل الدخول بـ Google: $e');
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     await _auth.signOut();
//   }
// }
