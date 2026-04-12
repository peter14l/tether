# Architecture

**Analysis Date:** 2026-04-12

## Target Architecture (from PRD)

The Tether PRD (`TETHER_PRD.md`) specifies **Clean Architecture** as the target. This is the planned architecture that has not yet been implemented in the codebase.

## Planned Pattern: Clean Architecture

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
│  • Entities (User, Circle, Post, etc.)    │
│  • Use Cases (SendDigitalHug, CheckIn, etc)│
│  • Repository Interfaces (abstract)        │
│  • Failures (typed error classes)         │
└──────────────────┬──────────────────────────┘
                    │ implements
┌──────────────────▼──────────────────────────┐
│                DATA LAYER                   │
│  (Supabase, Local DB, Secure Storage)       │
│  • Repository Implementations              │
│  • Supabase Data Sources                   │
│  • Local Cache (Drift / Hive)              │
│  • DTO models + mappers                    │
│  • Client-side encryption service           │
└─────────────────────────────────────────────┘
```

**Key Principle:** Use Cases in the Domain layer know nothing about Supabase. If Supabase is swapped for Firebase, only the Data layer changes.

## Current Codebase State

**Actual Implementation:** Flat boilerplate only

- `lib/main.dart` - Single file (122 lines) containing entire app
- `lib/main.dart`: `MyApp` - StatelessWidget (root)
- `lib/main.dart`: `MyHomePage` - StatefulWidget (home screen with counter)
- No feature modules implemented

## State Management

**Target (from PRD):** Flutter BLoC (flutter_bloc package)
- Every feature has its own Bloc/Cubit
- Events → States pattern
- No business logic in widgets

**Current:** Built-in Flutter setState
- Simple counter example using `setState()`
- No external state management library

## Navigation

**Target:** Named routes with GoRouter or standard MaterialApp routing
- Routes defined per-feature in presentation layer

**Current:** None (single screen only)
- Standard MaterialApp with single home route

## Dependency Injection

**Target:** `get_it` + `injectable`
- Feature-level dependency containers
- Repository bindings in data layer

**Current:** None (no DI)

## Data Flow

**Target flow:**
1. Widget → dispatches Event to BLoC
2. BLoC → calls UseCase
3. UseCase (Domain) → calls Repository interface
4. Repository Implementation (Data) → calls DataSource
5. DataSource → Supabase/Local DB
6. Result flows back up through layers

**Current flow:**
- `MyHomePage._incrementCounter()` → directly mutates `_counter` via `setState()`
- No layers, no separation

## Layer Responsibilities (as specified in PRD)

### Domain Layer
- Pure Dart, no framework imports
- Entities: `User`, `Circle`, `Post`, `MoodRoom`, `CheckIn`, `DigitalHug`, etc.
- Use Cases: `SendDigitalHug`, `CheckIn`, `UpdateMoodRoom`, etc.
- Repository Interfaces (abstract classes)
- Failure classes: `ServerFailure`, `CacheFailure`, `AuthFailure`, etc.

### Data Layer
- Repository Implementations that implement Domain interfaces
- Supabase data sources
- Local cache (Drift or Hive)
- DTO models with JSON mapping
- Client-side AES-256 encryption service

### Presentation Layer
- Flutter widgets (Screens, Components)
- BLoC/Cubit state management
- Time-theme engine (color palettes by time of day)
- Never makes direct Supabase calls

## Architecture Maturity

**Level 0** - Greenfield starter, no architecture decisions made

The codebase is currently empty boilerplate. Clean Architecture must be implemented per the PRD specification.

## References

- Target architecture: `TETHER_PRD.md` Section 5
- State management: `TETHER_PRD.md` Section 5.3
- Dependency injection: `TETHER_PRD.md` Section 5.3

---

*Architecture analysis: 2026-04-12*