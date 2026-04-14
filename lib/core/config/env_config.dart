import 'dart:io';
import 'package:flutter/foundation.dart';

class EnvConfig {
  static const String _rawSupabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseUrl = _rawSupabaseUrl == '' 
    ? 'https://uqkkhpunwuvkwaqdqqtw.supabase.co' 
    : _rawSupabaseUrl;

  static const String _rawSupabaseKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  static const String supabasePublishableKey = _rawSupabaseKey == '' 
    ? 'sb_publishable_NB5BNnLb-yw5MXgYxsgHEg_PNVb1vU' 
    : _rawSupabaseKey;

  static const String _rawRazorpayId = String.fromEnvironment('RAZORPAY_KEY_ID');
  static const String razorpayKeyId = _rawRazorpayId == '' ? '' : _rawRazorpayId;

  static const String _rawRazorpaySecret = String.fromEnvironment('RAZORPAY_KEY_SECRET');
  static const String razorpayKeySecret = _rawRazorpaySecret == '' ? '' : _rawRazorpaySecret;

  static const String _rawSentryDsn = String.fromEnvironment('SENTRY_DSN');
  static const String sentryDsn = _rawSentryDsn == '' ? '' : _rawSentryDsn;

  static const String _rawAppEnv = String.fromEnvironment('APP_ENV');
  static const String appEnv = _rawAppEnv == '' ? 'development' : _rawAppEnv;

  static const String _rawRcAndroid = String.fromEnvironment('REVENUECAT_ANDROID_KEY');
  static const String revenueCatAndroidApiKey = _rawRcAndroid == '' 
    ? 'test_RnzMxenaKYDjtHvSBRlaqyoVGIx' 
    : _rawRcAndroid;

  static const String _rawRcIos = String.fromEnvironment('REVENUECAT_IOS_KEY');
  static const String revenueCatIosApiKey = _rawRcIos == '' 
    ? 'test_RnzMxenaKYDjtHvSBRlaqyoVGIx' 
    : _rawRcIos;

  static bool get isRevenueCatEnabled {
    final key = kIsWeb ? '' : (Platform.isAndroid ? revenueCatAndroidApiKey : revenueCatIosApiKey);
    return key.isNotEmpty && 
           !key.contains('xxxxxxxx') && 
           !key.startsWith('test_');
  }

  static bool get isRazorpayEnabled {
    return razorpayKeyId.isNotEmpty && !razorpayKeyId.contains('xxxxxxxx');
  }
}
