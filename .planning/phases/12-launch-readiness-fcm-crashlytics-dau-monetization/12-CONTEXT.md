# Phase 12: Launch Readiness - Context

**Gathered:** 2026-04-14
**Status:** Ready for planning
**Source:** User Directive

<domain>
## Phase Boundary

This phase prepares the application for commercial launch by setting up core infrastructure for notifications, analytics, release pipelines, and flexible monetization. It brings the system's operational and business mechanisms up to par with the hardened application features.
</domain>

<decisions>
## Implementation Decisions

### Cloud Messaging & Notifications
- Use Firebase Cloud Messaging (FCM) for push notifications to handle iOS and Android delivery robustly.

### Analytics & Crash Tracking
- Implement Crashlytics for real-time observability of production crashes and errors.
- Implement DAU (Daily Active User) and telemetry tracking.

### Release Pipelines & Assets
- Establish processes and pipelines for App Store (iOS) and Google Play (Android) asset generation and binary submission.

### Monetization
- Support standard app store monetization via the `in_app_purchase` Flutter package for native Google Play checkout (and iOS equivalent).
- Support alternative geographical/off-store monetization using Razorpay.
- Provide the user with the explicit UI choice between using native app store purchases or Razorpay during checkouts.

### The Agent's Discretion
- Choice of analytics wrapper (Firebase Analytics natively or wrapped) for DAU.
- Boilerplate architecture for the billing module to interchangeably route through Razorpay vs native IAP.
- Exactly how the "choose payment" UI flows inside the standard theme.
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### App Foundation
- `.planning/REQUIREMENTS.md` — To ensure no deviations from original non-social media scopes.
- `lib/core/theme/app_theme.dart` — To ensure checkout UIs follow the established aesthetic.

</canonical_refs>

<specifics>
## Specific Ideas
- The user must explicitly see the fallback to Razorpay vs native `in_app_purchase`.

</specifics>

<deferred>
## Deferred Ideas
None
</deferred>
