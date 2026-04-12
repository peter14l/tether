# ROADMAP.md - Tether

## Phase Structure

| Phase | Focus | Description | Dependencies |
|-------|-------|-------------|-------------|
| 1 | Foundation | Clean Architecture setup, Supabase Schema, Core Encryption | None |
| 2 | Circles & Feed | Circles, Feed, Time-Adaptive UI | 1 |
| 3 | Messaging | DMs, Voice Notes, Presence | 2 |
| 4 | Wellness | Mood Rooms, Check-In, Quiet Hours, Breathing Room | 2 |
| 5 | Couples | Couples features for Couple Circles | 2 |
| 6 | Family | Family features for Family Circles | 5 |
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

---

## Phase 2: Circles & Feed

### Goal
Core Circle management and chronological feed.

**Plans:** 5 plans in 2 waves

Plans:
- [x] 02-01-PLAN.md — Circles Domain & Data (Entities, Models, Supabase Repo)
- [x] 02-02-PLAN.md — Feed Domain & Data (Posts, Reactions, Supabase Repo)
- [x] 02-03-PLAN.md — Time-Adaptive UI Engine (Theme Slots, Tokens, Cubit)
- [x] 02-04-PLAN.md — Circle Management UI (CircleCubit, Screens, Creation)
- [x] 02-05-PLAN.md — Feed & Reactions UI (FeedCubit, Post Widgets, Reaction Bar)

---

## Phase 3: Messaging

### Goal
Direct messaging (DMs), Voice Notes, and Quiet Presence mode.

**Plans:** 3 plans in 3 waves

Plans:
- [x] 03-01-PLAN.md — Messaging & Presence Core (Domain & Data)
- [x] 03-02-PLAN.md — Messaging & Presence BLoCs
- [x] 03-03-PLAN.md — Messaging UI & Voice Recording

---

## Phase 4: Wellness

### Goal
Implement emotional wellness features: Mood Rooms, Encrypted Gratitude Journal, Reflection Wall, and Breathing Exercises.

**Plans:** 4 plans in 2 waves

Plans:
- [ ] 04-01-PLAN.md — Mood Room Feature (Domain, Data, Presentation, UI)
- [ ] 04-02-PLAN.md — Encrypted Gratitude Journal (Domain, Data, Presentation, UI)
- [ ] 04-03-PLAN.md — Reflection Wall & Breathing Room (Domain, Data, Presentation, UI)
- [ ] 04-04-PLAN.md — Mood-Adaptive UI Integration (Theme Engine, Avatar Ring)

---

## Phase 5: Couples

### Goal
Implement the "Our Bubble" private space for Couple circles with shared gallery, milestones, and real-time interactions.

**Plans:** 4 plans in 4 waves

Plans:
- [ ] 05-01-PLAN.md — Couples Foundation & Schema (Domain, Data Models, Migration)
- [ ] 05-02-PLAN.md — Couples Data Layer & Messaging Pause Integration
- [ ] 05-03-PLAN.md — Couples Presentation & Real-time Integration
- [ ] 05-04-PLAN.md — "Our Bubble" UI & Animations (Pulse, Ripple, Timeline, Gallery)

---

## Phase 6: Family

### Goal
Implement Family-specific features including Safety Checks, SOS Alerts, Heritage Corner, and Bedtime Stories.

**Plans:** 3 plans in 3 waves

Plans:
- [ ] 06-01-PLAN.md — Family Domain & Data Layers
- [ ] 06-02-PLAN.md — Family Presentation (BLoC/Cubit)
- [ ] 06-03-PLAN.md — Family UI (Dashboard, SOS, Heritage, Bedtime Stories)

### Features
- Family Circle features (FAM-01)
- Safety Check system (FAM-02)
- Emergency SOS (FAM-03)
- Heritage Corner & Generational Memories (FAM-04)
- Bedtime Stories (FAM-05)

### Dependencies
- Phase 2 (Circles & Feed)
- Phase 5 (Couples - for consistency/patterns)

### Success Criteria
- [ ] User in a Family circle can trigger an SOS
- [ ] User can respond to a safety check
- [ ] User can upload to Heritage Corner
- [ ] SOS alerts are broadcast real-time to the circle
- [ ] User can record and play back bedtime stories

---

## Phase 7-10: Extended

### Goal
Remaining extended features.

### Features
- Letter Mode
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
