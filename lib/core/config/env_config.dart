import 'dart:io';
import 'package:flutter/foundation.dart';

class EnvConfig {
  static String get _rawSupabaseUrl =>
      const String.fromEnvironment('SUPABASE_URL');
  static String get supabaseUrl {
    if (_rawSupabaseUrl.isEmpty) {
      throw Exception(
        'SUPABASE_URL is required. Set via --dart-define=SUPABASE_URL=...',
      );
    }
    return _rawSupabaseUrl;
  }

  static String get _rawSupabaseKey =>
      const String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  static String get supabasePublishableKey {
    if (_rawSupabaseKey.isEmpty) {
      throw Exception(
        'SUPABASE_PUBLISHABLE_KEY is required. Set via --dart-define=SUPABASE_PUBLISHABLE_KEY=...',
      );
    }
    return _rawSupabaseKey;
  }

  static String get _rawRazorpayId =>
      const String.fromEnvironment('RAZORPAY_KEY_ID');
  static String get razorpayKeyId {
    if (_rawRazorpayId.isEmpty) {
      throw Exception(
        'RAZORPAY_KEY_ID is required. Set via --dart-define=RAZORPAY_KEY_ID=...',
      );
    }
    return _rawRazorpayId;
  }

  static String get _rawRazorpaySecret =>
      const String.fromEnvironment('RAZORPAY_KEY_SECRET');
  static String get razorpayKeySecret =>
      _rawRazorpaySecret.isEmpty ? '' : _rawRazorpaySecret;

  static String get _rawSentryDsn => const String.fromEnvironment('SENTRY_DSN');
  static String get sentryDsn => _rawSentryDsn.isEmpty ? '' : _rawSentryDsn;

  static String get _rawAppEnv => const String.fromEnvironment('APP_ENV');
  static String get appEnv => _rawAppEnv.isEmpty ? 'development' : _rawAppEnv;

  static String get _rawRcAndroid =>
      const String.fromEnvironment('REVENUECAT_ANDROID_KEY');
  static String get revenueCatAndroidApiKey => _rawRcAndroid;

  static String get _rawRcIos =>
      const String.fromEnvironment('REVENUECAT_IOS_KEY');
  static String get revenueCatIosApiKey => _rawRcIos;

  static bool get isRevenueCatEnabled {
    final key = kIsWeb
        ? ''
        : (Platform.isAndroid ? revenueCatAndroidApiKey : revenueCatIosApiKey);
    return key.isNotEmpty;
  }

  static bool get isRazorpayEnabled {
    return razorpayKeyId.isNotEmpty && !razorpayKeyId.contains('xxxxxxxx');
  }

  static bool get hasPaymentKeys {
    return razorpayKeyId.isNotEmpty &&
        (Platform.isAndroid
            ? revenueCatAndroidApiKey.isNotEmpty
            : revenueCatIosApiKey.isNotEmpty);
  }
}
