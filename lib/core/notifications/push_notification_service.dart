import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IPushNotificationService {
  Future<void> initialize();
  Future<void> registerToken();
}

@LazySingleton(as: IPushNotificationService)
class PushNotificationService implements IPushNotificationService {
  final SupabaseClient _supabaseClient;

  PushNotificationService(this._supabaseClient);

  bool get _isFirebaseInit => Firebase.apps.isNotEmpty;

  @override
  Future<void> initialize() async {
    if (!_isFirebaseInit) {
      debugPrint('PUSH NOTIFICATIONS: Firebase not initialized. Push notifications will be disabled. '
                 'Please add google-services.json (Android) or GoogleService-Info.plist (iOS) to enable.');
      return;
    }
    
    try {
      final messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Handle background messaging or token refreshes here
        FirebaseMessaging.instance.onTokenRefresh.listen((token) {
          _uploadToken(token);
        });
      }
    } catch (e) {
      debugPrint('PUSH NOTIFICATIONS: Error during initialization: $e');
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
    } catch (_) {}
  }

  Future<void> _uploadToken(String token) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabaseClient.from('user_devices').upsert({
        'user_id': userId,
        'fcm_token': token,
      });
    } catch (_) {
      // Avoid failing silently in dev but log appropriately
    }
  }
}
