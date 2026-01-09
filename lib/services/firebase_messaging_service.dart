// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseMessagingService {
//   static final _firebaseMessaging = FirebaseMessaging.instance;

//   static Future<String?> init() async {
//     // طلب الإذن
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // جلب التوكن
//     String? token = await _firebaseMessaging.getToken();
//     print("FCM TOKEN: $token");

//     return token;
//   }
// }
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<String?> init() async {
    // طلب الإذن
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }

    // جلب FCM token
    String? token = await _fcm.getToken();
    print("FCM TOKEN: $token");
    return token;
  }
}
