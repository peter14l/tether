# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Per-user encryption system with device-bound keys
- `UserKeyManager` service for secure key management
- `purchasePremiumAuto()` method for auto-detecting payment provider based on installer source
- Installer source detection via native Android method channel
- Tests for installer detection and billing auto-flow

### Changed
- **`EnvConfig`**: Removed app-wide encryption keys, now per-user only
- **All repositories**: Now use `UserKeyManager` instead of shared encryption keys
  - `SupabaseJournalRepository`
  - `SupabaseReflectionRepository`
  - `SupabaseVaultRepository`
  - `SupabaseLetterRepository`
  - `SupabaseGalleryRepository`
  - `SupabaseAuthRepository`
- Payment flow: Auto-selects Razorpay (APK) or RevenueCat (Play Store)
- Error handling: `catch (_) {}` replaced with `catch (e) { debugPrint(...) }`

### Fixed (Critical)
- Hardcoded Supabase credentials: Now throws exception if env vars missing
- Placeholder Razorpay key: Removed fallback, fails fast if not configured
- Silent error swallowing: Added proper error logging
- Placeholder images: Replaced via.placeholder.com with Unsplash/UI Avatars

### Removed
- Encryption keys from environment config
- Shared placeholder `_placeholderKey` from all repositories
- via.placeholder.com image URLs

## Security
- Encryption keys are now generated per-user on signup
- Keys stored in device's `FlutterSecureStorage` (encrypted, device-bound)
- Keys never leave the device
- Each user's data is encrypted with their unique key
- App fails fast if required env vars missing

## Payment Flow (Auto-Guarded)
```
Install source detected → 
  Play Store → RevenueCat
  APK/direct → Razorpay
```

## Installer Source Detection
- Native Android implementation via `MainActivity.kt`
- Method channel: `com.oasis/installer`
- Returns package name of installer (e.g., `com.android.vending` for Play Store)

## Placeholder Images Replaced
- Avatar placeholders → UI Avatars (initials-based)
- Heritage photos → Unsplash (family-themed)
- Breathing room → Unsplash (calm/nature)
- Couples bubble → Unsplash (romantic)

---

## [1.0.0] - 2026-04-14

### Initial MVP Release

#### Features
- Journal / Gratitude entries
- Reflection wall
- Vault (private memories)
- Future letters (time-delivered messages)
- Private gallery
- Family & couples circles
- Breathing room
- Monetization via Razorpay & RevenueCat