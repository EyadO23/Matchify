import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:matchifiy/services/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<void> signInWithGoogle() async {
//   final ip = TokenStorage.getIp();

//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//   if (googleUser == null) return; // المستخدم ألغى تسجيل الدخول

//   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//   final idToken = googleAuth.idToken;

//   // إرسال الـ ID Token إلى الباكند
//   final response = await http.post(
//     Uri.parse('$ip/api/firebase-login'),
//     headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
//     body: jsonEncode({'id_token': idToken}),
//   );

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     final token = data['token'];

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);

//     // الآن التوكن جاهز للاستخدام في كل طلبات الـ API
//   }
//   // if (response.statusCode == 200) {
//   //   final data = jsonDecode(response.body);
//   //   print('Token from Laravel: ${data['token']}');
//   // }
//   else {
//     print('Login failed: ${response.body}');
//   }
// }
Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  if (googleUser == null) {
    throw Exception("User cancelled Google Sign-In");
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}
