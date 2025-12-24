import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _tokenkey = 'token';
  // static const _rolekey = 'user_role';
  // static const _userrId = 'user_id';
  static const _deviceTokenKey = 'device_token';

  static const String _ipAddress =
      // 'http://172.70.70.17:8000';
      // '192.168.116.40';
      // 'https://b74abc0a53c4.ngrok-free.app';
      'https://d6d468beee88.ngrok-free.app';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenkey, token);
  }

  // static Future<void> saveRole(String role) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_rolekey, role);
  // }

  // static Future<void> saveUserrId(String userrId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_userrId, userrId);
  // }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenkey);
  }

  // static Future<String?> getRole() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_rolekey);
  // }

  // static Future<String?> getUserrId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_userrId);
  // }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenkey);
    // await prefs.remove(_rolekey);
    // await prefs.remove(_userrId);
    await prefs.remove(_deviceTokenKey);
  }

  static String getIp() {
    return _ipAddress;
  }

  static Future<void> saveDeviceToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceTokenKey, token);
  }

  static Future<String?> getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceTokenKey);
  }
}
