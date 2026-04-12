# STACK - Technology Stack

## Core Framework
- **Flutter** - Mobile UI (iOS & Android)
- **Dart** - SDK ^3.11.4

## Backend: Supabase
- **Auth** - Email/password, magic link, Google OAuth
- **Database** - PostgreSQL (30+ tables)
- **Storage** - Media files
- **Realtime** - Live updates
- **Edge Functions** - Scheduled tasks

## Flutter Dependencies (To Add)
| Package | Purpose |
|---------|---------|
| flutter_bloc | State management |
| get_it | DI |
| injectable | Code gen for DI |
| supabase_flutter | Supabase client |
| flutter_secure_storage | Session storage |
| drift or hive | Local cache |
| uuid | UUIDs |
| intl | i18n |
| cached_network_image | Image caching |

## Architecture: Clean Architecture
```
lib/
├── core/ (theme, error, usecase, utils)
├── features/ (auth, circles, mood, journal, messaging, feed, memories, wellness, couples, family, vault, calendar, settings)
├── injection_container.dart
└── main.dart
```

## Features (75+)
- Mood Rooms, Quiet Hours, Gratitude Journal, Voice Notes, Shared Playlists, Memories Lane, Check-In, Breathing Exercises, Safe Space Lock, Temperature Check, Digital Hug, Breathing Room, Sunset Mode, Letter Mode, Reflection Wall, Presence, Shared Calendar
- Couples: Our Bubble, Love Languages, Milestones, Good Morning/Good Night, Together Mode, Heartbeat Check, Date Planner, Private Gallery, Promise Rings, Space to Breathe, Our Song, Favor Coupons
- Family: Family Circle, Safety Check, Kid Mode, Grandparent Easy View, Family Feed, Location Family, Emergency SOS, Heritage Corner, Bedtime Stories