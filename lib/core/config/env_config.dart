class EnvConfig {
  static final String _rawSupabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  static final String supabaseUrl = _rawSupabaseUrl.isEmpty 
    ? 'https://uqkkhpunwuvkwaqdqqtw.supabase.co' 
    : _rawSupabaseUrl;

  static final String _rawSupabaseKey = const String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  static final String supabasePublishableKey = _rawSupabaseKey.isEmpty 
    ? 'sb_publishable_NB5BNnLb-yw5MXgYxsgHEg_PNVb1vU' 
    : _rawSupabaseKey;

  static final String _rawRazorpayId = const String.fromEnvironment('RAZORPAY_KEY_ID');
  static final String razorpayKeyId = _rawRazorpayId.isEmpty ? '' : _rawRazorpayId;

  static final String _rawRazorpaySecret = const String.fromEnvironment('RAZORPAY_KEY_SECRET');
  static final String razorpayKeySecret = _rawRazorpaySecret.isEmpty ? '' : _rawRazorpaySecret;

  static final String _rawSentryDsn = const String.fromEnvironment('SENTRY_DSN');
  static final String sentryDsn = _rawSentryDsn.isEmpty ? '' : _rawSentryDsn;

  static final String _rawAppEnv = const String.fromEnvironment('APP_ENV');
  static final String appEnv = _rawAppEnv.isEmpty ? 'development' : _rawAppEnv;

  static final String _rawRcAndroid = const String.fromEnvironment('REVENUECAT_ANDROID_KEY');
  static final String revenueCatAndroidApiKey = _rawRcAndroid.isEmpty 
    ? 'test_RnzMxenaKYDjtHvSBRlaqyoVGIx' 
    : _rawRcAndroid;

  static final String _rawRcIos = const String.fromEnvironment('REVENUECAT_IOS_KEY');
  static final String revenueCatIosApiKey = _rawRcIos.isEmpty 
    ? 'test_RnzMxenaKYDjtHvSBRlaqyoVGIx' 
    : _rawRcIos;
}
