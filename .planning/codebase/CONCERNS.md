# CONCERNS - Known Issues & Warnings

**Analysis Date:** 2026-04-12

---

## Critical Issues (Blocking)

### 1. Compile Error - ColorScheme Incomplete
- **File:** `lib/main.dart:31`
- **Current:** `colorScheme: .fromSeed(seedColor: Colors.deepPurple),`
- **Expected:** `colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),`
- **Impact:** App will not compile - syntax error prevents build

### 2. Compile Error - MainAxisAlignment Incomplete
- **File:** `lib/main.dart:105`
- **Current:** `mainAxisAlignment: .center,`
- **Expected:** `mainAxisAlignment: MainAxisAlignment.center,`
- **Impact:** App will not compile - syntax error prevents build

---

## Technical Debt

### 3. Default Flutter Template Only
- **Files:** `lib/main.dart`, `test/widget_test.dart`
- **Issue:** Project is still the default Flutter counter template, not the Tether app described in `TETHER_PRD.md`
- **Impact:** 0% of Tether features implemented. PRD specifies 75+ features:
  - Mood Rooms, Circles, Digital Hugs, Quiet Hours
  - Gratitude Journal, Reflection Wall, Safe Space Lock
  - Couples features (Our Bubble, Heartbeat, Promise Rings)
  - Family features (Safety Check, Emergency SOS, Kid Mode)
- **Fix:** Implement full Clean Architecture per PRD sections 5.1-5.3

### 4. No Clean Architecture Implementation
- **Files:** `lib/` - all code in single `main.dart`
- **Issue:** PRD specifies Clean Architecture (Domain/Data/Presentation layers) but codebase has no separation
- **Impact:** No separation of concerns, no testability, no maintainability
- **Fix:** Create folder structure per PRD section 5.2:
  ```
  lib/
  ├── core/
  │   ├── theme/          # Time-theme engine, tokens, app_theme
  │   ├── error/           # failures.dart
  │   ├── usecase/         # Base UseCase interface
  │   ├── network/         # network_info.dart
  │   └── utils/           # encryption_service.dart, time_utils.dart
  ├── features/
  │   ├── auth/            # Domain/Data/Presentation per feature
  │   ├── circles/
  │   ├── mood/
  │   ├── journal/
  │   ├── messaging/
  │   ├── feed/
  │   ├── memories/
  │   ├── wellness/
  │   ├── couples/
  │   ├── family/
  │   ├── vault/
  │   ├── calendar/
  │   └── settings/
  ├── injection_container.dart
  └── main.dart
  ```

### 5. No State Management
- **Files:** `pubspec.yaml`, `lib/`
- **Issue:** PRD specifies BLoC pattern (`flutter_bloc`) but no dependency or implementation exists
- **Impact:** Cannot implement complex features like Mood Rooms, realtime updates, presence system
- **Fix:** Add `flutter_bloc`, `get_it`, `injectable` dependencies

### 6. No Backend Integration
- **Files:** `pubspec.yaml`
- **Issue:** PRD specifies Supabase backend (Auth, Database, Storage, Realtime, Edge Functions) but no Supabase client
- **Missing packages:** `supabase_flutter`, `drift`, `hive`, `flutter_secure_storage`
- **Impact:** Cannot implement any data persistence, authentication, or realtime features
- **Fix:** Add supabase_flutter, implement data layer per PRD section 6

---

## Security Concerns

### 7. No Client-Side Encryption
- **Files:** None exist
- **Issue:** PRD specifies AES-256 client-side encryption for:
  - Reflection Wall (Feature 20)
  - Gratitude Journal (Feature 3)
  - Vault items (Feature 10)
- **Impact:** Sensitive user data would be stored plaintext
- **Fix:** Implement `lib/core/utils/encryption_service.dart` with AES-256 per PRD section 4.4

### 8. No Safe Space Lock
- **Files:** None exist
- **Issue:** Feature 10 (Safe Space Lock - biometric second-level lock for Circles/DMs/Vault)
- **Impact:** Users cannot protect sensitive content with additional authentication
- **Fix:** Implement biometric authentication wrapper using `local_auth` package

### 9. No Row-Level Security
- **Files:** None exist
- **Issue:** PRD specifies Supabase RLS policies per section 6.6 - no database schema or policies exist
- **Impact:** Data would be accessible without proper isolation between users
- **Fix:** Create Supabase SQL migrations with RLS policies

