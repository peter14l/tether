# 🌅 Tether

> *"Stay close. Stay calm. Your people. Your pace."*

Tether is an **emotional-safety-first social connection app** for close relationships — friends, couples, and families. It is explicitly **not** a social media platform. No public feeds, no follower counts, no algorithmic ranking, and no ads.

Built with Flutter + Supabase, Tether is the antidote to digital anxiety. Every design decision is evaluated against one question: *does this make the user feel safer, calmer, and more connected?*

---

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Design System](#-design-system)
- [Getting Started](#-getting-started)
- [Environment Setup](#-environment-setup)
- [Database](#-database)
- [Security & Privacy](#-security--privacy)
- [Roadmap](#-roadmap)

---

## ✨ Features

Tether is organized around four core user segments: **close friend groups**, **couples**, **families**, and **digitally overwhelmed users**.

### 🌐 Core Platform
| Feature | Description |
|---|---|
| **Circles** | Private groups (friends / couple / family / in-law). The home unit of Tether. |
| **Circle Feed** | Chronological, no-algorithm feed visible only to circle members. |
| **Mood Rooms** | Set your current emotional state so your circle can respond with care, not pressure. |
| **Temperature Check** | A daily emoji poll across a circle. No comments, just awareness. |
| **Check-In System** | One-tap "I'm okay" visible to close circles. Gentle follow-up on missed check-ins. |
| **Digital Hug** | A haptic pulse — no words, just warmth. Returnable. |
| **Gentle Reactions** | Replace likes with: Warm · Comforting · I see you · Sending strength. | |
| **Comfort Radius** | Choose how widely content spreads: Inner (1–5) / Close (10) / All Friends. |
| **Soft Block** | Block silently — no notifications, no confrontation. |

### 💬 Messaging
| Feature | Description |
|---|---|
| **Direct Messaging** | Standard DMs between circle members. |
| **Slow Chat / Voice Notes** | Voice-note-only mode. More personal than text, less demanding than a call. |
| **Letter Mode** | Long-form letters delivered at a future time chosen by the sender. |
| **One-Way Post** | Posts that disappear after being seen. |
| **Anonymous Venting** | Share a feeling anonymously within a circle. |

### 🧘 Wellness
| Feature | Description |
|---|---|
| **Breathing Room** | Guided 4-7-8 breathing animation with optional ambient sound. |
| **Quiet Hours / Wind-Down** | Hard blocks on notifications during scheduled windows. |
| **Reflection Wall** | Private, encrypted unfiltered thoughts — never seen by anyone. |
| **Gratitude Journal** | Encrypted daily gratitude log, optionally shareable with a circle. |
| **Slow Photo** | Images fade in softly over 600 ms. No jarring pop-in. |
| **Shared Playlists / Ambient Sounds** | Lo-fi, rain, white noise — shared within circles. |

### 💕 Couples Features
| Feature | Description |
|---|---|
| **Our Bubble** | Fully private, encrypted shared space for couples only. |
| **Heartbeat** | "I'm thinking of you" pulse on your partner's lock screen. |
| **Our Song** | Designate a shared song that plays softly in your chat. |
| **Promise Rings** | Digital commitment markers with timestamps. |
| **Favor Coupons** | Redeemable "I owe you" coupons. |
| **Future Letters** | Encrypted letters delivered on a future date. |
| **Together Mode** | Special UI when both partners open the app simultaneously. |

### 👨‍👩‍👧‍👦 Family Features
| Feature | Description |
|---|---|
| **Family Dashboard** | Central family hub with safety and activity overview. |
| **Safety Check** | "Are you safe?" pings with escalation if unanswered within a timeout. |
| **Emergency SOS** | One-tap location broadcast to all family members. |
| **Heritage Corner** | Upload old photos and stories to build a living family archive. |
| **Bedtime Stories** | Parents/grandparents record voice stories playable by children anytime. |
| **Kid Mode** | Restricted view for under-13, parent-controlled. |
| **Generational Memories** | Elder-uploaded content with Q&A from younger members. |

### ⚙️ Settings & Accessibility
- **Time-Adaptive Dark Mode** with manual override
- **Quiet Hours** scheduling
- **Whisper Mode** (softer font for evenings)
- **Accessibility Mode** (larger text, high contrast)
- **Grandparent Easy View** (simplified UI)
- **No-Algorithm Promise** toggle (always chronological)

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Dart) — iOS & Android |
| **Backend** | Supabase (PostgreSQL + Auth + Storage + Realtime + Edge Functions) |
| **State Management** | `flutter_bloc` (BLoC / Cubit pattern) |
| **Dependency Injection** | `get_it` + `injectable` |
| **Navigation** | `go_router` |
| **Client-Side Encryption** | `cryptography` (AES-256-GCM) |
| **Secure Storage** | `flutter_secure_storage` |
| **Audio** | `record` (voice notes) + `audioplayers` (playback) |
| **Functional Programming** | `fpdart` (Either / Option for error handling) |
| **Fonts** | `google_fonts` (Playfair Display, DM Sans) |
| **Testing** | `flutter_test`, `bloc_test`, `mocktail` |

---

## 🏛 Architecture

Tether follows **Clean Architecture** strictly across three layers. The goal is zero coupling between UI and business logic, and zero coupling between business logic and data sources.

```
┌─────────────────────────────────────────────┐
│              PRESENTATION LAYER              │
│  (Flutter Widgets, BLoC/Cubit, Screens)     │
│  • Screens, Components, Animations          │
│  • Time-theme engine (TimeThemeCubit)       │
│  • No direct Supabase calls                 │
└──────────────────┬──────────────────────────┘
                   │ calls Use Cases
┌──────────────────▼──────────────────────────┐
│               DOMAIN LAYER                  │
│  (Pure Dart — no Flutter, no Supabase)      │
│  • Entities (User, Circle, Post, …)         │
│  • Use Cases (SignIn, CreateCircle, …)      │
│  • Repository Interfaces (abstract)         │
│  • Failures (typed, fpdart Either)          │
└──────────────────┬──────────────────────────┘
                   │ implements
┌──────────────────▼──────────────────────────┐
│                DATA LAYER                   │
│  (Supabase, Local Storage, Secure Storage)  │
│  • Repository Implementations               │
│  • Supabase Data Sources                    │
│  • DTO models + mappers                     │
│  • Client-side encryption service           │
└─────────────────────────────────────────────┘
```

### State Management

- **BLoC / Cubit** for all feature state (`AuthBloc`, `TimeThemeCubit`, etc.)
- **Events → States** pattern; zero business logic in widgets
- **Supabase Realtime** streams are fed into BLoCs via `StreamSubscription` in repository implementations
- **`ValueNotifier` / `StatefulWidget`** for purely local UI state (animation controllers)

### Error Handling

All repository methods return `Either<Failure, T>` from `fpdart`, eliminating unchecked exceptions and making error paths explicit throughout the domain and presentation layers.

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── config/             # EnvConfig (Supabase URL + anon key)
│   ├── error/              # Typed Failure classes
│   ├── network/            # NetworkInfo
│   ├── router/             # GoRouter config with auth-guard redirect
│   ├── theme/
│   │   ├── theme_tokens.dart       # Color/shadow tokens per TimeSlot
│   │   ├── time_theme_cubit.dart   # Polls system time every minute
│   │   ├── time_theme_state.dart   # Current slot + dark-mode override
│   │   └── app_theme.dart          # MaterialTheme builder
│   ├── usecase/            # Base UseCase<Type, Params> interface
│   ├── utils/
│   │   ├── encryption_service.dart # AES-256-GCM encrypt / decrypt
│   │   ├── escrow_service.dart     # Key escrow helpers
│   │   └── key_derivation.dart     # Master key derivation
│   └── widgets/            # Shared widgets (MainShell, nav bar, …)
│
├── features/
│   ├── auth/               # Sign-in, Sign-up, session management
│   ├── circles/            # Circle CRUD, membership, comfort radius
│   ├── feed/               # Chronological circle feed, posts, reactions
│   ├── messaging/          # DMs, voice notes, letter mode, chat screen
│   ├── mood/               # Mood Rooms, temperature checks
│   ├── journal/            # Gratitude Journal, Reflection Wall
│   ├── wellness/           # Breathing Room, quiet hours
│   ├── couples/            # Our Bubble, heartbeat, favor coupons
│   ├── family/             # Family dashboard, safety check, heritage corner
│   ├── memories/           # Memories Lane, Once Upon a Time
│   ├── vault/              # Safe Space Lock
│   ├── calendar/           # Shared Calendar
│   └── settings/           # App settings, quiet hours, theme override
│
├── injection_container.dart        # GetIt + injectable configuration
├── injection_container.config.dart # Auto-generated DI bindings
└── main.dart                       # App entry point
```

### Routing

Navigation is handled by `go_router` with an auth-guard redirect:

| Path | Screen | Guard |
|---|---|---|
| `/` | `CirclesScreen` | Auth required |
| `/feed/:circleId` | `FeedScreen` | Auth required |
| `/messaging` | `MessagingScreen` | Auth required |
| `/messaging/chat/:circleId/:userId` | `ChatScreen` | Auth required |
| `/mood` | `MoodSelectionScreen` | Auth required |
| `/journal` | `JournalScreen` | Auth required |
| `/reflection` | `ReflectionWallScreen` | Auth required |
| `/breathing` | `BreathingRoomScreen` | Auth required |
| `/bubble/:circleId` | `OurBubbleScreen` | Auth required |
| `/family/:circleId` | `FamilyDashboardScreen` | Auth required |
| `/family/:circleId/heritage` | `HeritageCornerScreen` | Auth required |
| `/family/:circleId/stories` | `BedtimeStoriesScreen` | Auth required |
| `/settings` | `SettingsScreen` | Auth required |
| `/circles/create` | `CreateCircleScreen` | Auth required |
| `/login` | `LoginScreen` | Unauthenticated only |
| `/signup` | `SignUpScreen` | Unauthenticated only |

---

## 🎨 Design System

### Time-Adaptive Themes

The UI automatically shifts its color palette based on the device's local time. The `TimeThemeCubit` polls the system clock every minute and emits a new `TimeSlot` when a boundary is crossed. `AppTheme.getTheme()` constructs a full `ThemeData` from `ThemeTokens` for the current slot.

| Time Slot | Hours | Character | Accent Colour |
|---|---|---|---|
| 🌅 **Morning** | 05:00 – 11:59 | Fresh, clear, soft | Terracotta `#FB7837` |
| ☀️ **Afternoon** | 12:00 – 17:29 | Bright, warm, alive | Golden Amber `#FEB246` |
| 🌇 **Dusk** *(signature)* | 17:30 – 20:59 | Glowing golden-hour | Sunset Orange `#FF7B3A` |
| 🌙 **Night** | 21:00 – 04:59 | Deep, still, quiet | Periwinkle `#6B7FD4` |

Users can also manually toggle dark mode via Settings, which overrides the time-based selection without disabling it permanently.

### Typography

| Role | Font | Weight | Size |
|---|---|---|---|
| Display / Hero | Playfair Display | 700 | 32–48 sp |
| Heading 1 | Playfair Display | 600 | 24 sp |
| Heading 2 | Lora | 600 | 20 sp |
| Body | DM Sans | 400 | 15 sp |
| Caption | DM Sans | 400 | 12 sp |

### Motion Philosophy

Animations should feel like breathing — slow, intentional, never jarring. Key timings:

| Event | Duration | Easing |
|---|---|---|
| Screen transition | 320 ms | easeOutQuart |
| Card appear | 280 ms | easeOutCubic |
| Button press (scale) | 120 ms | easeInOut |
| Modal open | 350 ms | spring (damping 0.8) |
| Time-theme crossfade | 900 ms | easeInOut |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.11.4` (check with `flutter --version`)
- Dart SDK `^3.11.4`
- A Supabase project (free tier works for development)

### Installation

```bash
# 1. Clone the repo
git clone https://github.com/peter14l/tether.git
cd tether

# 2. Install dependencies
flutter pub get

# 3. Run code generation (DI bindings)
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

---

## 🔐 Environment Setup

Create `lib/core/config/env_config.dart` (gitignored) with your Supabase credentials:

```dart
class EnvConfig {
  static const supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
  static const supabasePublishableKey = 'YOUR_ANON_KEY';
}
```

> ⚠️ **Never commit real credentials.** Use environment variables or a secrets manager in CI/CD.

---

## 🗄 Database

Migrations live in `supabase/migrations/` and are applied via the Supabase CLI.

```bash
# Apply all pending migrations
supabase db push
```

| Migration | Description |
|---|---|
| `0001_initial_schema.sql` | Core tables: profiles, circles, circle_members, posts, reactions, mood_rooms, digital_hugs, voice_notes, gratitude_journal, reflection_wall, shared_playlists, shared_calendar, check_ins, temperature_checks, quiet_hours, soft_blocks, kindness_streaks, heritage_corner, sos_alerts, family_safety_checks |
| `0002_couples.sql` | Couple-specific tables: couple_bubble, heartbeats, favor_coupons, future_letters |
| `0003_add_missing_rls_policies.sql` | Row-Level Security policies for all tables |
| `0004_fix_rls_recursion.sql` | Fixes RLS infinite-recursion on circle_members joins |
| `0005_profile_trigger.sql` | Auto-creates a profile row on Supabase Auth sign-up |
| `0006_backfill_profiles.sql` | Backfills profiles for existing auth users |

### Row-Level Security

All tables enforce RLS. Users can only read/write data they are authorised for (own profile, circles they belong to, etc.). Circle membership is the primary access gatekeeper.

---

## 🔒 Security & Privacy

### Client-Side Encryption

Sensitive content is **encrypted on-device before upload** using AES-256-GCM (`EncryptionService`). Supabase never stores or sees the plaintext for:

- **Reflection Wall** entries
- **Gratitude Journal** entries (when private)
- **Future Letters**
- **Our Bubble** content

The master key is derived from the user's credentials and stored in `flutter_secure_storage`, never in plaintext on disk.

### Auth Guard

`GoRouter` performs an auth-state redirect on every navigation event, driven by `AuthBloc` state changes. Authenticated users are redirected away from `/login` and `/signup` automatically, and unauthenticated users are blocked from all shell routes.

### Quiet Mode & Soft Block

- **Quiet Mode**: Users can set themselves as `is_quiet` on their profile. Other circle members see them as "Quiet" rather than "Online" — no last-seen anxiety.
- **Soft Block**: Blocking is silent. The blocked user simply stops seeing content, with no notification.

---

## 🗺 Roadmap

The full product roadmap is documented in [`TETHER_PRD.md`](./TETHER_PRD.md). Extended feature ideas are tracked in [`FEATURE_IDEAS.md`](./FEATURE_IDEAS.md).

### v1.0 MVP (In Progress)
- [x] Authentication (sign-in, sign-up, session persistence)
- [x] Time-adaptive theme engine
- [x] Core routing with auth guard
- [x] Client-side encryption service
- [x] Database schema + RLS policies
- [ ] Circles (create, join, manage members)
- [ ] Circle Feed (posts, gentle reactions)
- [ ] Mood Rooms
- [ ] Direct Messaging + Voice Notes
- [ ] Gratitude Journal + Reflection Wall
- [ ] Breathing Room
- [ ] Settings (quiet hours, theme override)

### v1.1
- [ ] Couples: Our Bubble, Heartbeat, Our Song, Future Letters
- [ ] Temperature Check
- [ ] Digital Hug
- [ ] Check-In System

### v1.2
- [ ] Family Dashboard, Safety Check, Heritage Corner, Bedtime Stories
- [ ] Emergency SOS
- [ ] Shared Calendar

### v2.0+
- [ ] Kid Mode / Grandparent Easy View
- [ ] Whisper Mode, Breathing on Open
- [ ] Kindness Streaks (private, gentle milestones)
- [ ] Once Upon a Time (memories)
- [ ] Long-distance Couples mode

---

## 📄 License

Private — all rights reserved. Not open for public contribution at this time.

---

*Built with care. Designed for the people who matter most.*
