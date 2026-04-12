# Codebase Structure

**Analysis Date:** 2026-04-12

## Current Directory Layout

```
tether/
├── lib/
│   └── main.dart              # Single file, entire app (122 lines)
├── test/
│   └── widget_test.dart
├── pubspec.yaml              # Flutter project config
├── pubspec.lock
├── android/                 # Android native config
├── ios/                    # iOS native config
├── .dart_tool/
├── .idea/
├── README.md
└── TETHER_PRD.md           # Product Requirements Document
```

## Target Directory Layout (from PRD)

The PRD specifies this Clean Architecture folder structure:

```
lib/
├── core/
│   ├── theme/
│   │   ├── time_theme_engine.dart       # Time detection + token resolution
│   │   ├── theme_tokens.dart       # All color/typography tokens per slot
│   │   └── app_theme.dart         # ThemeData builder
│   ├── error/
│   │   └── failures.dart         # Typed failures
│   ├── usecase/
│   │   └── usecase.dart         # Base UseCase interface
│   ├── network/
│   │   └── network_info.dart
│   └── utils/
│       ├── encryption_service.dart # Client-side AES-256 encryption
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

## Directory Purposes

### Core Directory
- **Purpose:** Shared utilities, themes, and base classes used across features
- **Contains:** Theme engine, failure types, base usecase, encryption service, network info

### Features Directory
- **Purpose:** Each feature (auth, circles, mood, journal, etc.) is a self-contained module
- **Contains:** Domain, Data, and Presentation subdirectories per feature
- **Pattern:** Feature-first organization (vertical slices)

### Feature Module Structure
Each feature follows the same pattern:
```
feature_name/
├── domain/           # Pure Dart (entities, use cases, repository interfaces)
├── data/            # Implementations, data sources, models, DTOs
└── presentation/   # BLoCs, screens, widgets
```

## Naming Conventions

**Files:**
- Lowercase with underscores: `user_entity.dart`, `auth_bloc.dart`, `supabase_auth_datasource.dart`
- Screen files: `*_screen.dart` or `*_page.dart`
- Widget files: `*_widget.dart` or `*_card.dart`

**Directories:**
- Lowercase, plural for collections: `features/`, `usecases/`, `screens/`
- Feature directories: singular, lowercase: `circles/`, `mood/`, `journal/`

**Classes:**
- PascalCase: `AuthBloc`, `UserEntity`, `SendDigitalHugUseCase`
- Interfaces: `IAuthRepository` or `AuthRepository` (abstract)

## Where to Add New Code

### New Feature (e.g., "recipes")
1. Create `lib/features/recipes/` directory
2. Create subdirectories: `domain/`, `data/`, `presentation/`
3. Add entities in `domain/entities/`
4. Add use cases in `domain/usecases/`
5. Add repository interface in `domain/repositories/`
6. Add repository impl in `data/repositories/`
7. Add data sources in `data/datasources/`
8. Add models in `data/models/`
9. Add BLoC in `presentation/bloc/`
10. Add screens in `presentation/screens/`
11. Register dependencies in `injection_container.dart`

### New Screen Within Existing Feature
- Add to `lib/features/[feature]/presentation/screens/`

### New Use Case
- Add to `lib/features/[feature]/domain/usecases/`

### New Entity
- Add to `lib/features/[feature]/domain/entities/`

## Key File Locations

**Entry Points:**
- `lib/main.dart`: App entry point with MaterialApp setup
- `lib/injection_container.dart`: Dependency injection setup (to be created)

**Configuration:**
- `pubspec.yaml`: Flutter dependencies
- `lib/core/theme/`: Time-theme engine and tokens (to be created)

## Recommended Import Organization

```dart
// 1. Package imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 2. Core imports
import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/error/failures.dart';

// 3. Feature imports (domain first)
import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/auth/domain/usecases/get_current_user.dart';

// 4. Feature imports (presentation)
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
```

## Notes

- Current structure is flat (single `main.dart`)
- Target structure requires significant refactoring to implement
- Each feature should be self-contained for testability
- Core utilities shared across all features
- No feature modules currently exist in the codebase

---

*Structure analysis: 2026-04-12*