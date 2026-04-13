# Phase 12: Launch Readiness - Validation Strategy

## Setup Instructions

In addition to standard unit and widget tests, this phase requires:

1. A mock Firebase environment or the initialization of Firebase to test Telemetry services.
2. A database schema push using `supabase db push` to verify the `fcm_tokens` migration.
3. Stubbing for Razorpay and `in_app_purchase` via dependency injection for integration tests without actual payments triggering.

## Validation Scenarios

### Scenario 1: Telemetry & Crashlytics Boot (Dimension 1 & 2)
- Action: Boot the app and trigger a deliberate state error.
- Check: Ensure `TelemetryService` invokes the wrapped Crashlytics logger and does not crash the application further.

### Scenario 2: Payment Routing (Dimension 3)
- Action: Trigger `purchasePremium(PaymentMethod.native)` and assert the Native IAP wrapper gets called.
- Action: Trigger `purchasePremium(PaymentMethod.razorpay)` and assert the Razorpay wrapper kicks off the checkout flow.

### Scenario 3: FCM Token registration (Dimension 2)
- Action: Call `PushNotificationService.registerToken(userId)`.
- Check: Database successfully upserts the FCM token for the authorized context user.

### Scenario 4: CI/CD configurations (Dimension 1)
- Action: Dry-run check of YAML syntax for `.github/workflows/build-release.yml`.
- Check: YAML is valid and actions rely on secret environment variables (no hardcoded keys).

## Known Edge Cases
- Missing Firebase initialization on Android/iOS (will throw native platform errors, ensure graceful catching for development mode where keys aren't present).
- Razorpay API failing when used in unsupported regions; UI flow should cleanly revert back to showing error snackbar.
