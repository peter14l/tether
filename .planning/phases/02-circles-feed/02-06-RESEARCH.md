# Phase 02: Aesthetic Refinement - Research

**Researched:** 2026-04-13
**Domain:** UI/UX, Flutter Theme Engine, Aesthetic Component Design
**Confidence:** HIGH

## Summary

The current UI implementation follows a basic Material 3 structure but lacks the sophisticated, time-based "glow" aesthetic and motion philosophy defined in the PRD. The research focused on identifying how to implement these multi-layered shadows ("border glows"), standardizing global theme tokens, and identifying common UI components that require refinement.

**Primary recommendation:** Centralize all component styling in `AppTheme.dart` and `ThemeTokens.dart`, and create a small set of "Aesthetic Primitive" widgets (`TetherCard`, `TetherButton`, `SlowPhoto`) that implement the PRD's specific visual requirements (multi-layered shadows, smooth transitions, and inset glows) which cannot be easily achieved through standard `ThemeData` properties alone.

## User Constraints

> No CONTEXT.md was found for this phase. Research is based on the project instructions and the PRD.

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Flutter SDK | 3.41.6 | UI Framework | Project core [VERIFIED: flutter --version] |
| Google Fonts | 6.3.3 | Typography | Provides Playfair Display, Lora, and DM Sans [VERIFIED: pubspec.lock] |
| Flutter BLoC | 8.1.6 | State Management | Standard for feature state and theme switching [VERIFIED: pubspec.lock] |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Go Router | 14.8.1 | Navigation | App-wide screen transitions [VERIFIED: pubspec.lock] |
| Supabase Flutter | 2.12.2 | Backend | Real-time updates and storage [VERIFIED: pubspec.lock] |

**Installation:**
```bash
# Existing packages are sufficient; no new installs recommended for this phase.
# If inset shadows become too complex, consider 'flutter_inset_box_shadow'.
```

## Architecture Patterns

### Recommended Project Structure
```
lib/
├── core/
│   ├── theme/
│   │   ├── theme_tokens.dart       # ADD: glowShadows, textOnAccent
│   │   └── app_theme.dart          # UPDATE: buttonTheme, inputDecorationTheme
│   └── widgets/                    # NEW: Aesthetic Primitives
│       ├── tether_card.dart        # Handles dusk-specific inner glows
│       ├── tether_button.dart      # Multi-layered glow button base
│       └── slow_photo.dart         # 600ms ease-in opacity transition
```

### Pattern 1: Token-Driven Shadow Stacking
To achieve the "glow" look, we must stack multiple `BoxShadow` objects. Standard `elevation` only supports a single shadow.
**What:** Define `List<BoxShadow>` in `ThemeTokens`.
**When to use:** Primary buttons and elevated cards during Dusk/Night.

### Pattern 2: Component-First Styling
Instead of `ElevatedButton.styleFrom` in every screen, use `ElevatedButtonThemeData` in `AppTheme` to set the base 14px radius and 16/28 padding globally.

### Anti-Patterns to Avoid
- **Hardcoded Styles:** Avoid `BorderRadius.circular(14)` in individual screen files.
- **Jarring Image Loads:** Avoid raw `Image.network` without the 600ms fade-in transition (Feature 25).
- **Static Shadows:** Shadows should interpolate or change when the `TimeSlot` changes.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Inset Shadows | Complex Canvas math | `flutter_inset_box_shadow` (if needed) or Gradient/Border | Edge cases with clip paths and performance. |
| Typography | Custom `TextStyle` in every widget | `Theme.of(context).textTheme` | Centralized scaling and family management. |
| Motion Easing | Custom Bezier math | `Curves.easeOutCubic` / `Curves.easeOutQuart` | Built-in curves match PRD specs (Section 4.5). |

## Common Pitfalls

### Pitfall 1: Shadow Performance
**What goes wrong:** Excessive Gaussian blurs (shadows) on many items in a list can drop frame rates.
**How to avoid:** Use `RepaintBoundary` on complex cards and keep shadow layers to ≤ 3.

### Pitfall 2: Accessibility Blindness
**What goes wrong:** Icon-only buttons (common in this app) lack semantics, making it impossible for screen readers.
**How to avoid:** Always wrap `IconButton` with `Tooltip` and provide `semanticsLabel`.

### Pitfall 3: Dark Mode Contrast
**What goes wrong:** Borders that look good in Morning (light) might become invisible or too harsh in Night (dark).
**How to avoid:** Use the `borderDefault` and `borderGlowColor` from `ThemeTokens` which are already tuned for contrast.

## Code Examples

### Multi-Layered Glow Implementation
```dart
// Suggested implementation in ThemeTokens
static List<BoxShadow> duskButtonGlow = [
  BoxShadow(
    color: Color(0x99FF7B3A), // 60% opacity
    blurRadius: 16,
    offset: Offset(0, 0),
  ),
  BoxShadow(
    color: Color(0x40FF7B3A), // 25% opacity
    blurRadius: 40,
    offset: Offset(0, 0),
  ),
  BoxShadow(
    color: Color(0x26C45BAA), // 15% opacity rose violet
    blurRadius: 80,
    offset: Offset(0, 0),
  ),
];
```

### Slow Photo Fade-In (Feature 25)
```dart
// Use Image.network with frameBuilder for the 600ms fade
Image.network(
  url,
  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) return child;
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeIn,
      child: child,
    );
  },
);
```

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | `flutter_inset_box_shadow` is acceptable if needed. | Don't Hand-Roll | Minimal, but adds a dependency. |
| A2 | Performance on target devices is high enough for 3-layer shadows. | Common Pitfalls | Might require optimization for older Android devices. |

## Open Questions

1. **Should we use a package for inset shadows?** 
   - Recommendation: Start with a `Border` + `Gradient` approach for the top-edge inner glow on cards (Dusk only). Only add a package if complex inner shadows are needed for other components.
2. **How to handle "Hover" state on mobile?** 
   - Recommendation: Treat "Long Press" or "Active" state as the trigger for "Glow Intensify" as specified in PRD Section 4.5.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Flutter | Framework | ✓ | 3.41.6 | — |
| Dart | Runtime | ✓ | 3.11.4 | — |
| Google Fonts | Typography | ✓ | 6.3.3 | — |

## Security Domain

### Applicable ASVS Categories
| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V5 Input Validation | yes | Standard `TextFormField` validation logic. |

## Sources

### Primary (HIGH confidence)
- `TETHER_PRD.md` - Section 4.4 Component Styling, 4.5 Motion.
- `lib/core/theme/theme_tokens.dart` - Existing token implementation.
- `lib/core/theme/app_theme.dart` - Existing theme implementation.
- `pubspec.lock` - Verified library versions.

### Secondary (MEDIUM confidence)
- Google Search - "flutter multi layered boxshadow implementation best practices".

## Metadata
**Confidence breakdown:**
- Standard stack: HIGH - Verified via local commands.
- Architecture: HIGH - Aligns with PRD and Clean Architecture.
- Pitfalls: MEDIUM - Based on common Flutter performance patterns.

**Research date:** 2026-04-13
**Valid until:** 2026-05-13
