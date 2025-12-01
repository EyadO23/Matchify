// لضمان استخدام مكتبة التحويل الأساسية
import 'dart:convert';

class User {
  final int id;
  final String name; // <--- تم إضافة حقل الاسم الكامل
  final String username;
  final String email;
  final String? profilePictureUrl;
  final String apiToken;

  User({
    required this.id,
    required this.name, // <--- مطلوب في البناء
    required this.username,
    required this.email,
    this.profilePictureUrl,
    required this.apiToken,
  });

  /// ********** دالة المصنع (Factory Constructor) للتحويل من JSON **********
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String, // يجب استلامه من السيرفر
      username: json['username'] as String,
      email: json['email'] as String,
      profilePictureUrl:
          json['profile_picture_url'] != null
              ? json['profile_picture_url'] as String
              : null,
      apiToken: json['api_token'] as String,
    );
  }

  /// ********** الدالة المستخدمة لإرسال بيانات التسجيل **********
  /// ترسل الحقول: name, username, email, password, password_confirmation
  Map<String, dynamic> toJsonForRegister(
    String password,
    String confirmPassword,
  ) {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'password_confirmation':
          confirmPassword, // تم التعديل لإرسال كلمة التأكيد
    };
  }

  /// ********** دالة التحويل إلى JSON **********
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'profile_picture_url': profilePictureUrl,
      'api_token': apiToken,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, username: $username, email: $email, token: $apiToken)';
  }
}

// // لضمان استخدام مكتبة التحويل الأساسية
// import 'dart:convert';

// class User {
//   final int id;
//    final String name;
//   final String username;
//   final String email;
//   final String? profilePictureUrl;
//   final String
//   apiToken; // رمز المصادقة (Token) الذي سيتم استخدامه للطلبات اللاحقة

//   User({
//     required this.id,
//     required this.name,
//     required this.username,
//     required this.email,
//     this.profilePictureUrl,
//     required this.apiToken,
//   });

//   /// ********** دالة المصنع (Factory Constructor) للتحويل من JSON **********
//   /// تستقبل خريطة JSON (Map<String, dynamic>) وتحولها إلى كائن User.
//   factory User.fromJson(Map<String, dynamic> json) {
//     // يجب أن تتطابق المفاتيح (Keys) هنا مع ما يرسله خادم Laravel بالضبط.
//     return User(
//       id: json['id'] as int,
//       username: json['username'] as String,
//       email: json['email'] as String,

//       // حقل اختياري
//       profilePictureUrl:
//           json['profile_picture_url'] != null
//               ? json['profile_picture_url'] as String
//               : null,

//       // ملاحظة: يتم تمرير التوكن مباشرة مع كائن المستخدم بعد المصادقة
//       apiToken: json['api_token'] as String,
//     );
//   }

//   Map<String, dynamic> toJsonForRegister(String password) {
//     return {
//       'name': username,
//       'email': email,
//       'password': password,
//       'password_confirmation': password,
//     };
//   }

//   /// ********** دالة التحويل إلى JSON **********
//   /// مفيدة عند تخزين الكائن في Shared Preferences أو إرساله
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'username': username,
//       'email': email,
//       'profile_picture_url': profilePictureUrl,
//       'api_token': apiToken,
//     };
//   }

//   // دالة مساعدة لتسهيل طباعة بيانات المستخدم
//   @override
//   String toString() {
//     return 'User(id: $id, username: $username, email: $email, token: $apiToken)';
//   }
// }
