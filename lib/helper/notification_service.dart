import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize Firebase Messaging
  Future<void> initialize() async {
    // For iOS, request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print("Notification Permission: ${settings.authorizationStatus}");

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground notifications
    FirebaseMessaging.onMessage.listen(_onMessageReceived);

    // Get the FCM token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Configure local notifications plugin
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Handle incoming foreground messages
  Future<void> _onMessageReceived(RemoteMessage message) async {
    print("Received notification: ${message.notification?.title}, ${message.notification?.body}");

    // Show notification
    showNotification(message.notification?.title, message.notification?.body);
  }

  // Show notification using flutter_local_notifications
  Future<void> showNotification(String? title, String? body) async {
    var androidDetails = AndroidNotificationDetails(
        'channel_id', 'channel_name', importance: Importance.max);
    var notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  // Background handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.notification?.title}, ${message.notification?.body}");
  }
}
