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
Initialize the core technical foundation including Clean Architecture scaffolding, Supabase database schema, and the E2E encryption system.

**Plans:** 4 plans

Plans:
- [ ] 01-01-PLAN.md — Scaffolding & Dependencies (Clean Arch, pubspec.yaml)
- [ ] 01-02-PLAN.md — Supabase Schema (SQL migration for 20+ tables)
- [ ] 01-03-PLAN.md — DI & Routing (GetIt, Injectable, GoRouter)
- [ ] 01-04-PLAN.md — E2E Encryption Core (AES-256, PIN-based recovery foundation)

### Features
- Clean Architecture folder structure
- Required dependencies (Supabase, BLoC, DI, Crypto)
- Supabase client initialization
- Full database schema (Profiles, Circles, Posts, etc.)
- E2E Encryption Service (AES-256-GCM)
- Cloud Escrow + PIN recovery foundation
- Dependency injection setup
- GoRouter navigation foundation

### Success Criteria
- [ ] Project folder structure matches PRD 5.2
- [ ] SQL migration file defines all PRD tables and RLS policies
- [ ] Dependency injection container is successfully generated
- [ ] App initializes with Supabase and GoRouter
- [ ] Encryption service passes basic verification

---

## Phase 2: Circles & Feed

### Goal
Core Circle management and chronological feed.

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
Direct messaging and voice notes.

### Features
- Direct messages between Circle members
- Voice notes recording
- Read receipts (opt-in)
- Quiet presence mode

### Dependencies
- Phase 2 (circles)

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
