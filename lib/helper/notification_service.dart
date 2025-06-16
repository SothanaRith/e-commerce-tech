// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   // Initialize the service
//   Future<void> initialize() async {
//     // Request permission for iOS notifications
//     NotificationSettings settings = await _firebaseMessaging.requestPermission();
//     print("Notification Permission: ${settings.authorizationStatus}");
//
//     // Get the FCM token after permission is granted
//     String? fcmToken = await _firebaseMessaging.getToken();
//     print("FCM Token: $fcmToken");
//
//     // Configure local notifications plugin for iOS and Android
//     var initializationSettingsAndroid = AndroidInitializationSettings('app_icon'); // Android icon
//
//     // Initialize for iOS without `IOSInitializationSettings`
//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//
//     // Initialize the plugin
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//     // Handle foreground notifications
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Received message in foreground: ${message.notification?.title}");
//       _showNotification(message.notification?.title, message.notification?.body);
//     });
//
//     // Handle background notifications
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
//
//   // Handle foreground notifications
//   Future<void> _showNotification(String? title, String? body) async {
//     var androidDetails = AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       importance: Importance.max,
//     );
//     var notificationDetails = NotificationDetails(android: androidDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//       0, // Notification ID
//       title, // Notification title
//       body, // Notification body
//       notificationDetails,
//     );
//   }
//
//   // Background handler
//   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     print("Handling background message: ${message.notification?.title}, ${message.notification?.body}");
//   }
//
//   // iOS local notification handler (required for iOS)
//   Future<void> onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     print('iOS Local Notification received: $title, $body');
//   }
// }
