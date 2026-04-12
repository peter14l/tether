# PROJECT.md - Tether

**Version:** 1.0 · **Status:** In Progress · **Classification:** Internal

> *"Stay close. Stay calm. Your people. Your pace."*

---

## 1. Product Overview

**Tether** is an emotional-safety-first social connection app for close relationships — friends, couples, and families. It is explicitly NOT a social media platform. It has no public feeds, no follower counts, no algorithmic ranking, and no ads.

Tether is the antidote to digital anxiety. Every design decision, feature, and interaction is evaluated against one question: *does this make the user feel safer, calmer, and more connected?*

---

## 2. Core Attributes

| Attribute | Value |
|-----------|-------|
| App Name | Tether |
| Platforms | iOS & Android (Flutter) |
| Backend | Supabase (PostgreSQL + Auth + Storage + Realtime + Edge Functions) |
| Primary Language | Dart (Flutter) |
| Architecture | Clean Architecture (Domain / Data / Presentation) |

---

## 3. Vision & Philosophy

### Core Vision
> *"A safe space away from the busy noise of the world. Users should feel safe, emotionally secure, and comfortable. Something they can ease and relax in and connect with friends."*

### Design Principles

1. **Calm by Default** - Every screen, animation, and notification is designed to reduce anxiety
2. **Intimacy Over Scale** - Built for 5 people who truly matter, not mass audiences
3. **No Pressure Architecture** - Read receipts opt-in, "Quiet" mode for online status
4. **Time-Aware Comfort** - App colors shift with time of day
5. **Anti-Gamification** - No streaks, no leaderboards, no counts that shame
6. **People-First Privacy** - Client-side encryption for sensitive data

---

## 4. Target Audience

| Segment | Description | Core Need |
|---------|------------|----------|
| Close Friend Groups | Ages 16–30, tight-knit circles of 3–10 | Low-pressure hangout |
| Couples | Any age | Intimacy tools, private spaces |
| Family Units | Parents, children, grandparents | Safety, togetherness |
| Anxious/Burnt-out | Any age | Slower, quieter alternative |

**Anti-Audience:** Public content creators, brands, large social networks, TikTok/Instagram seekers

---

## 5. Features Summary

**75+ Features planned:**

- **General Wellness (1-25):** Mood Rooms, Quiet Hours, Gratitude Journal, Voice Notes, Shared Playlists, Memories Lane, Check-In, No-Likes, Breathing Exercises, Safe Space Lock, Temperature Check, Soft Block, Comfort Radius, Gentle Reactions, Digital Hug, Breathing Room, Sunset Mode, No-Algorithm Promise, Letter Mode, Reflection Wall, Presence, Kindness Streaks, Shared Calendar, Slow Photo

- **Couples (26-35, 46-55):** Our Bubble, Love Languages Tracker, Relationship Milestones, Good Morning/Good Night, Together Mode, Heartbeat Check, Date Planner, Private Gallery, Promise Rings, Space to Breathe, Our Song, Favor Coupons, Sleep Together, Mood Sync, Private Jokes Vault, Future Letter, Distance Mode, Little Surprises, Anniversary Countdown

- **Family (36-45, 56-65):** Family Circle, Safety Check, Kid Mode, Grandparent Easy View, Family Feed, Location Family, Reminder Board, Heritage Corner, Emergency SOS, Generational Memories, Chore Chart, Prayer Time, Bedtime Stories, Family Rituals, Homework Help, Family Pet Corner, In-Law Circle, Sibling Bond, Family Reunion

- **Extended (66-75):** Anonymous Venting, One-Way Post, Soft Delete, Accessibility, Mood-Adaptive UI, Gentle Nudge, Once Upon a Time, Whisper Mode, Mirror Mode, Gentle Gamification

---

## 6. Technology Stack

### Frontend
- Flutter (iOS & Android)
- Dart SDK ^3.11.4
- flutter_bloc (state management)
- get_it + injectable (DI)

### Backend
- Supabase Auth (email/password, magic link, OAuth)
- Supabase Database (PostgreSQL, 30+ tables)
- Supabase Storage (media buckets)
- Supabase Realtime (live updates)
- Edge Functions (scheduled tasks)

### Design System
- Time-Adaptive Color Palettes (morning/afternoon/dusk/night)
- Typography: Playfair Display, Lora, DM Sans
- Spacing: 4dp base unit

---

## 7. Architecture

**Clean Architecture (strict):**

```
PRESENTATION → (Flutter Widgets, BLoC)
    ↑ calls
DOMAIN → (Entities, Use Cases, Repository Interfaces, Failures)
    ↑ implements
DATA → (Supabase, Local DB, Storage, DTOs)
```

**Key Principle:** Domain layer knows nothing about Supabase

---

## 8. References

- `/TETHER_PRD.md` - Full product requirements
- `/FEATURE_IDEAS.md` - Feature brainstorm
- `.planning/codebase/STACK.md` - Tech details
- `.planning/codebase/ARCHITECTURE.md` - System design
- `.planning/codebase/CONCERNS.md` - Known issues