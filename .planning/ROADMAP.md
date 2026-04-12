# ROADMAP.md - Tether

## Phase Structure

| Phase | Focus | Description | Dependencies |
|-------|-------|-------------|-------------|
| 1 | Foundation | Clean Architecture setup, Supabase Schema, Core Encryption | None |
| 2 | Circles & Feed | Circles, Feed, Time-Adaptive UI | 1 |
| 3 | Messaging | DMs, Voice Notes, Presence | 2 |
| 4 | Wellness | Mood Rooms, Check-In, Quiet Hours, Breathing Room | 2 |
| 5 | Couples | Couples features for Couple Circles | 2 |
| 6 | Family | Family features for Family Circles | 2 |
| 7-10 | Extended | Extended features (25+) | 1+ |

---

## Phase 1: Foundation

### Goal
Initialize the core technical foundation including full feature scaffolding, Supabase database schema (including messaging and escrow), and the E2E encryption system.

**Plans:** 4 plans in 3 waves

Plans:
- [x] 01-01-PLAN.md — Scaffolding & Dependencies (Clean Arch, 13 features, pubspec.yaml)
- [x] 01-02-PLAN.md — Supabase Schema (SQL migration for 20+ tables + messages/escrow)
- [x] 01-03-PLAN.md — DI & Routing (Final main.dart wiring: GetIt, GoRouter)
- [x] 01-04-PLAN.md — E2E Encryption Core (AES-256, PIN-based recovery foundation)

### Features
- Clean Architecture folder structure with all 13 feature directories (auth, circles, mood, journal, messaging, feed, memories, wellness, couples, family, vault, calendar, settings)
- Required dependencies (Supabase, BLoC, DI, Crypto)
- Supabase client initialization (Initial setup in Plan 02, final in Plan 03)
- Full database schema (Profiles, Circles, Posts, Messages, Escrow Keys, etc.)
- E2E Encryption Service (AES-256-GCM)
- Cloud Escrow + PIN recovery foundation
- Dependency injection setup
- GoRouter navigation foundation

**Wave Analysis:**
- Wave 1: 01-01
- Wave 2: 01-02, 01-04 (Depends on Wave 1)
- Wave 3: 01-03 (Depends on Wave 2)

### Success Criteria
- [x] Project folder structure matches PRD 5.2 including all 13 features
- [x] SQL migration file defines all PRD tables, messaging, and escrow keys
- [x] Dependency injection container is successfully generated
- [x] App initializes with Supabase and GoRouter in `main.dart`
- [x] Encryption service passes basic verification

---

## Phase 2: Circles & Feed

### Goal
Core Circle management and chronological feed.

**Plans:** 5 plans in 2 waves

Plans:
- [ ] 02-01-PLAN.md — Circles Domain & Data (Entities, Models, Supabase Repo)
- [ ] 02-02-PLAN.md — Feed Domain & Data (Posts, Reactions, Supabase Repo)
- [ ] 02-03-PLAN.md — Time-Adaptive UI Engine (Theme Slots, Tokens, Cubit)
- [ ] 02-04-PLAN.md — Circle Management UI (CircleCubit, Screens, Creation)
- [ ] 02-05-PLAN.md — Feed & Reactions UI (FeedCubit, Post Widgets, Reaction Bar)

### Features
- Create Friend Circle (2–20 members)
- Create Couple Circle (2 members only)
- Create Family Circle
- Invite members
- Circle feed (chronological)
- Post: text, images
- Gentle reactions: Warm, Comforting, I See You, Sending Strength
- Time-Adaptive UI engine
- Time slots: morning, afternoon, dusk, night

### Dependencies
- Phase 1 (foundation)

### Success Criteria
- [ ] User can create and manage Circles
- [ ] Feed shows posts chronologically
- [ ] Time theme changes with device clock

---

## Phase 3: Messaging

### Goal
Direct messaging (DMs), Voice Notes, and Quiet Presence mode.

**Plans:** 3 plans in 3 waves

Plans:
- [ ] 03-01-PLAN.md — Messaging & Presence Core (Domain & Data)
- [ ] 03-02-PLAN.md — Messaging & Presence BLoCs
- [ ] 03-03-PLAN.md — Messaging UI & Voice Recording

### Features
- Direct messages between Circle members (real-time)
- Voice notes recording & playback
- Read receipts (opt-in)
- Quiet presence mode (online/quiet)
- Slow Chat mode (voice-only)

### Dependencies
- Phase 2 (circles)

### Success Criteria
- [ ] User can send/receive real-time text DMs
- [ ] User can record and play back voice notes
- [ ] User can toggle Quiet presence mode
- [ ] Slow Chat mode restricts UI to voice only

---

## Phase 4: Wellness

### Goal
Emotional wellness features.

### Features
- Mood Rooms with status options
- One-tap Check-In
- Quiet Hours configuration
- Wind Down mode
- Breathing Room (4-7-8 pattern)
- Digital Hug

### Dependencies
- Phase 2 (circles)

---

## Phase 5: Couples

### Goal
Couples-specific features.

### Features
- Our Bubble (private space)
- Heartbeat Check
- Good Morning / Good Night messages
- Private Gallery (encrypted)
- Relationship Milestones

### Dependencies
- Phase 2 (circles)

---

## Phase 6: Family

### Goal
Family-specific features.

### Features
- Family Circle features
- Safety Check system
- Emergency SOS
- Location sharing (opt-in)
- Grandparent Easy View

### Dependencies
- Phase 2 (circles)

---

## Phase 7-10: Extended

### Goal
Remaining extended features.

### Features
- Letter Mode
- Reflection Wall (encrypted)
- Gratitude Journal
- Shared Playlists
- Memories Lane
- Temperature Check
- Gentle Reactions expansion
- + more (see FEATURE_IDEAS.md)

---

## Version Bumps

- **v1.0**: [1-5] Foundation + Core + Messaging (MVP)
- **v1.1**: [6-10] Wellness
- **v1.2**: [11-15] Couples
- **v1.3**: [16-20] Family
- **v1.4+**: [21-26+] Extended