### 10. No Secure Storage for Sessions
- **Files:** None exist
- **Issue:** PRD specifies session persistence via `flutter_secure_storage` - not implemented
- **Impact:** Tokens stored insecurely or not at all
- **Fix:** Implement secure session management

---

## Performance Considerations

### 11. No Lazy Loading / Image Optimization
- **Files:** None exist
- **Issue:** Feature 25 (Slow Photo) specifies:
  - Blur-up technique (4px blurred thumbnail first, then full quality)
  - 600ms ease-in opacity fade from 0→1
  - No skeleton loaders - soft placeholder in background secondary color
- **Impact:** Images load instantly/jarringly, violating calm design principle
- **Fix:** Implement cached network image with blur-up placeholder using `cached_network_image`

### 12. No Offline Support
- **Files:** None exist
- **Issue:** PRD mentions Drift/Hive for local caching - not implemented
- **Impact:** App requires constant network, poor UX when offline
- **Fix:** Implement local database layer for offline-first experience

### 13. No Time-Adaptive Theme Engine
- **Files:** None exist
- **Issue:** PRD section 4.1 specifies 4 time slots with automatic color transitions:
  - Morning (5AM-11:59AM): warm linen white, terracotta accents
  - Afternoon (12PM-5:29PM): light cream, golden amber
  - Evening (5:30PM-8:59PM): deep plum-black, sunset orange
  - Night (9PM-4:59AM): near-black navy, periwinkle blue
- **Impact:** UI does not match PRD vision of calm, breathing app
- **Fix:** Implement `lib/core/theme/time_theme_engine.dart`

---

## Feature Gaps

### 14. Feature Coverage: 0%
- **Files:** Entire codebase
- **Issue:** All 75+ features from PRD unimplemented
- **Risk:** Complete feature parity gap - app does nothing described in requirements
- **Priority:** Critical

### 15. No Time-Adaptive Color Palettes
- **What's missing:** Per PRD section 4.1 - 4 time slots with distinct color schemes
- **Risk:** UI static, no "breathing" feel

### 16. No Typography System
- **What's missing:** Per PRD section 4.2:
  - Playfair Display (Display/H1), Lora (H2), DM Sans (Body/Caption)
- **Risk:** Wrong fonts loaded, inconsistent text hierarchy

### 17. No Spacing/Layout System
- **What's missing:** Per PRD section 4.3 - base unit 4dp, spacing tokens, border radius tokens
- **Risk:** Inconsistent padding/margins

### 18. No Animation System
- **What's missing:** Per PRD section 4.5:
  - App open: 400ms fade + scale 0.98→1.0
  - Screen transition: slide up 16dp + fade 320ms
  - Breathing: continuous scale 1.0↔1.05 over 4000ms
  - Time theme crossfade: 900ms
- **Risk:** UI feels static, not calm

---

## Dependencies at Risk

### 19. Flutter SDK Version
- **File:** `pubspec.yaml:22`
- **Current:** `sdk: ^3.11.4`
- **Risk:** Recent version - may have breaking changes with packages
- **Fix:** Test thoroughly, pin to known stable version

### 20. No Dependency Audit
- **File:** `pubspec.lock` exists but not reviewed
- **Impact:** Potential version conflicts when adding Supabase, BLoC
- **Fix:** Audit dependencies when implementing data layer

---

## Testing Gaps

### 21. No Feature Tests
- **Files:** `test/widget_test.dart` - only default counter test
- **Issue:** Tests for 0 Tether features
- **Risk:** Cannot verify any Tether functionality works

### 22. No Unit Tests
- **Files:** None exist
- **Issue:** Business logic (use cases, entities, repositories) untested
- **Risk:** Logic errors undetected

### 23. No Integration Tests
- **Files:** None exist
- **Issue:** Supabase integration not testable
- **Risk:** Data layer errors undetected

---

## Pre-Build Requirements

### 24. Fix Syntax Errors Before Build
- **Required:** Fix lines 31 and 105 in `lib/main.dart`
- **Otherwise:** Build will fail

### 25. Platform Configuration Not Optimized
- **Files:** `android/app/build.gradle.kts`, `ios/Runner/Info.plist`
- **Missing:** Min SDK version, deployment targets, permissions
- **Risk:** May not meet app requirements

---

## Notes

- Project requires complete feature scope implementation
- Architecture decisions needed: Clean Architecture pattern, BLoC state management
- Platform configs require optimization for Tether requirements
- All security features (encryption, RLS, biometrics) must be implemented before production

---

*Concerns audit: 2026-04-12*