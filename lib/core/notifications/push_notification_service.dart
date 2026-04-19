import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  debugPrint('Handling a background message: ${message.messageId}');
}

abstract class IPushNotificationService {
  Future<void> initialize();
  Future<void> registerToken();
}

@LazySingleton(as: IPushNotificationService)
class PushNotificationService implements IPushNotificationService {
  final SupabaseClient _supabaseClient;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  PushNotificationService(this._supabaseClient);

  bool get _isFirebaseInit => Firebase.apps.isNotEmpty;

  @override
  Future<void> initialize() async {
    if (!_isFirebaseInit) {
      debugPrint(
        'PUSH NOTIFICATIONS: Firebase not initialized. Push notifications will be disabled.',
      );
      return;
    }

    try {
      // 1. Request Permission
      final messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        
        // 2. Setup Background Handler
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

        // 3. Setup Local Notifications for Foreground
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        
        const DarwinInitializationSettings initializationSettingsIOS =
            DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

        const InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

        await _localNotifications.initialize(
          settings: initializationSettings,
          onDidReceiveNotificationResponse: (details) {
            _handleNotificationClick(details.payload);
          },
        );

        // 4. Create Android Notification Channel
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          description: 'This channel is used for important notifications.', // description
          importance: Importance.max,
        );

        await _localNotifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        // 5. Listen to Foreground Messages
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          debugPrint('Got a message whilst in the foreground!');
          debugPrint('Message data: ${message.data}');

          if (message.notification != null) {
            debugPrint('Message also contained a notification: ${message.notification}');
            _showNotification(message, channel);
          }
        });

        // 6. Listen to Background Messages (Opened from notification)
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          debugPrint('Notification caused app to open from background state');
          _handleNotificationClick(jsonEncode(message.data));
        });

        // 7. Check if app was opened from terminated state via notification
        RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
        if (initialMessage != null) {
          debugPrint('App opened from terminated state via notification');
          _handleNotificationClick(jsonEncode(initialMessage.data));
        }

        // 8. Setup Token Refresh
        FirebaseMessaging.instance.onTokenRefresh.listen((token) {
          _uploadToken(token);
        });
      }
    } catch (e) {
      debugPrint('PUSH NOTIFICATIONS: Error during initialization: $e');
    }
  }

  void _showNotification(RemoteMessage message, AndroidNotificationChannel channel) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            // Use app logo for all notifications
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  void _handleNotificationClick(String? payload) {
    if (payload == null) return;
    try {
      final data = jsonDecode(payload);
      debugPrint('Notification clicked with data: $data');
      // Here you would navigate to the relevant screen based on data['type']
      // Example: if (data['type'] == 'chat') context.push('/messaging/chat/...')
      // Since this service doesn't have access to context, you might want to use a navigator key
      // or a custom routing service.
    } catch (e) {
      debugPrint('Error handling notification click: $e');
    }
  }

  @override
  Future<void> registerToken() async {
    if (!_isFirebaseInit) return;

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _uploadToken(token);
      }
    } catch (e) {
      debugPrint('FCM token error: $e');
    }
  }

  Future<void> _uploadToken(String token) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabaseClient.from('user_devices').upsert({
        'user_id': userId,
        'fcm_token': token,
      });
      debugPrint('FCM token uploaded/updated for user $userId');
    } catch (e) {
      debugPrint('FCM upload error: $e');
    }
  }
}
