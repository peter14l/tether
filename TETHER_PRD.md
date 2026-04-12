# TETHER — Master Product Requirements Document
**Version:** 1.0 · **Status:** Living Document · **Classification:** Internal

> *"Stay close. Stay calm. Your people. Your pace."*

---

## Table of Contents

1. [Product Overview](#1-product-overview)
2. [Vision & Philosophy](#2-vision--philosophy)
3. [Target Audience](#3-target-audience)
4. [Design System](#4-design-system)
   - 4.1 Time-Adaptive Color Palettes
   - 4.2 Typography
   - 4.3 Spacing & Layout
   - 4.4 Component Styling
   - 4.5 Motion & Animation
5. [Architecture Overview](#5-architecture-overview)
   - 5.1 Clean Architecture Layers
   - 5.2 Folder Structure
   - 5.3 State Management
6. [Backend — Supabase](#6-backend--supabase)
   - 6.1 Auth
   - 6.2 Database Schema
   - 6.3 Storage
   - 6.4 Realtime
   - 6.5 Edge Functions
   - 6.6 Row-Level Security
7. [Feature Specifications](#7-feature-specifications)
   - 7.1 Core Platform Features
   - 7.2 General Wellness Features (1–25)
   - 7.3 Couples Features (26–35, 46–55)
   - 7.4 Family Features (36–45, 56–65)
   - 7.5 Extended Features (66–75)
8. [User Flows](#8-user-flows)
9. [Notification Strategy](#9-notification-strategy)
10. [Privacy & Security](#10-privacy--security)
11. [Monetization](#11-monetization)
12. [Tech Stack](#12-tech-stack)
13. [Versioned Roadmap](#13-versioned-roadmap)
14. [Open Questions](#14-open-questions)

---

## 1. Product Overview

**Tether** is an emotional-safety-first social connection app for close relationships — friends, couples, and families. It is explicitly NOT a social media platform. It has no public feeds, no follower counts, no algorithmic ranking, and no ads.

Tether is the antidote to digital anxiety. Every design decision, feature, and interaction is evaluated against one question: *does this make the user feel safer, calmer, and more connected?*

| Attribute | Value |
|---|---|
| App Name | Tether |
| Platforms | iOS & Android (Flutter) |
| Backend | Supabase (PostgreSQL + Auth + Storage + Realtime + Edge Functions) |
| Target Launch | v1.0 MVP |
| Primary Language | Dart (Flutter) |
| Architecture | Clean Architecture (Domain / Data / Presentation) |

---

## 2. Vision & Philosophy

### Core Vision
> *"A safe space away from the busy noise of the world. Users should feel safe, emotionally secure, and comfortable. Something they can ease and relax in and connect with friends."*

### Design Principles

**1. Calm by Default**
Every screen, animation, and notification is designed to reduce anxiety, never amplify it. No red badges. No urgent banners. No "X people viewed your post."

**2. Intimacy Over Scale**
Tether is not built for mass audiences. It's built for 5 people who truly matter. Feature decisions favor depth over breadth.

**3. No Pressure Architecture**
Read receipts are opt-in. Online status has a "Quiet" mode. No one knows if you've seen their post. Engagement is always voluntary.

**4. Time-Aware Comfort**
The app changes with the time of day — colors shift from fresh morning tones to warm afternoon hues to glowing dusk gradients to deep night blues. The phone feels like it's breathing with you.

**5. Anti-Gamification**
No streaks that break. No counts that shame. No leaderboards. No "you haven't posted in 7 days!" guilt. If we acknowledge usage at all, it's private, gentle, and framed as personal growth.

**6. People-First Privacy**
All sensitive data (Reflection Wall, Gratitude Journal, Vault, Private Galleries) is encrypted client-side before being stored. Supabase never sees the plaintext.

---

## 3. Target Audience

### Primary Segments

| Segment | Description | Core Need |
|---|---|---|
| **Close Friend Groups** | Ages 16–30, tight-knit friend circles of 3–10 people | Low-pressure hangout space, no performance |
| **Couples** | Any age, new or long-term relationships | Intimacy tools, private shared spaces, emotional awareness |
| **Family Units** | Parents, children, grandparents | Safety, togetherness, generational bridging |
| **Anxious/Burnt-out Users** | Any age, digitally overwhelmed | A slower, quieter alternative to mainstream apps |

### Anti-Audience
Tether is explicitly NOT for:
- Public content creators
- Brands or businesses
- People seeking large social networks
- Anyone looking for a TikTok or Instagram alternative

---

## 4. Design System

### 4.1 Time-Adaptive Color Palettes

The entire app UI shifts its color theme dynamically based on the device's local time. This is not a user toggle — it happens automatically, as naturally as the sky changing. Transitions between time slots are gradual (15-minute crossfade).

---

#### 🌅 Morning — 5:00 AM to 11:59 AM
*Fresh, clear, soft energy. The world waking up gently.*

```
Background Primary:     #F5F0E8   (warm linen white)
Background Secondary:   #EDE5D8   (parchment)
Background Elevated:    #FFFFFF   (clean white cards)
Surface Overlay:        rgba(255, 248, 235, 0.85)

Accent Primary:         #E8956D   (soft terracotta / morning sun)
Accent Secondary:       #A8C5A0   (sage green — nature, calm)
Accent Tertiary:        #D4A574   (warm sand)

Text Primary:           #2C2416   (deep warm brown)
Text Secondary:         #6B5B47   (muted earth)
Text Muted:             #A89880   (lighter earth)

Border Default:         rgba(168, 140, 110, 0.2)
Border Glow Color:      rgba(232, 149, 109, 0.35)   ← morning terracotta glow
Button Glow Shadow:     0 0 12px rgba(232, 149, 109, 0.4), 0 0 28px rgba(232, 149, 109, 0.15)

Divider:                rgba(168, 140, 110, 0.12)
```

---

#### ☀️ Afternoon — 12:00 PM to 5:29 PM
*Bright, warm, alive. Peak energy, but still gentle.*

```
Background Primary:     #F8F3EC   (light cream)
Background Secondary:   #F0E8DC   (warm beige)
Background Elevated:    #FFFFFF
Surface Overlay:        rgba(255, 250, 240, 0.88)

Accent Primary:         #C4813A   (golden amber)
Accent Secondary:       #88B4A8   (muted teal)
Accent Tertiary:        #D4956A   (warm peach)

Text Primary:           #1E1810   (near-black warm)
Text Secondary:         #5C4A35   (warm brown)
Text Muted:             #9A8570   (lighter warm)

Border Default:         rgba(150, 120, 80, 0.18)
Border Glow Color:      rgba(196, 129, 58, 0.40)    ← amber afternoon glow
Button Glow Shadow:     0 0 14px rgba(196, 129, 58, 0.45), 0 0 32px rgba(196, 129, 58, 0.18)

Divider:                rgba(150, 120, 80, 0.10)
```

---

#### 🌇 Evening / Dusk — 5:30 PM to 8:59 PM *(Hero Theme)*
*Warm, glowing, golden-hour magic. The signature Tether experience.*

```
Background Primary:     #1A1018   (deep plum-black)
Background Secondary:   #231520   (rich dark violet)
Background Elevated:    #2D1E28   (lifted card surface)
Surface Overlay:        rgba(35, 18, 28, 0.92)

Accent Primary:         #FF7B3A   (vivid sunset orange)
Accent Secondary:       #C45BAA   (warm rose-violet)
Accent Tertiary:        #FFB347   (golden amber)
Accent Quaternary:      #FF4F7B   (dusk pink)

Text Primary:           #FFF0E6   (warm off-white)
Text Secondary:         #D4A89A   (peachy muted)
Text Muted:             #8A6878   (dim rose)

Border Default:         rgba(255, 123, 58, 0.18)
Border Glow Color:      rgba(255, 123, 58, 0.55)    ← primary sunset glow
Border Glow Alt:        rgba(196, 91, 170, 0.45)    ← rose violet glow
Button Glow Shadow:     0 0 16px rgba(255, 123, 58, 0.6), 0 0 40px rgba(255, 123, 58, 0.25), 0 0 80px rgba(196, 91, 170, 0.15)
Card Glow:              0 0 24px rgba(255, 123, 58, 0.12), inset 0 1px 0 rgba(255, 200, 150, 0.1)

Gradient Hero:          linear-gradient(135deg, #FF7B3A 0%, #C45BAA 50%, #7B3FA0 100%)
Gradient Subtle:        linear-gradient(180deg, #2D1E28 0%, #1A1018 100%)
Divider:                rgba(255, 123, 58, 0.10)
```

**Dusk Button Glow Implementation:**
All primary action buttons during dusk hours carry a multi-layered glow:
```
box-shadow:
  0 0 0 1px rgba(255, 123, 58, 0.6),       // tight border ring
  0 0 12px rgba(255, 123, 58, 0.5),         // inner bloom
  0 0 32px rgba(255, 123, 58, 0.25),        // mid bloom
  0 0 60px rgba(196, 91, 170, 0.15);        // outer violet halo
```

On hover/press, the glow intensifies — opacity increases by ~30% with a 200ms ease.

---

#### 🌙 Night — 9:00 PM to 4:59 AM
*Deep, still, quiet. The world is asleep. Tether whispers.*

```
Background Primary:     #0E0C14   (near-black deep navy)
Background Secondary:   #141220   (rich dark blue)
Background Elevated:    #1C1A2A   (elevated dark card)
Surface Overlay:        rgba(14, 12, 20, 0.95)

Accent Primary:         #6B7FD4   (soft periwinkle blue)
Accent Secondary:       #4A5FA8   (deeper blue)
Accent Tertiary:        #8A6BC4   (soft lavender)

Text Primary:           #E8E6F0   (cool off-white)
Text Secondary:         #9898C0   (muted blue-grey)
Text Muted:             #5A5878   (dim slate)

Border Default:         rgba(107, 127, 212, 0.15)
Border Glow Color:      rgba(107, 127, 212, 0.35)   ← moonlight periwinkle glow
Button Glow Shadow:     0 0 12px rgba(107, 127, 212, 0.45), 0 0 30px rgba(107, 127, 212, 0.18)

Gradient Hero:          linear-gradient(135deg, #4A5FA8 0%, #6B7FD4 50%, #8A6BC4 100%)
Divider:                rgba(107, 127, 212, 0.08)
```

---

#### Transition Behavior

```dart
// Pseudo-code for time-theme engine
ThemeToken getCurrentTheme(DateTime now) {
  final hour = now.hour + (now.minute / 60.0);
  if (hour >= 5.0 && hour < 12.0) return ThemeToken.morning;
  if (hour >= 12.0 && hour < 17.5) return ThemeToken.afternoon;
  if (hour >= 17.5 && hour < 21.0) return ThemeToken.dusk;
  return ThemeToken.night;
}

// Crossfade between themes over 15 real minutes
// Use AnimatedTheme widget in Flutter with TweenAnimationBuilder
// Interpolate all color tokens simultaneously
```

---

### 4.2 Typography

| Role | Font | Weight | Size |
|---|---|---|---|
| Display / Hero | **Playfair Display** | 700 | 32–48sp |
| Heading 1 | **Playfair Display** | 600 | 24sp |
| Heading 2 | **Lora** | 600 | 20sp |
| Body | **DM Sans** | 400 | 15sp |
| Body Emphasis | **DM Sans** | 500 | 15sp |
| Caption | **DM Sans** | 400 | 12sp |
| Label / Chip | **DM Sans** | 500 | 11sp |
| Whisper Mode (Feature 73) | **DM Sans** | 300 | 12sp, letter-spacing: 0.05em |

**Rationale:** Playfair Display brings warmth and humanity (serifs feel personal, not corporate). DM Sans is clean, highly readable, and neutral enough not to compete. Together they feel like a personal journal written by a thoughtful designer.

---

### 4.3 Spacing & Layout

```
Base Unit:       4dp
Micro:           4dp  (tight grouping)
XSmall:          8dp
Small:           12dp
Medium:          16dp  (default padding)
Large:           24dp
XLarge:          32dp
2XLarge:         48dp
Section:         64dp

Border Radius:
  Button:        14dp
  Card:          18dp
  Modal:         24dp
  Avatar:        9999dp (circle)
  Chip:          999dp  (pill)
  Input:         12dp
```

---

### 4.4 Component Styling

#### Buttons

**Primary Button** (time-adaptive glow):
- Background: `accentPrimary`
- Text: `textOnAccent` (always light for dark themes, dark for light themes)
- Border: `1px solid borderGlowColor`
- Shadow: `buttonGlowShadow` (time-specific, as defined above)
- Border Radius: `14dp`
- Padding: `16dp vertical, 28dp horizontal`
- Transition: `200ms ease` on press — scale to 0.97, glow intensifies

**Ghost Button:**
- Background: `transparent`
- Border: `1px solid borderDefault`
- Text: `accentPrimary`
- On hover: border transitions to `borderGlowColor` with glow shadow at 50% intensity

**Soft Button:**
- Background: `accentPrimary` at 12% opacity
- Border: none
- Text: `accentPrimary`
- Used for secondary, non-destructive actions

#### Cards

```
Background:      backgroundElevated
Border:          1px solid borderDefault
Border Radius:   18dp
Shadow:          cardGlow (dusk) or subtle drop shadow (other times)
Padding:         20dp
```

During dusk, cards have a faint inner glow on the top edge:
```
box-shadow: 0 0 0 1px rgba(255,123,58,0.08), inset 0 1px 0 rgba(255,200,150,0.07)
```

#### Inputs

```
Background:      backgroundSecondary
Border:          1px solid borderDefault
Focus Border:    borderGlowColor (with reduced glow shadow)
Border Radius:   12dp
Padding:         14dp 16dp
```

---

### 4.5 Motion & Animation

**Philosophy:** Animations should feel like breathing — slow, intentional, never jarring.

| Event | Animation | Duration | Easing |
|---|---|---|---|
| App open | Soft fade in + subtle scale from 0.98→1.0 | 400ms | easeOutCubic |
| Screen transition | Slide up 16dp + fade | 320ms | easeOutQuart |
| Card appear | Fade + translate Y 8dp | 280ms | easeOutCubic |
| Button press | Scale 0.97 + glow intensify | 120ms | easeInOut |
| Modal open | Scale 0.94→1.0 + fade | 350ms | spring (damping 0.8) |
| Breathing animation | Scale 1.0↔1.05 (continuous) | 4000ms per cycle | sinusoidal |
| Time theme crossfade | All color tokens interpolate simultaneously | 900ms | easeInOut |
| Digital Hug pulse | Radial pulse expand + fade | 800ms | easeOut |

**Slow Photo fade-in (Feature 25):** Images load with a 600ms ease-in opacity transition from 0→1. No jarring pop-in.

**App Open Breathing (Feature 9):** On launch, before showing the home screen, a 3-second calm animation plays — a soft radial pulse in the current time theme's accent color, synced to a suggested breath. Users can disable this in Settings.

---

## 5. Architecture Overview

Tether follows **Clean Architecture** strictly. The goal is zero coupling between UI and business logic, and zero coupling between business logic and data sources.

### 5.1 Clean Architecture Layers

```
┌─────────────────────────────────────────────┐
│              PRESENTATION LAYER              │
│  (Flutter Widgets, BLoC/Cubit, ViewModels)  │
│  • Screens, Components, Animations          │
│  • Time-theme engine                        │
│  • No direct Supabase calls                 │
└──────────────────┬──────────────────────────┘
                   │ calls
┌──────────────────▼──────────────────────────┐
│               DOMAIN LAYER                  │
│  (Pure Dart — no Flutter, no Supabase)      │
│  • Entities (User, Circle, Post, etc.)      │
│  • Use Cases (SendDigitalHug, CheckIn, etc) │
│  • Repository Interfaces (abstract)         │
│  • Failures (typed error classes)           │
└──────────────────┬──────────────────────────┘
                   │ implements
┌──────────────────▼──────────────────────────┐
│                DATA LAYER                   │
│  (Supabase, Local DB, Secure Storage)       │
│  • Repository Implementations               │
│  • Supabase Data Sources                    │
│  • Local Cache (Drift / Hive)               │
│  • DTO models + mappers                     │
│  • Client-side encryption service           │
└─────────────────────────────────────────────┘
```

**Key Principle:** Use Cases in the Domain layer know nothing about Supabase. If we ever swap Supabase for Firebase, only the Data layer changes.

---

### 5.2 Folder Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── time_theme_engine.dart       # Time detection + token resolution
│   │   ├── theme_tokens.dart            # All color/typography tokens per slot
│   │   └── app_theme.dart              # ThemeData builder
│   ├── error/
│   │   └── failures.dart               # Typed failures
│   ├── usecase/
│   │   └── usecase.dart                # Base UseCase interface
│   ├── network/
│   │   └── network_info.dart
│   └── utils/
│       ├── encryption_service.dart      # Client-side AES-256 encryption
│       └── time_utils.dart
│
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── entities/user_entity.dart
│   │   │   ├── repositories/auth_repository.dart
│   │   │   └── usecases/
│   │   ├── data/
│   │   │   ├── datasources/supabase_auth_datasource.dart
│   │   │   ├── models/user_model.dart
│   │   │   └── repositories/auth_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/auth_bloc.dart
│   │       └── screens/
│   │
│   ├── circles/               # Friend/family/couple groups
│   ├── mood/                  # Mood Rooms, Temperature Check
│   ├── journal/               # Gratitude Journal, Reflection Wall
│   ├── messaging/             # DMs, Voice Notes, Letter Mode
│   ├── feed/                  # Circle Feed
│   ├── memories/              # Memories Lane, Once Upon a Time
│   ├── wellness/              # Breathing Room, Quiet Hours
│   ├── couples/               # Our Bubble, Heartbeat, etc.
│   ├── family/                # Family Circle, Safety Check, etc.
│   ├── vault/                 # Safe Space Lock
│   ├── calendar/              # Shared Calendar
│   └── settings/
│
├── injection_container.dart    # GetIt DI setup
└── main.dart
```

---

### 5.3 State Management

**Primary:** Flutter BLoC (flutter_bloc package)
- Every feature has its own Bloc/Cubit
- Events → States pattern
- No business logic in widgets

**Secondary (local/UI state):** `ValueNotifier` or simple `StatefulWidget` where appropriate (e.g., animation controllers)

**Dependency Injection:** `get_it` + `injectable`

**Reactive Data:** Supabase Realtime streams fed into BLoC via StreamSubscription in repository implementations

---

## 6. Backend — Supabase

### 6.1 Auth

- **Provider:** Supabase Auth (email/password + magic link + optional Google OAuth)
- **Session persistence:** Secure storage (flutter_secure_storage)
- **Phone number:** Optional, stored for Emergency SOS only
- **Profile setup:** Username, display name, avatar (uploaded to Supabase Storage), optional pronouns

---

### 6.2 Database Schema

All tables use UUID primary keys and `created_at` / `updated_at` timestamps unless noted.

---

#### `profiles`
```sql
id              uuid references auth.users primary key
username        text unique not null
display_name    text not null
avatar_url      text
bio             text
pronouns        text
mood_status     text                         -- current mood room state
is_quiet        boolean default false        -- "Quiet" presence mode
quiet_until     timestamptz
timezone        text
created_at      timestamptz default now()
updated_at      timestamptz default now()
```

---

#### `circles`
```sql
id              uuid primary key default gen_random_uuid()
name            text not null
circle_type     text not null               -- 'friends' | 'couple' | 'family' | 'inlaw'
created_by      uuid references profiles(id)
avatar_url      text
description     text
comfort_radius  text default 'inner'        -- 'inner' | 'close' | 'all'
is_encrypted    boolean default true
created_at      timestamptz default now()
updated_at      timestamptz default now()
```

---

#### `circle_members`
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id) on delete cascade
user_id         uuid references profiles(id)
role            text default 'member'       -- 'admin' | 'member'
joined_at       timestamptz default now()
```

---

#### `posts`
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id) on delete cascade
author_id       uuid references profiles(id)
content_type    text not null               -- 'text' | 'image' | 'voice' | 'letter' | 'one_way'
content_text    text
media_url       text
is_anonymous    boolean default false       -- Feature 66
deliver_at      timestamptz                 -- Letter Mode scheduled delivery
expires_after   interval                   -- One-Way Post (Feature 67)
is_soft_deleted boolean default false
soft_deleted_at timestamptz
created_at      timestamptz default now()
```

---

#### `reactions`
```sql
id              uuid primary key default gen_random_uuid()
post_id         uuid references posts(id) on delete cascade
user_id         uuid references profiles(id)
reaction_type   text not null               -- 'warm' | 'comforting' | 'i_see_you' | 'sending_strength'
created_at      timestamptz default now()
unique(post_id, user_id)
```

---

#### `mood_rooms`
```sql
id              uuid primary key default gen_random_uuid()
user_id         uuid references profiles(id) unique
status          text                        -- 'need_quiet' | 'anxious' | 'want_to_chat' | 'happy' | etc.
label           text                        -- custom label
color_key       text                        -- maps to UI color
updated_at      timestamptz default now()
```

---

#### `check_ins`
```sql
id              uuid primary key default gen_random_uuid()
user_id         uuid references profiles(id)
checked_in_at   timestamptz default now()
circle_id       uuid references circles(id)
```

---

#### `temperature_checks`
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id)
date            date default current_date
responses       jsonb                       -- { user_id: emoji_key }
created_at      timestamptz default now()
```

---

#### `digital_hugs`
```sql
id              uuid primary key default gen_random_uuid()
sender_id       uuid references profiles(id)
receiver_id     uuid references profiles(id)
circle_id       uuid references circles(id)
sent_at         timestamptz default now()
returned_at     timestamptz
```

---

#### `voice_notes`
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id)
sender_id       uuid references profiles(id)
storage_path    text not null               -- Supabase Storage path
duration_secs   integer
is_slow_chat    boolean default false
created_at      timestamptz default now()
```

---

#### `gratitude_journal` *(encrypted)*
```sql
id              uuid primary key default gen_random_uuid()
user_id         uuid references profiles(id)
encrypted_blob  text not null               -- AES-256 encrypted client-side
shared_with_circle_id uuid references circles(id)  -- null = private
date            date default current_date
created_at      timestamptz default now()
```

---

#### `reflection_wall` *(encrypted, always private)*
```sql
id              uuid primary key default gen_random_uuid()
user_id         uuid references profiles(id)
encrypted_blob  text not null               -- never readable server-side
created_at      timestamptz default now()
```

---

#### `shared_playlists`
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id)
created_by      uuid references profiles(id)
title           text
type            text                        -- 'ambient' | 'music' | 'lofi'
tracks          jsonb                       -- array of track objects
created_at      timestamptz default now()
```

---

#### `shared_calendar`
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id)
created_by      uuid references profiles(id)
title           text not null
description     text
event_date      date not null
is_recurring    boolean default false
recurrence_rule text                        -- iCal RRULE format
created_at      timestamptz default now()
```

---

#### `couple_bubble` *(extends circles for couple type)*
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id) unique
our_song_url    text
our_song_title  text
anniversary_date date
promise_ring_set_at timestamptz
promise_ring_text text
created_at      timestamptz default now()
```

---

#### `heartbeats`
```sql
id              uuid primary key default gen_random_uuid()
sender_id       uuid references profiles(id)
receiver_id     uuid references profiles(id)
sent_at         timestamptz default now()
```

---

#### `favor_coupons`
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id)
created_by      uuid references profiles(id)
assigned_to     uuid references profiles(id)
description     text not null
redeemed        boolean default false
redeemed_at     timestamptz
created_at      timestamptz default now()
```

---

#### `future_letters`
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id)
sender_id       uuid references profiles(id)
receiver_id     uuid references profiles(id)
encrypted_blob  text not null
deliver_at      timestamptz not null
delivered       boolean default false
created_at      timestamptz default now()
```

---

#### `family_safety_checks`
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id)
triggered_by    uuid references profiles(id)
responded_at    timestamptz
timeout_minutes integer default 30
status          text default 'pending'      -- 'pending' | 'safe' | 'escalated'
created_at      timestamptz default now()
```

---

#### `sos_alerts`
```sql
id              uuid primary key default gen_random_uuid()
user_id         uuid references profiles(id)
circle_id       uuid references circles(id)
location_lat    double precision
location_lng    double precision
location_accuracy double precision
sent_at         timestamptz default now()
resolved_at     timestamptz
```

---

#### `quiet_hours`
```sql
id              uuid primary key default gen_random_uuid()
user_id         uuid references profiles(id) unique
enabled         boolean default false
start_time      time not null               -- e.g. 21:00
end_time        time not null               -- e.g. 07:00
wind_down_start time                        -- fade-out begins here
days_active     text[]                      -- ['mon','tue','wed','thu','fri','sat','sun']
created_at      timestamptz default now()
```

---

#### `soft_blocks`
```sql
id              uuid primary key default gen_random_uuid()
blocker_id      uuid references profiles(id)
blocked_id      uuid references profiles(id)
created_at      timestamptz default now()
unique(blocker_id, blocked_id)
```

---

#### `kindness_streaks`
```sql
id              uuid primary key default gen_random_uuid()
user_id         uuid references profiles(id)
circle_id       uuid references circles(id)
action_type     text                        -- 'voice_note' | 'check_in' | 'shared_something'
logged_at       timestamptz default now()
```

---

#### `heritage_corner`
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id)
uploaded_by     uuid references profiles(id)
media_url       text not null
caption         text
era_label       text                        -- e.g. "1970s", "Before you were born"
tags            text[]
created_at      timestamptz default now()
```

---

#### `bedtime_stories`
```sql
id              uuid primary key default gen_random_uuid()
circle_id       uuid references circles(id)
recorded_by     uuid references profiles(id)
title           text
storage_path    text not null
duration_secs   integer
created_at      timestamptz default now()
```

---

#### `notifications_log`
```sql
id              uuid primary key default gen_random_uuid()
user_id         uuid references profiles(id)
type            text                        -- 'digital_hug' | 'check_in_missed' | etc.
payload         jsonb
read_at         timestamptz
created_at      timestamptz default now()
```

---

### 6.3 Storage

| Bucket | Purpose | Access |
|---|---|---|
| `avatars` | User profile pictures | Public read, authenticated write |
| `circle-media` | Posts, shared images | Circle members only (RLS) |
| `voice-notes` | Voice note audio files | Circle members only (RLS) |
| `private-gallery` | Couple/personal private photos | Owners only (RLS) |
| `heritage-media` | Family heritage photos | Circle members only (RLS) |
| `bedtime-stories` | Recorded story audio | Circle members only (RLS) |

All media is served via signed URLs with 1-hour expiry for sensitive buckets.

---

### 6.4 Realtime

Supabase Realtime subscriptions used for:

| Feature | Table/Channel | Event |
|---|---|---|
| Mood Room updates | `mood_rooms` | `UPDATE` |
| Digital Hug received | `digital_hugs` | `INSERT` |
| Heartbeat received | `heartbeats` | `INSERT` |
| Check-In visible | `check_ins` | `INSERT` |
| Temperature Check responses | `temperature_checks` | `UPDATE` |
| New Circle post | `posts` | `INSERT` |
| SOS Alert | `sos_alerts` | `INSERT` (circle broadcast) |
| Together Mode detect | custom presence channel | join/leave |
| Quiet Hours status | `quiet_hours` | `UPDATE` |

---

### 6.5 Edge Functions

| Function | Trigger | Purpose |
|---|---|---|
| `deliver-future-letters` | Cron (every 5 min) | Check `future_letters.deliver_at`, push notification |
| `check-in-watchdog` | Cron (every hour) | Detect missed check-ins, send gentle follow-up push |
| `safety-check-escalator` | Cron (every minute) | Escalate unresolved safety checks past timeout |
| `send-push-notification` | Called by other functions | Unified push via FCM/APNs |
| `delete-expired-one-way-posts` | Cron (every 10 min) | Permanently delete expired one-way posts |
| `deliver-scheduled-morning-night-messages` | Cron (every minute) | Good Morning / Good Night feature |
| `purge-soft-deleted-posts` | Cron (daily) | Hard-delete posts in soft trash older than 30 days |

---

### 6.6 Row-Level Security (RLS)

**Core RLS Policies:**

```sql
-- Users can only read profiles of circle members they share
create policy "read_shared_circle_profiles"
on profiles for select
using (
  exists (
    select 1 from circle_members cm1
    join circle_members cm2 on cm1.circle_id = cm2.circle_id
    where cm1.user_id = auth.uid()
    and cm2.user_id = profiles.id
  )
);

-- Posts: only circle members can read
create policy "read_circle_posts"
on posts for select
using (
  exists (
    select 1 from circle_members
    where circle_id = posts.circle_id
    and user_id = auth.uid()
  )
);

-- Soft blocks: blocker can always see their own blocks
create policy "own_soft_blocks"
on soft_blocks for all
using (blocker_id = auth.uid());

-- Reflection wall: completely private
create policy "private_reflection_wall"
on reflection_wall for all
using (user_id = auth.uid());

-- Gratitude journal: private OR shared with circle member
create policy "read_gratitude"
on gratitude_journal for select
using (
  user_id = auth.uid()
  or (
    shared_with_circle_id is not null
    and exists (
      select 1 from circle_members
      where circle_id = shared_with_circle_id
      and user_id = auth.uid()
    )
  )
);

-- Blocked users cannot see content
-- (Applied via soft_blocks table join on all content policies)
```

---

## 7. Feature Specifications

---

### 7.1 Core Platform Features

#### Circles
The foundational unit of Tether. A Circle is a private group of 2–20 people. Types:
- **Friends Circle** (general)
- **Couple Circle** (exactly 2 members, unlocks Couples features)
- **Family Circle** (unlocks Family features)
- **In-Law Circle** (Feature 62 — boundaries built in, separate from main Family Circle)

**Creating a Circle:**
1. User taps "+" → Choose type → Name it → Invite via username/link
2. Invites expire after 7 days
3. Each Circle gets its own isolated feed, calendar, and vault

**Comfort Radius (Feature 13):**
Each Circle has a Comfort Radius setting:
- `Inner Circle` (1–5 members): Most intimate, all features unlocked
- `Close Circle` (up to 10): Standard features
- `All Friends`: Broader — some sensitive features auto-disabled

---

#### Feed
- Strictly chronological. No ranking. No algorithm. (Feature 18 — No-Algorithm Promise)
- No public comments. Reactions only (Feature 14 — Gentle Reactions)
- No engagement counts shown
- Posts can be: text, image, voice, letter (scheduled), or anonymous vent

---

#### Presence System
Online indicators show "Online" or "Quiet" — never "Last seen X ago" (Feature 21).
- **Active:** User is in app, available to chat
- **Quiet:** User is in app but not looking to chat (Feature 21)
- **Offline:** No indicator shown — not tracked

---

### 7.2 General Wellness Features (1–25)

---

#### Feature 1 — Mood Rooms 🌤️
**What it is:** Each user has a live "Mood Room" status visible to their Circle members.

**States (predefined + custom):**
- Need Quiet 🤫
- Feeling Anxious 😰
- Just Want to Chat 💬
- Happy 😊
- Tired 😴
- In My Head 🌀
- Open Door (always available) 🚪

**Behavior:**
- Mood status appears as a soft tinted ring around the user's avatar in Circle views
- Friends can see the status but there is zero pressure to act on it
- Circle members with a "Need Quiet" status auto-mute incoming DM previews
- Mood status auto-clears after 12 hours unless refreshed

**DB:** `mood_rooms` table, realtime subscription on circle member updates

---

#### Feature 2 — Quiet Hours / Wind Down Mode 🌙
**What it is:** User-defined time blocks where the app goes fully silent.

**Behavior:**
- No notifications, calls, or DMs delivered during Quiet Hours window
- 30 minutes before Quiet Hours start, a "Wind Down" begins: UI dims progressively, notification dot disappears, bottom nav labels fade
- At the Quiet Hours start time, the app presents a soft "Goodnight" screen with a breathing animation and dims itself
- Can be scheduled per-day-of-week
- Other users see a 🌙 indicator on the user's profile during Quiet Hours

**Settings:**
- Enable/disable toggle
- Start time, end time (per day of week)
- Wind-down duration (15 / 30 / 60 min options)

---

#### Feature 3 — Gratitude Journal 🙏
**What it is:** A private encrypted daily gratitude log with optional Circle sharing.

**Prompts (rotating):**
- "What made you smile today?"
- "Who showed up for you this week?"
- "What's something small you're grateful for?"
- "What moment would you want to remember?"

**Behavior:**
- Written client-side, encrypted with user's derived key before upload
- Supabase stores only the ciphertext
- Optional: Share a single entry (not the whole journal) to a Circle — shared entries are also encrypted but the Circle decryption key allows members to read
- Past entries browseable as a calm scrollable list (no calendar, just chronological cards)

---

#### Feature 4 — Voice Notes Only (Slow Chat) 🎙️
**What it is:** A conversation mode where only voice notes can be sent.

**Behavior:**
- Activated per-conversation by either participant
- All text/image input is hidden; only a large, calm record button is shown
- Voice notes in Slow Chat mode have a minimum 5-second silence before send (prevents impulsive short clips)
- Notifications are gentle: no content preview, just "[Name] left you a voice note 🎙️"

---

#### Feature 5 — Shared Playlists / Ambient Sounds 🎵
**What it is:** Curated ambient sound collections shareable within Circles.

**Sound categories:**
- Rain sounds (light drizzle, thunderstorm, rain on windows)
- Lo-fi beats
- White noise / brown noise / pink noise
- Forest ambience
- Coffee shop background
- Fireplace

**Behavior:**
- Sounds are hosted in Supabase Storage
- Users can share a currently-playing ambient to their Circle with one tap
- "Listening Together" indicator: if multiple Circle members are playing the same sound, a soft "2 of you are here 🎵" appears (opt-in)

---

#### Feature 6 — Memories Lane 📸
**What it is:** A chronological timeline of shared moments within a Circle.

**What appears:**
- Shared photos
- Milestones (first message, anniversaries, etc.)
- Notable voice notes (auto-tagged or user-tagged)
- User-added memories ("We met today!" — manual entry)

**Behavior:**
- Organized by month, displayed as a warm card-based scroll
- No likes, no comments — just "remember when?"
- Tapping a memory expands it to full-screen with a soft ambient reveal animation
- Users can add a caption to any memory (retroactively)

---

#### Feature 7 — Check-In System 🤝
**What it is:** A daily one-tap "I'm okay" signal.

**Behavior:**
- Home screen shows a soft "Check In" prompt each morning
- One tap sends to all Circles the user belongs to
- Friends see a gentle ✓ next to the user's name for that day
- If a user doesn't check in for 2 consecutive days and has the watchdog enabled, their close Circle gets a gentle "We haven't heard from [Name] in a while 💙" prompt
- Completely opt-in; no one is penalized for missing check-ins

---

#### Feature 8 — No-Likes, No-Counts 👻
**Implementation:**
- No like button exists anywhere in the app
- No view counts, no read receipts (unless user enables them for DMs individually)
- Reaction counts are hidden — you can see WHO reacted but not a number prominently displayed

---

#### Feature 9 — Breathing Exercises On Open 🌬️
**What it is:** A grounding animation on app launch.

**Behavior:**
- A soft radial circle expands and contracts for 3 seconds on app open
- Accompanied by subtle text: "Take a breath."
- Background fills with current time theme accent color at 15% opacity
- After 3 seconds, auto-transitions to home screen
- Users can tap anywhere to skip
- Can be disabled in Settings → Wellness

---

#### Feature 10 — Safe Space Lock 🔐
**What it is:** A second-level biometric lock for specific Circles, DMs, or Vault items.

**Behavior:**
- Users can "lock" any Circle or DM thread
- Locked items appear blurred/hidden in the main list view — only a lock icon shown
- Unlocking requires Face ID / Touch ID / PIN (separate from device lock)
- Emergency SOS overrides Safe Space Lock

---

#### Feature 11 — Temperature Check 🌡️
**What it is:** A daily collective mood poll in each Circle.

**Behavior:**
- Automatically posted once per day in each Circle (at a customizable time, default 9am)
- Emoji options: 😊 😐 😔 😰 🤗 (can be customized per Circle)
- Responses appear as colored dots next to each member's name — no comment, no discussion pressure
- Results visible to all Circle members
- Not logged historically — resets each day

---

#### Feature 12 — Soft Block 🌫️
**What it is:** A non-confrontational way to stop seeing someone's content.

**Behavior:**
- Blocked user's posts, reactions, and DMs are invisibly filtered
- Blocked user receives NO notification
- From their perspective, your content may appear to post normally (they can still post to shared circles; their content just doesn't reach you)
- Soft block is different from Hard Block (which removes them from shared circles and is explicit)

---

#### Feature 13 — Comfort Radius 🎯
*(Detailed in Core Features — Circles section above)*

---

#### Feature 14 — Gentle Reactions 💫
**Reaction set:**
- 🌸 **Warm** — general warmth
- 🫂 **Comforting** — I'm here
- 👁️ **I See You** — I notice you, you're not invisible
- 💙 **Sending Strength** — when words aren't enough

No numbers. No leaderboards. Reactions are shown as the reactor's small avatar below the post. Max display: 5 avatars, then "+N more" (still no count emphasis).

---

#### Feature 15 — Digital Hug 🤗
**What it is:** A notification that appears as a gentle pulse with no text.

**Behavior:**
- Sending: Single tap on a friend's avatar → "Send a hug 🤗" → sends
- Receiving: The phone shows a warm radial pulse animation on the lock screen (custom notification style)
- No sound by default — only haptic feedback (gentle double-tap pattern)
- Receiver can "hug back" with one tap, or just sit with it
- No read receipt — the sender never knows if it was seen

---

#### Feature 16 — Breathing Room 🌬️
**What it is:** A dedicated panic/pause screen.

**Layout:**
- Full-screen, current time theme background
- Large, slow 4-7-8 breathing animation (expand for 4 counts, hold for 7, release for 8)
- Optional ambient sound selector (rain, white noise, silence)
- Text: "You're okay. Take your time."
- Accessible from: home screen floating button, notification shortcut, DM header

---

#### Feature 17 — Sunset Mode 🌅
**Implementation:**
- Automatically activates at sunset (calculated from device location/time zone)
- Warmer color temperature in the UI — slightly reduced blue light in palette
- This overlaps significantly with the Evening/Dusk theme slot but specifically targets post-sunset regardless of exact time
- The `TimeThemeEngine` incorporates local sunset time from the system calendar API

---

#### Feature 18 — No-Algorithm Promise 📜
**Implementation:**
- All Circle feeds are strictly reverse-chronological
- A small "Feed is chronological ✓" indicator appears at the top of every feed
- No "You might also like" or "Based on your activity" anywhere in the app
- Settings → About → Our Promise: A plaintext page explaining Tether's no-tracking, no-ranking commitment

---

#### Feature 19 — Letter Mode ✉️
**What it is:** Write a longer, thoughtful message delivered at a chosen time.

**Behavior:**
- UI transforms into a warm, paper-textured compose screen (subtle noise texture overlay)
- Minimum character count: 50 (encourages thoughtfulness)
- Sender chooses delivery time: "Tomorrow morning," "This weekend," "Custom date/time"
- Once sent, the letter is stored encrypted in Supabase with `deliver_at` timestamp
- Edge Function delivers at the scheduled time with a push notification
- Recipient sees: a sealed envelope animation, then a slow unfold on open

---

#### Feature 20 — Reflection Wall 🧱
**What it is:** A fully private, encrypted, never-shared personal space.

**Behavior:**
- Write anything — vent, process, celebrate, ramble
- Content is encrypted client-side before storage (AES-256)
- Supabase never stores or can read plaintext
- No sharing option anywhere — the UI literally has no share button
- Styled as a warm, slightly textured journal with the current time theme

---

#### Feature 21 — Presence, Not Pressure 👀
*(Detailed in Core Features — Presence System section above)*

---

#### Feature 22 — Kindness Streaks 🌻
**What it is:** Private tracking of small acts of kindness.

**Tracked actions (auto-detected):**
- Sent a voice note
- Completed a check-in
- Shared an ambient sound with the circle
- Responded to a Temperature Check
- Sent a Digital Hug

**Behavior:**
- No leaderboards, no comparison to others
- A weekly personal summary: "This week you sent 3 voice notes and checked in 5 times 🌻"
- Badges are private — only visible to the user in their own profile
- Badge names are warm, not competitive: "Consistent Presence," "Good Listener," "Anchor"

---

#### Feature 23 — Shared Calendar 📆
**What it is:** A Circle-shared calendar for meaningful dates.

**Event types:**
- Regular dates (birthdays, anniversaries)
- Relationship-specific ("The day we met," "First voice call")
- Plans ("Movie night Friday," "Dinner Sunday")
- Recurring ("Weekly family call — every Sunday 6pm")

**Behavior:**
- Displayed as a simple month view + upcoming events list
- Reminders sent 1 day before (with a gentle, non-intrusive notification)
- No integration with device calendar (privacy-first) — Tether calendar is self-contained

---

#### Feature 24 — No-Notification Windows 🤫
*(Implemented as part of Quiet Hours — Feature 2. Also configurable per-contact: "No calls from [Name] after 10pm")*

---

#### Feature 25 — Slow Photo 🖼️
**Implementation:**
- All images in the app load with a 600ms ease-in opacity fade from 0→1
- No skeleton loaders — instead, a very soft placeholder in the current theme's background secondary color
- Blur-up technique: a 4px blurred thumbnail loads first, then resolves to full quality
- This applies universally: feed images, gallery photos, heritage photos, memory lane

---

### 7.3 Couples Features (26–35, 46–55)

These features unlock **only** when a Circle is of type `couple` and has exactly 2 members.

---

#### Feature 26 — Our Bubble 💕
**What it is:** A private, encrypted shared space just for the two partners.

**Contents:**
- Shared private gallery (Feature 33)
- Couple-specific feed
- Our Song (Feature 46)
- Promise Rings status (Feature 34)
- Shared calendar (Feature 23, scoped to couple)
- Private Jokes Vault (Feature 50)
- Future Letters timeline (Feature 51)

**UI:** Accessed via a dedicated "Bubble" tab in the Couple Circle. Background has a warm, soft gradient unique to the couple (customizable from a curated palette).

---

#### Feature 27 — Love Languages Tracker 💬
**What it is:** A mutual tracker of how each partner expresses and receives love.

**Five love languages:**
- Words of Affirmation
- Quality Time
- Receiving Gifts
- Acts of Service
- Physical Touch

**Behavior:**
- Each partner sets their primary/secondary love languages
- Tether offers one gentle suggestion per week: "This week, try [specific action] for [partner's name]"
- Suggestions are generated based on the partner's love language settings
- Completely private — suggestions are only seen by the person they're generated for

---

#### Feature 28 — Relationship Milestones 🎂
**What it is:** An automatic and manual timeline of "your story."

**Auto-tracked:**
- Date of first message in Tether
- Date of first voice note
- Date of first photo shared
- Date they mutually set up a Couple Circle

**Manual:**
- "The day we met"
- "Our first date"
- "The day you said yes"
- Custom milestones

**Displayed** in a warm, scroll-able vertical timeline in Our Bubble.

---

#### Feature 29 — Good Morning / Good Night 💌
**What it is:** Scheduled daily messages sent automatically.

**Behavior:**
- Partner A sets a Good Morning message: "[Name], good morning 🌅 I hope your day is warm."
- Sets delivery time: e.g., 7:30 AM partner's local time
- Edge Function delivers it on schedule as a push notification + in-app DM
- Same for Good Night
- Messages can be updated anytime; if not updated, the same message repeats
- Feels personal — partner A chose the words in advance

---

#### Feature 30 — Together Mode 📱
**What it is:** A special shared UI that activates when both partners are in the app simultaneously.

**Behavior:**
- Detected via Supabase Realtime presence channel (both partners join a shared channel when app is foregrounded)
- After 10 seconds of both being present, a subtle banner appears: "You're both here 🌙"
- A dedicated "Together Mode" screen opens (opt-in tap):
  - Shared ambient sound player (one controls, other hears)
  - A soft shared canvas (both can see the same ambient visual)
  - No chat — just co-presence
- Automatically exits when either partner leaves the app

---

#### Feature 31 — Heartbeat Check 💓
**What it is:** An "I'm thinking of you" pulse with no sound.

**Behavior:**
- Sending: Single tap on the heartbeat icon in Couple view
- Receiving: A warm amber/rose pulse appears on the partner's lock screen widget
- No notification sound, no vibration — purely visual warmth
- The animation: a soft concentric ripple in the dusk accent colors
- Both partners see a shared count of heartbeats sent today (private to them)

---

#### Feature 32 — Date Planner 📅
**What it is:** A shared space to plan dates.

**Sections:**
- **Ideas:** A running list of date ideas (added by either partner, no attribution shown so it feels collaborative)
- **Planned:** Confirmed upcoming dates with time/place
- **Memories:** Past dates, with optional photos added after

**No AI suggestions** — this is intentional. The ideas should come from the couple, not an algorithm.

---

#### Feature 33 — Private Gallery 🖼️
**What it is:** A shared photo space only the two partners can see.

**Behavior:**
- Photos stored in the `private-gallery` Supabase Storage bucket
- RLS: only the two circle members can read/write
- Photos are not backed up to any third-party — Tether is the only store
- Gallery is organized chronologically with optional manual albums
- Viewing a photo triggers the Slow Photo fade-in (Feature 25)

---

#### Feature 34 — Promise Rings (Digital) 💍
**What it is:** A digital commitment ritual.

**Behavior:**
- Either partner initiates: "I choose you today 💍"
- Partner sees a notification and can accept
- Once mutual, a timestamp is recorded and a small ring icon appears in Our Bubble header
- The text "I choose you today" is customizable
- Not permanent — either partner can gently dissolve it, but this triggers a "Space to Breathe" (Feature 35) prompt first

---

#### Feature 35 — Space to Breathe 🌿
**What it is:** A "pause" button for when things are hard.

**Behavior:**
- Either partner can activate: "I need space, but I love you 🌿"
- The other partner receives a gentle notification with that exact message
- For the next configured period (2 hours to 7 days), messaging is put on hold — messages can be drafted but delivery is paused
- No "seen" indicators during Space to Breathe
- The pause can be lifted by either partner at any time
- Designed to prevent impulsive, regrettable messages during conflict

---

#### Feature 46 — Our Song 🎵
**What it is:** A song designated as "yours."

**Behavior:**
- Either partner can propose a song (search by title)
- The other accepts → it becomes "Our Song"
- Whenever either partner opens the Couple Circle, the song plays softly in the background (at ~15% volume), fading in over 2 seconds
- Partners can send songs to each other as messages — the song plays inline in the DM
- "Our Song" history: all past designated songs are saved in a list

---

#### Feature 47 — Favor Coupons 🎟️
**What it is:** "I owe you" digital coupons.

**Examples:**
- "One back rub, no questions asked"
- "Pick dinner — I'll agree with anything"
- "Free pass from one argument this week"
- Custom text

**Behavior:**
- Partner creates a coupon, assigns it to the other
- Partner can "redeem" it at any time with one tap
- Redeemed coupons move to a "Claimed" section with a timestamp
- No expiry by default (partner A can optionally set one)

---

#### Feature 48 — Sleep Together 🌙
**What it is:** A shared bedtime ambient experience.

**Behavior:**
- Both partners signal "Going to sleep 🌙"
- If both signal within 30 minutes of each other, Sleep Together activates
- One partner becomes the "player" — controls the ambient sound (rain, white noise, etc.)
- Both hear the same ambient stream
- App dims to near-black after 5 minutes of inactivity
- Auto-exits after 8 hours or when either partner dismisses

---

#### Feature 49 — Mood Sync 🌡️
**What it is:** Partner's Mood Room status visible on your lock screen.

**Behavior:**
- Requires iOS 16+ Lock Screen Widget / Android 12+ Widgets
- Displays: partner's name + current mood emoji + small colored dot
- Updates in realtime
- Can be disabled in Settings → Couple → Privacy

---

#### Feature 50 — Private Jokes Vault 😂
**What it is:** A shared space for inside jokes, memes, and screenshots only the two of them understand.

**Behavior:**
- Either partner can save anything here: screenshots, photos, short videos, text
- Organized chronologically
- No search (intentional — the fun is in scrolling through)
- Accessible from Our Bubble

---

#### Feature 51 — Future Letter 💌
**What it is:** A letter written today, delivered at a future date.

**Behavior:**
- Compose in Letter Mode (Feature 19), but with a future delivery date
- Example: "Open this on our anniversary in December"
- Stored encrypted, delivered by Edge Function at the set time
- Both the writing date and the opening date are shown when opened
- A small "vault" animation plays when the letter arrives — a wax-seal breaking open slowly

---

#### Feature 52 — Relationship Advice Library 📚
**What it is:** A curated, calm library of relationship guidance.

**Content:** Handpicked articles and short reads on:
- Communication in relationships
- Understanding love languages in practice
- Long-distance relationship tools
- Conflict resolution without damage
- Attachment styles (explained gently)

**No AI generation.** Content is human-curated and editorially reviewed. New content added monthly.

---

#### Feature 53 — Distance Mode 🌍
**What it is:** A dedicated mode for long-distance couples.

**Unlocks:**
- A clock showing partner's local time on the Couple home screen
- Longer voice note limit (10 min instead of 3 min)
- Scheduled call reminders (weekly recurring)
- "I miss you" trigger (sends a quiet, warm notification — no response required)
- Distance is shown as "[City] ↔ [City]" if both partners set their city (optional)

---

#### Feature 54 — Little Surprises 🎁
**What it is:** A scheduled random surprise that pops up on the partner's screen.

**Behavior:**
- Partner A writes a surprise: a sweet note, a photo, a GIF, a voice note
- Sets a time window: "Anytime this week" / "Tomorrow between 2–5pm" / "Specific time"
- At a random moment within that window, the surprise appears as a full-screen warm overlay on the partner's app
- No advance warning — just a soft chime and a reveal animation

---

#### Feature 55 — Anniversary Countdown 🎉
**What it is:** A countdown widget to the next special date.

**Behavior:**
- Shows on the Couple home screen: "18 days until our anniversary 🌹"
- Supports multiple countdowns: anniversary, special trip, moving-in day, etc.
- On the day itself, a celebration animation plays on app open (confetti in the current time theme's colors)

---

### 7.4 Family Features (36–45, 56–65)

These features unlock in `family` and `inlaw` Circle types.

---

#### Feature 36 — Family Circle 👨‍👩‍👧‍👦
The foundational family grouping with:
- Shared family feed (Feature 40)
- Optional location sharing (Feature 41)
- Safety Check-In system (Feature 37)
- Generational Memories archive (Feature 45)
- Heritage Corner (Feature 43)

---

#### Feature 37 — Safety Check 🛡️
**What it is:** Parent/admin-triggered "are you safe?" requests.

**Behavior:**
- Any admin triggers a Safety Check for a specific member or the whole circle
- Target member receives: a gentle "Family wants to know you're okay 💙" notification with a single "I'm Safe" button
- If no response within the configured timeout (default 30 min, configurable 5 min – 2 hours): designated emergency contacts are notified
- Safety Check status visible to all circle members in realtime
- **Edge Function** monitors timeout via cron

---

#### Feature 38 — Kid Mode 🧸
**What it is:** A restricted view for children.

**Behavior:**
- Parents configure Kid Mode for a specific family member account (requires family admin role)
- Kid Mode hides: all content outside the Family Circle, DMs from non-family, any posts with adult content flags
- UI simplifies: larger text, fewer navigation options, brighter morning-only color scheme (no dark themes)
- Kid Mode can only be disabled by a parent/admin from their own device

---

#### Feature 39 — Grandparent Easy View 👴👵
**What it is:** A simplified UI mode for elderly family members.

**Changes:**
- Font size increased by 140% (Playfair Display remains for warmth)
- Bottom navigation replaced by a single scrollable home with 4 large tiles: See Family, Call Someone, New Photo, I'm Okay
- One-tap video calling prominent on the home screen
- All destructive actions require double confirmation

---

#### Feature 40 — Family Feed 📻
A private, strictly chronological feed for the Family Circle. Same principles as Circle feed (Feature 18) — no algorithm, no ads, no engagement counts.

---

#### Feature 41 — Location Family 🌎
**What it is:** Optional live location sharing within the Family Circle.

**Behavior:**
- Each family member independently opts in (not controlled by admin)
- Location precision: "At home," "At work/school," "In [neighborhood]" — not GPS-precise by default
- Precise GPS opt-in available (off by default)
- Location visible to Family Circle members on a simple soft map
- Location auto-pauses during Quiet Hours

---

#### Feature 42 — Reminder Board 📝
**What it is:** A shared family to-do board.

**Tasks:**
- Created by any family member
- Assigned to a specific person or "anyone"
- Marked complete with one tap
- No notifications for uncompleted tasks — check the board when you remember to
- Recurring tasks supported (e.g., "Weekly bins — every Sunday")

---

#### Feature 43 — Heritage Corner 🌍
**What it is:** A space to preserve and share family history.

**Behavior:**
- Any family member can upload photos with a caption, era label, and optional tags
- "Era" labels: "Before I was born," "When Dad was young," "The 80s," etc.
- Younger members can tap to ask a question: leaves a comment thread on that photo
- Elders can record voice note answers to those questions
- Content is never deleted unless explicitly done by uploader

---

#### Feature 44 — Emergency SOS 🚨
**What it is:** One-tap alert to all family members.

**Behavior:**
- A hidden, gesture-activated trigger (triple-tap on a hidden corner + hold for 2 seconds — avoids accidental triggers)
- On activation: sends all Family Circle members a push notification with the sender's current GPS location
- Location is precise (one-time, not live)
- All family members who have notifications enabled receive it immediately
- Bypasses Quiet Hours and Safe Space Lock

---

#### Feature 45 — Generational Memories 📂
**What it is:** A living family archive contributed by all generations.

**Behavior:**
- Elder family members upload: old photos, documents, voice recordings
- Context fields: Who is in this? When was this? Where was it?
- Younger members can "react" (warm only — no like counts), ask questions, add their own memories connected to the elder's
- Browseable as a family timeline going back as far as any uploaded content
- Downloadable as a PDF archive (Edge Function renders it)

---

#### Feature 56 — Chore Chart 📋
**What it is:** A gamified (gently) shared family chore list.

**Behavior:**
- Chores assigned to specific members with optional recurrence
- Children earn "Seeds" 🌱 (not points — seeds grow into trees) for completed chores
- Parents can see completion history without nagging
- Seeds are private — not shown competitively between siblings

---

#### Feature 57 — Prayer / Meditation Time 🙏
**What it is:** A shared daily spiritual or mindfulness moment.

**Behavior:**
- Family admin sets a daily time and labels it ("Morning Prayer," "Evening Meditation," "Gratitude Time")
- At the set time, opted-in members receive a gentle notification
- Tapping the notification opens the Breathing Room (Feature 16) with the session labeled appropriately
- Live indicator: "3 family members are in this moment right now 🕊️"

---

#### Feature 58 — Bedtime Stories 📖
**What it is:** Recorded parent/grandparent voice stories for children.

**Behavior:**
- Any family member with mic access can record a bedtime story
- Stored in Supabase Storage with title, duration, and recorder's name
- Children in Kid Mode can access a "Stories" section with a simple play interface
- Grandparents can record remotely — the child hears Grandma's voice at bedtime regardless of distance

---

#### Feature 59 — Family Rituals 🎎
**What it is:** Scheduled recurring family moments.

**Behavior:**
- Ritual types: "Sunday Call," "Friday Movie Night," "Monthly Dinner"
- At the ritual time, all opted-in members get a gentle "It's Family Ritual time 🌻" notification
- Tapping opens a dedicated Ritual Room: group voice/video call + shared ambient sound + family feed pinned to that session

---

#### Feature 60 — Homework Help Network 📚
**What it is:** An in-family help network for school work.

**Behavior:**
- Family member posts: "Need help with [subject]"
- Available family members can respond with text, voice note, or image
- Resolved with a "Thanks! Got it ✓" tap
- No external content — fully within the Family Circle

---

#### Feature 61 — Family Pet Corner 🐾
**What it is:** A dedicated photo feed for family pet updates.

**Behavior:**
- A sub-feed within the Family Circle, accessible via a paw icon
- Posts here are pets-only (trust-based, not enforced)
- Same gentle reactions (warm, comforting, etc.) — adapted for pet context: 🐾 "Precious," 🌸 "So fluffy"

---

#### Feature 62 — In-Law Circle 👥
**What it is:** A separate, boundaried Circle type for in-laws.

**Behavior:**
- Created separately from the main Family Circle
- Does NOT automatically inherit content from the Family Circle
- Boundaries are architectural — no bleed between the two circles unless explicitly shared
- Can be toggled to "Low Activity" mode: no notifications, gentle check-ins only

---

#### Feature 63 — Sibling Bond Tracker 👫
**What it is:** Sibling-specific connection tools.

**Behavior:**
- Siblings within a Family Circle can create a sub-space just between them
- Track shared moments: "We called last week ✓"
- Coordinate surprise birthday plans secretly (posts only visible to the coordinators)
- Send "thinking of you" notes that arrive softly

---

#### Feature 64 — Family Reunion Planner 🎊
**What it is:** A dedicated event planning space.

**Sections:**
- **Date Poll:** All family members vote on available dates
- **Budget Pool:** Collect contributions (tracked as text amounts, no payment processing in v1)
- **Task List:** Who's bringing what, who's organizing what
- **Post-Reunion Gallery:** A locked shared album unlocked only on the reunion date

---

#### Feature 65 — Emergency Family Contact 🚨
*(See Feature 44 — same SOS system, clarified here as a general emergency tool for any life emergency, not just safety-check escalations)*

---

### 7.5 Extended Features (66–75)

---

#### Feature 66 — Anonymous Venting 🤫
**What it is:** Share a feeling anonymously within a Circle.

**Behavior:**
- Post type: "Anonymous" — identity is hidden from circle members
- Author identity is stored encrypted in Supabase (not anonymous to the system for moderation reasons — but never surfaced to users)
- Friends respond with comfort reactions only — no guessing
- Anonymous posts expire after 24 hours automatically

---

#### Feature 67 — One-Way Post 📤
**What it is:** A post that disappears after being seen.

**Behavior:**
- Marked "One-Way" at post creation
- Recipient(s) see it once — upon opening, a soft countdown appears: "This will fade in 10 seconds"
- After being opened, it is marked for deletion; Edge Function purges it within 10 minutes
- No screenshot detection (that creates anxiety) — but a gentle "This post is meant to fade 🌸" reminder shown

---

#### Feature 68 — Soft Delete 🗑️
**What it is:** Posts go to a "soft trash" for 30 days before permanent deletion.

**Behavior:**
- Deleting a post shows: "Moved to trash. It'll be gone in 30 days."
- Posts in trash are invisible to circle members immediately
- User can restore from Settings → My Trash within 30 days
- After 30 days, Edge Function permanently purges

---

#### Feature 69 — Accessibility Mode ♿
**What it is:** Full accessibility support.

**Implemented:**
- Full screen reader support (Flutter Semantics throughout)
- High contrast mode (increases all border/text contrast to WCAG AA+)
- Larger fonts option (scales independently of system setting by up to 200%)
- Reduced motion mode (disables all non-essential animations)
- Voice navigation support (where platform allows)

---

#### Feature 70 — Mood-Adaptive UI 🎨
**What it is:** Subtle UI color shifts based on the user's own Mood Room status.

**Behavior:**
- Calm/Quiet mood → accent shifts slightly cooler (blues/greens)
- Happy mood → accent shifts warmer (ambers/peach)
- Anxious mood → UI desaturates slightly, breathing animation auto-appears at bottom of screen
- This is additive on top of the time-theme — mood shifts only the accent hue, not the full palette
- Fully optional; can be disabled in Settings → Wellness

---

#### Feature 71 — Gentle Nudge 🌱
**What it is:** A notification that tells you someone posted — but not what.

**Notification text:** "[Name] shared something 🌱" — no preview, no content reveal. User can choose to look or not. Zero FOMO engineering.

---

#### Feature 72 — Once Upon a Time 📖
**What it is:** A "this day last year" memory feature.

**Behavior:**
- Each morning, if there's content from exactly one year ago in any Circle, a soft notification appears: "A year ago today 🌅"
- Tapping opens a warm, full-screen memory reveal with the original post and a "Remember this?" prompt
- No pressure to respond — it's just a warm moment

---

#### Feature 73 — Whisper Mode 🤫
**What it is:** A mode where all text appears smaller, softer, quieter.

**Behavior:**
- Activated from Settings → Wellness → Whisper Mode, or from the app's bottom floating context menu
- All body text reduces to 12sp, letter-spacing increases to 0.05em, font weight drops to 300
- The UI feels like it's speaking in a hushed voice
- Perfect for evenings — pairs naturally with the Night theme
- Auto-activates during Quiet Hours wind-down period if enabled

---

#### Feature 74 — Mirror Mode 🪞
**What it is:** A front-camera preview while recording a voice/video message.

**Behavior:**
- When composing a voice note or video message, an optional small circular front-camera preview appears in the corner
- Users can see their own face, which can help them feel more comfortable and natural when recording
- Preview is local only — it is never sent or stored
- Toggle it on/off during recording with a single tap

---

#### Feature 75 — Gentle Gamification 🌱
**What it is:** Private, personal milestone badges.

**Badge examples:**
- 🌱 **Rooted** — Checked in 7 days in a row
- 🎙️ **Voice** — Sent 3 voice notes this week
- 🌻 **Anchor** — Present every day this month
- 💌 **Pen Pal** — Wrote 5 letters
- 🫂 **Warm Presence** — Sent 10 Digital Hugs
- 🌙 **Night Owl** — Used the app consistently during Quiet Hours mode (gently flagged for wellness consideration)

**No leaderboards. No friends can see. No notifications when a badge is earned** — you discover it yourself when you visit your profile. Finding it quietly is the reward.

---

## 8. User Flows

### Onboarding Flow

```
Splash (3s Breathing Animation)
  ↓
Welcome Screen — "Stay close. Stay calm."
  ↓
Sign Up (email + display name + username)
  ↓
Verify Email
  ↓
Set Avatar (optional — can skip)
  ↓
"How do you want to use Tether?" → [Friends] [Couple] [Family] [All of the above]
  ↓
First Circle Setup → Invite people
  ↓
Quiet Hours Setup (optional — "When do you want peace?")
  ↓
Home Screen (with a soft "Welcome to your space, [Name]" message that fades after 5 seconds)
```

---

### Sending a Digital Hug

```
Home → Circle → Member avatar → long-press / context menu
  ↓
"Send a hug 🤗" → tap
  ↓
Confirmation: soft radial animation plays on sender's screen
  ↓
Receiver: lock screen shows warm pulse animation (no sound, haptic only)
  ↓
Receiver opens notification → "Hug back?" or "Sit with it 🌸"
```

---

### Activating Breathing Room

```
Any screen → Floating calm button (bottom right, always visible)
  OR
Notification shortcut
  ↓
Full-screen breathing animation loads
  ↓
4-7-8 breathing cycle begins with soft visual cue
  ↓
Ambient sound auto-plays (Rain, default) — can be changed
  ↓
"Done" button or swipe down to exit after any point
```

---

### Family SOS

```
Triple-tap hidden corner + 2s hold
  ↓
Confirmation: "Send SOS to Family?" [Cancel] [Send Now]
  ↓
SOS sent → GPS location captured → Push to all Family Circle members
  ↓
Family members receive critical notification (bypasses all Quiet Hours/DND)
  ↓
Each member taps "I'm on my way" or "I'm here for you"
  ↓
Sender sees who responded in-app
```

---

## 9. Notification Strategy

All notifications follow a single principle: **never create anxiety**.

| Type | Timing | Style | Sound |
|---|---|---|---|
| Digital Hug received | Immediate | Warm pulse visual | None (haptic) |
| Check-In reminder | Daily, user-set time | Soft banner | Chime (optional) |
| Missed check-in (friend) | 48h after last check-in | Gentle text only | None |
| New Circle post | Immediate | "[Name] shared something 🌱" — no preview | Soft tone |
| Letter delivered | Scheduled time | "A letter arrived for you ✉️" | Soft chime |
| Temperature Check | Daily, Circle-configured time | Soft banner | None |
| Safety Check triggered | Immediate | Named notification | Alert tone |
| SOS Alert | Immediate | Critical — bypasses all silencing | Alert tone |
| Family Ritual time | Set time | "[Ritual name] is starting 🌻" | Soft chime |
| Good Morning / Good Night | Scheduled | Message preview shown | Silent |
| Anniversary Countdown (day of) | 8am | Celebration visual | Soft chime |
| Heartbeat received | Immediate | Lock screen visual pulse | None |

**No notification contains full content previews** unless the user explicitly enables this in Settings → Notifications → Show Previews.

**Notifications are silenced during Quiet Hours** (except SOS which always bypasses).

---

## 10. Privacy & Security

### Encryption
- **Client-side AES-256:** Gratitude Journal, Reflection Wall, Future Letters, Our Bubble vault content
- Keys derived from user's password + a per-user salt (never stored server-side)
- If the user forgets their password: encrypted content is irretrievably lost — this is disclosed clearly at setup
- Supabase storage of encrypted blobs: zero knowledge of content

### Data Minimisation
- No analytics SDKs (no Firebase Analytics, no Mixpanel) in v1
- No advertising identifiers collected
- Device location used only for: Sunset Mode time calculation (computed locally), Family Location sharing (only if user opts in), Emergency SOS (one-time snapshot)

### Security
- All Supabase tables have RLS enabled — zero public access
- Signed URLs with expiry for all media
- Soft Block and Hard Block both prevent data leakage at RLS level
- Rate limiting on all Edge Functions
- SOS location data is purged after 72 hours

### Transparency
- Settings → Privacy → What We Store: A plain-language breakdown of every data point collected
- Settings → Export My Data: Download a JSON of all personal data (GDPR-compliant)
- Settings → Delete My Account: Immediate soft-delete, hard-purge within 30 days

---

## 11. Monetization

### Free Tier
- 1 Circle, up to 5 members
- Core wellness features (Mood Rooms, Breathing Room, Quiet Hours)
- Basic messaging (text + images)
- Gratitude Journal (30 entries)
- Check-In System

### Tether Plus (subscription — monthly/annual)
- Unlimited Circles
- All Couples features
- All Family features
- Voice Notes (Slow Chat)
- Letter Mode
- Future Letters
- Memory Lane (unlimited)
- Shared Ambient Sounds
- Bedtime Stories
- Gentle Gamification badges
- Priority support

### Pricing Philosophy
- Following PPP-adjusted pricing for global markets
- Base price: ~$4.99/month or $39.99/year (USD)
- Family plan: $7.99/month or $59.99/year (up to 10 members)
- Student rate: ~$2.99/month with `.edu` verification

**No ads. Ever. No data sales. Ever.**

---

## 12. Tech Stack

| Layer | Technology | Rationale |
|---|---|---|
| Mobile Framework | Flutter (Dart) | Cross-platform, expressive animations, single codebase |
| State Management | flutter_bloc | Predictable, testable, scales cleanly |
| DI | get_it + injectable | Lightweight, type-safe |
| Backend | Supabase | Auth + DB + Storage + Realtime + Edge Functions in one |
| Database | PostgreSQL (via Supabase) | Relational, mature, excellent RLS |
| Realtime | Supabase Realtime | WebSocket subscriptions for live features |
| Edge Functions | Deno (Supabase) | Cron jobs, push delivery, encryption operations |
| Local Storage | Hive (fast) + Drift (relational local cache) | Offline support |
| Secure Storage | flutter_secure_storage | Encryption keys, session tokens |
| Push Notifications | Firebase Cloud Messaging (Android) + APNs (iOS) via Supabase Edge Functions | Reliable cross-platform push |
| Audio | just_audio | Voice note playback, ambient sounds |
| Audio Recording | record | Voice note capture |
| Image Caching | cached_network_image + custom blur-up | Slow Photo (Feature 25) |
| Encryption | cryptography (Dart) | AES-256 client-side |
| Camera | camera | Mirror Mode (Feature 74) |
| Location | geolocator | Family Location, SOS |
| Fonts | Google Fonts (Playfair Display, Lora, DM Sans) | Typography system |
| Animations | flutter_animate + rive (select screens) | Breathing, hug pulse, theme transitions |

---

## 13. Versioned Roadmap

### v0.1 — Internal Alpha
- [ ] Supabase project setup, all tables + RLS
- [ ] Auth flow (email/magic link)
- [ ] Profile creation
- [ ] Single Circle type (friends)
- [ ] Basic text + image posts
- [ ] Time-theme engine (all 4 themes)
- [ ] Mood Rooms
- [ ] Check-In System

### v0.5 — Closed Beta
- [ ] Quiet Hours / Wind Down Mode
- [ ] Gratitude Journal (encrypted)
- [ ] Digital Hug
- [ ] Breathing Room
- [ ] Voice Notes (standard)
- [ ] Slow Photo
- [ ] Gentle Reactions
- [ ] No-Algorithm feed
- [ ] Soft Block
- [ ] Reflection Wall (encrypted)
- [ ] Memories Lane

### v1.0 — Public Launch
- [ ] All General Wellness Features (1–25)
- [ ] Couple Circle + all Couples Features (26–35)
- [ ] Family Circle + all Family Features (36–45)
- [ ] Safe Space Lock
- [ ] Letter Mode
- [ ] Shared Calendar
- [ ] Tether Plus subscription

### v1.5 — Post-Launch
- [ ] Couples Features 46–55
- [ ] Family Features 56–65
- [ ] Extended Features 66–75
- [ ] Grandparent Easy View
- [ ] Kid Mode (parental controls)
- [ ] Accessibility Mode full pass
- [ ] Family Reunion Planner

### v2.0 — Growth Phase
- [ ] Together Mode
- [ ] Sleep Together
- [ ] Distance Mode
- [ ] Generational Memories PDF export
- [ ] Lock Screen widgets (iOS + Android)
- [ ] Mood Sync widget
- [ ] Heartbeat lock screen animation (native)
- [ ] Heritage Corner
- [ ] Bedtime Stories

---

## 14. Open Questions

| # | Question | Owner | Priority |
|---|---|---|---|
| 1 | Should Together Mode / Sleep Together require Tether Plus? | Product | High |
| 2 | What happens to encrypted data if a user's account is deleted — should we offer a "leave encrypted archive" option? | Engineering + Legal | High |
| 3 | How do we handle SOS if the user has no Family Circle? (Fallback to emergency contacts?) | Product | High |
| 4 | Should Relationship Advice Library content be human-curated permanently, or introduce AI-generated suggestions in v2? | Product | Medium |
| 5 | Consent model for Kid Mode — how does the child account get created, and who controls it? | Legal + Product | High |
| 6 | Should Tether allow voice/video calls directly, or always defer to system calling? | Engineering | Medium |
| 7 | Is there a moderation need for Family Circle content (e.g., uploaded Heritage Corner photos)? | Trust & Safety | Medium |
| 8 | How do we handle In-Law Circle conflicts where both a personal Family Circle and an In-Law Circle reference the same people? | Product | Low |
| 9 | Should One-Way Posts have a "are you sure?" second confirmation to prevent regret? | UX | Low |
| 10 | Should Mood-Adaptive UI be on by default, or opt-in? | UX | Low |

---

*This is a living document. Version history tracked in Git. Last updated: v1.0 initial.*

---

**Tether** · *Stay close. Stay calm. Your people. Your pace.*
