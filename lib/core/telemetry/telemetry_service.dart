import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';

abstract class ITelemetryService {
  Future<void> logEvent(String name, {Map<String, Object>? parameters});
  Future<void> logError(dynamic exception, StackTrace stack, {dynamic reason});
  Future<void> setUserId(String userId);
}

@LazySingleton(as: ITelemetryService)
class FirebaseTelemetryService implements ITelemetryService {
  bool get _isInitialized => Firebase.apps.isNotEmpty;

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (!_isInitialized) return;
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      // Swallow exceptions to prevent telemetry from crashing the app
    }
  }

  @override
  Future<void> logError(dynamic exception, StackTrace stack, {dynamic reason}) async {
    if (!_isInitialized) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        exception,
        stack,
        reason: reason,
        fatal: false,
      );
    } catch (e) {
      // Swallow
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    if (!_isInitialized) return;
    try {
      await FirebaseAnalytics.instance.setUserId(id: userId);
      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    } catch (e) {
      // Swallow
    }
  }
}
