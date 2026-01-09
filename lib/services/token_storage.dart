// import 'package:shared_preferences/shared_preferences.dart';

// class TokenStorage {
//   static const _tokenkey = 'token';
//   // static const _rolekey = 'user_role';
//   // static const _userrId = 'user_id';
//   static const _deviceTokenKey = 'device_token';

//   static const String _ipAddress =
//       // 'http://172.70.70.17:8000';
//       // '192.168.116.40';
//       // 'https://b74abc0a53c4.ngrok-free.app';
//       'https://d6d468beee88.ngrok-free.app';

//   static Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_tokenkey, token);
//   }

//   // static Future<void> saveRole(String role) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   await prefs.setString(_rolekey, role);
//   // }

//   // static Future<void> saveUserrId(String userrId) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   await prefs.setString(_userrId, userrId);
//   // }

//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_tokenkey);
//   }

//   // static Future<String?> getRole() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   return prefs.getString(_rolekey);
//   // }

//   // static Future<String?> getUserrId() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   return prefs.getString(_userrId);
//   // }

//   static Future<void> deleteToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_tokenkey);
//     // await prefs.remove(_rolekey);
//     // await prefs.remove(_userrId);
//     await prefs.remove(_deviceTokenKey);
//   }

//   static String getIp() {
//     return _ipAddress;
//   }

//   static Future<void> saveDeviceToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_deviceTokenKey, token);
//   }

//   static Future<String?> getDeviceToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_deviceTokenKey);
//   }
// }
// import 'package:shared_preferences/shared_preferences.dart';

// class TokenStorage {
//   static const _tokenkey = 'token';
//   static const _fcm_tokenkey = 'fcm_token';
//   static const _deviceTokenKey = 'device_token';

//   // مفاتيح بيانات المستخدم الجديدة
//   static const _userNameKey = 'name';
//   static const _userEmailKey = 'email';
//   static const _userHandleKey = 'username';
//   static const _userRoleKey = 'role';

//   // static const String _ipAddress = 'http://192.168.116.35:8000';
// static const String _ipAddress =
//     'https://reflective-clifton-phylacterical.ngrok-free.dev';
//   static const String _ipAddress = 'https://8c5a438516d0.ngrok-free.app';

//   // حفظ بيانات المستخدم كاملة
//   static Future<void> saveUserData({
//     required String name,
//     required String email,
//     required String username,
//     required String role,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_userNameKey, name!);
//     await prefs.setString(_userEmailKey, email!);
//     await prefs.setString(_userHandleKey, username!);
//     await prefs.setString(_userRoleKey, role!);
//   }

//   // جلب بيانات المستخدم كـ Map
//   static Future<Map<String, String>> getUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       // prefs.getString(_userNameKey),
//       // prefs.getgString(_userEmailKey,
//       // prefs.getString(_userHandleKey),
//       // 'name': prefs.getString(_userNameKey) ,
//       // 'email': prefs.getString(_userEmailKey) ,
//       // 'username': prefs.getString(_userHandleKey) ,
//       'role': prefs.getString(_userRoleKey) ?? "user",
//       'name': prefs.getString(_userNameKey) ?? "ghaleb",
//       'email': prefs.getString(_userEmailKey) ?? "ghaleb@gmail.com",
//       'username': prefs.getString(_userHandleKey) ?? "ghaleb109",
//     };
//   }

//   static Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_tokenkey, token);
//   }

//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_tokenkey);
//   }

//   static Future<void> saveRole(String role) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_tokenkey, role);
//   }

//   static Future<String?> getRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_tokenkey);
//   }

//   static Future<void> saveFcmToken(String fcmToken) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_fcm_tokenkey, fcmToken);
//   }

//   static Future<String?> getFcmToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_fcm_tokenkey);
//   }

//   static Future<void> deleteToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_tokenkey);
//     await prefs.remove(_deviceTokenKey);
//     await prefs.remove(_userNameKey);
//     await prefs.remove(_userEmailKey);
//     await prefs.remove(_userHandleKey);
//   }

//   static String getIp() {
//     return _ipAddress;
//   }

//   static Future<void> saveDeviceToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_deviceTokenKey, token);
//   }

//   static Future<String?> getDeviceToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_deviceTokenKey);
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _tokenkey = 'token';
  static const _fcm_tokenkey = 'fcm_token';
  static const _deviceTokenKey = 'device_token';

  static const _userNameKey = 'name';
  static const _userEmailKey = 'email';
  static const _userHandleKey = 'username';
  static const _userRoleKey = 'role';

  // static const String _ipAddress = 'https://8c5a438516d0.ngrok-free.app';
  static const String _ipAddress =
      'https://reflective-clifton-phylacterical.ngrok-free.dev';

  static Future<void> saveUserData({
    required String name,
    required String email,
    required String username,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userHandleKey, username);
    await prefs.setString(_userRoleKey, role);
  }

  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'role': prefs.getString(_userRoleKey) ?? "user",
      'name': prefs.getString(_userNameKey) ?? "ghaleb",
      'email': prefs.getString(_userEmailKey) ?? "ghaleb@gmail.com",
      'username': prefs.getString(_userHandleKey) ?? "ghaleb109",
    };
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenkey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenkey);
  }

  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenkey, role);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenkey);
  }

  static Future<void> saveFcmToken(String fcmToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcm_tokenkey, fcmToken);
  }

  static Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcm_tokenkey);
  }

  static Future<void> saveDeviceToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceTokenKey, token);
  }

  static Future<String?> getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceTokenKey);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenkey);
    await prefs.remove(_deviceTokenKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userHandleKey);
  }

  static String getIp() {
    return _ipAddress;
  }

  static const _lastVideoResultKey = 'last_video_result';

  static Future<void> saveLastVideoResult(String videoUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastVideoResultKey, videoUrl);
  }

  static Future<String?> getLastVideoResult() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastVideoResultKey);
  }

  static Future<void> clearLastVideoResult() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastVideoResultKey);
  }
}
