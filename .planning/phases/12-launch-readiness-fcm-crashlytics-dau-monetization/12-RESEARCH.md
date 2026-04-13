# Phase 12: Launch Readiness - Technical Research

## Objective
Research the technical implementation requirements for Firebase Cloud Messaging (FCM), Crashlytics, DAU Telemetry, App Store Pipelines, and a mixed Monetization strategy using `in_app_purchase` and Razorpay.

## Area 1: Firebase Analytics & Crashlytics
1. **Firebase Setup:** Flutter requires the `firebase_core`, `firebase_analytics`, and `firebase_crashlytics` packages. The flutterfire CLI should be run, but for our planning purposes, we will architect the wrappers so the actual project can generate `firebase_options.dart` securely without committing keys.
2. **DAU Tracking:** DAU is automatically collected out of the box by Firebase Analytics via `logEvent`. We will architect a `TelemetryService` interface that abstracts Firebase to avoid tight coupling in our UI layer.
3. **Crashlytics:** Needs `FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError` in `main.dart` and `PlatformDispatcher.instance.onError` to catch asynchronous errors.

## Area 2: Push Notifications (FCM + Supabase)
1. **Package:** `firebase_messaging` with a generic wrapper `PushNotificationService`.
2. **Data Model:** We will expand Supabase schema. FCM device tokens need to be stored alongside users `user_id`, `fcm_token`. We'll write an SQL migration `0008_fcm_tokens.sql`.
3. **Trigger Logic:** Given the project uses Supabase, sending FCM pushes can be triggered either natively by Supabase Edge Functions listening to Database Webhooks (when a message is created), or through Flutter backend calls. The Edge Function approach is best for real-time offline delivery to other users.

## Area 3: Monetization (Native IAP vs Razorpay)
1. **Requirements:** User can choose native Play Store/App Store checkout (`in_app_purchase`) OR an external checkout (`razorpay_flutter`).
2. **Architecture:** 
    - `BillingService` interface exposing `Future<Either<Failure, void>> purchasePremium(PaymentMethod method)`
    - Two implementations / internal routing: `NativeIAPStrategy` and `RazorpayStrategy`.
    - Verification: Native purchases verify receipts against App Store. Razorpay verifies signatures on the backend. This requires an Edge Function `/verify-payment` that updates a user's subscription tier in Supabase `users.subscription_tier`.
    - We will need a `users.subscription_tier` DB column.

## Area 4: App Store Guidelines & Pipelines
1. **Pipelines:** Setting up default `.github/workflows/build-release.yml` with `fastlane` patterns for distributing to TestFlight and Google Play Internal.
2. **App Store Guidelines compliance:** Apple strictly reviews apps using external payment gateways. We must defensively design the UI so the Razorpay alternative complies with Apple's anti-steering guidelines (which may only allow link-outs or be geofenced, but for MVP we will build the UI choice natively).

## Validation Architecture
- **Dimension 1 (System State):** Are exceptions caught and sent to Crashlytics? Do tables exist for `fcm_tokens` and `subscription_tier`?
- **Dimension 2 (Data Fidelity):** Analytics `TelemetryService` properly tracks navigation changes without UI coupling.
- **Dimension 3 (Integration):** Billing interface elegantly delegates to Razorpay or Native IAP based on user choice enum.
- **Dimension 4 (UI/UX):** Payments screen adheres to `AppTheme`.

## Recommended Plan Breakdown (gsd-planner input)
1. **12-01**: Firebase Setup & Telemetry (Crashlytics, DAU abstraction).
2. **12-02**: Notifications Infrastructure (FCM tokens migration, listeners).
3. **12-03**: Payment Logic & Billing module (Razorpay + IAP wrappers, Edge Function for verification).
4. **12-04**: Payments UI & Pipeline definitions (Fastlane/GH Actions).
