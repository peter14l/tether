# Tether — Output A: Fresh Install Onboarding
### Design Guidelines & Flutter Implementation Documentation

---

## Overview

This document specifies the complete onboarding experience for first-time Tether users. The onboarding should feel less like a tutorial and more like an **initiation into a sanctuary** — a deliberate, slow breath before the chaos of the rest of the internet. Every screen, animation, and word should communicate safety, intimacy, and intentionality.

---

## Design Language Reference

### Color Palette (Linen Ember System)

```
Background Primary:     #0D0A12   // Deep plum-black
Background Secondary:   #13101A   // Slightly lifted plum
Surface Elevated:       #1C1726   // Solid card / sheet surface — no transparency
Surface Muted:          #221D2E   // Slightly lighter solid surface for nested elements

Accent Sunset Orange:   #E8692A   // Primary CTA, active states
Accent Rose Violet:     #C2527A   // Secondary accent, mood tones
Accent Golden Amber:    #F0A832   // Warmth, highlights
Accent Soft Coral:      #E87B5A   // Mid-tone warmth

Text Primary:           #F5EDE0   // Warm off-white (Linen)
Text Secondary:         #A89880   // Muted warm grey
Text Tertiary:          #6B5F52   // Disabled / placeholder

Divider:                rgba(245, 237, 224, 0.08)
Border Subtle:          #2A2338   // Solid, not transparent — 1px borders on cards
```

> **No glassmorphism.** All card and surface backgrounds are **solid** elevated colors from the palette above. No `backdrop-filter`, no `rgba()` transparent backgrounds on UI surfaces. Depth is created through **layered solid colors** and subtle **drop shadows** using dark shadow tones only.

### Shadow Tokens (replacing glassmorphism depth)

```
shadow_sm:   BoxShadow(color: rgba(0,0,0,0.35), blurRadius: 8,  offset: Offset(0, 2))
shadow_md:   BoxShadow(color: rgba(0,0,0,0.45), blurRadius: 20, offset: Offset(0, 6))
shadow_lg:   BoxShadow(color: rgba(0,0,0,0.55), blurRadius: 40, offset: Offset(0, 12))
shadow_glow: BoxShadow(color: rgba(232,105,42,0.20), blurRadius: 32, offset: Offset(0, 0))
             // Used sparingly on primary CTAs only
```

### Typography

```
Display / Hero Font:    Cormorant Garamond Italic  — loaded via google_fonts package
Heading Font:           Cormorant Garamond SemiBold
Body Font:              DM Sans Regular / Medium
Caption / Label:        DM Sans Light, letter-spacing: 0.08em
```

**Loading fonts in Flutter:**
```dart
import 'package:google_fonts/google_fonts.dart';

// Display
GoogleFonts.cormorantGaramond(
  fontSize: 40,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.w600,
  color: Color(0xFFF5EDE0),
)

// Body
GoogleFonts.dmSans(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: Color(0xFFA89880),
  height: 1.7,
)
```

### Corner Radius (Squircle Tokens)

```
radius_sm:   12.0
radius_md:   20.0
radius_lg:   28.0
radius_xl:   40.0
radius_full: 9999.0  // pill shapes for CTAs
```

Use `BorderRadius.circular(value)` throughout. For true squircles, use the `smooth_corner` or `figma_squircle` package.

### Animation Tokens

```
duration_fast:    200ms
duration_medium:  380ms
duration_slow:    600ms
duration_breath:  4000ms (breathing pulse)
easing_smooth:    Curves.easeOutCubic
easing_spring:    Curves.elasticOut
easing_gentle:    Curves.easeInOutSine
```

---

## Onboarding Flow Architecture

### Screen Sequence

```
[0] Splash / Wordmark
      ↓
[1] Welcome: "Come Home"
      ↓
[2] What Is Tether?
      ↓
[3] Feature — Circles
      ↓
[4] Feature — Emotional Wellness
      ↓
[5] Feature — Couples
      ↓
[6] Feature — Family Bento
      ↓
[7] Privacy Promise
      ↓
[8] Get Started CTA
```

**Total:** 9 screens (1 splash + 7 content + 1 CTA)

**Navigation:** Horizontal `PageView` with `ClampingScrollPhysics`. Each screen (except Splash) has:
- `Skip` button — top right, DM Sans Medium 14sp, `#A89880`, no underline
- Persistent bottom progress bar + Continue button (described below)

### Persistent Bottom Bar (Screens 1–8)

```dart
// Fixed at bottom, background: Color(0xFF0D0A12), top border: Color(0xFF2A2338) 1px
// Height: 80px + SafeArea bottom padding

Row(
  children: [
    // Progress dots
    // Active: Container(width:24, height:8, color:#E8692A, borderRadius:4)
    // Inactive: Container(width:8, height:8, color:rgba(245,237,224,0.20), borderRadius:4)
    // Use AnimatedContainer for width transitions, duration: 300ms

    Spacer(),

    // Continue pill button
    // Background: LinearGradient([#E8692A, #F0A832], begin: left, end: right)
    // BorderRadius: 9999
    // Padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14)
    // Label: "Continue" — DM Sans Medium 15sp, color: #0D0A12
  ]
)
```

---

## Screen-by-Screen Specification

---

### Screen 0 — Splash / Wordmark

**Purpose:** Brand imprint. The first moment of calm.

**Background:** Solid `#0D0A12`. No other layers.

**Layout (all elements centered vertically and horizontally):**
- Tether wordmark: Cormorant Garamond Italic, 48sp, `#F5EDE0`
- Below wordmark (16px gap): tagline *"Come home to your circle."* — DM Sans Light, 16sp, `#A89880`, letter-spacing 0.12em
- Behind wordmark: a `RadialGradient` contained within a `Container` (not on the screen, on a fixed-size decoration box behind text), color: `rgba(232, 105, 42, 0.12)`, radius ~220px. This is purely decorative ambient warmth — it does not move.

**Animation Sequence:**
| Timestamp | Element | Animation |
|---|---|---|
| 0ms → 400ms | Background | Fade in from pure black |
| 300ms → 700ms | Wordmark | FadeTransition + SlideTransition (Y: +12px → 0) |
| 600ms → 900ms | Tagline | FadeTransition, delayed |
| 1000ms → 1200ms | Radial glow | Scale 0.85 → 1.0 → 0.95, one pulse |
| 2800ms | — | Auto-advance to Screen 1 (or tap anywhere to skip) |

**Flutter Implementation:**
```dart
// AnimationController with vsync
// Use Timer(Duration(milliseconds: 2800), () => _pageController.nextPage(...))
// On GestureDetector tap: cancel timer, advance immediately

// Glow box behind text:
Container(
  width: 220, height: 220,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(colors: [
      Color(0x1FE8692A), // rgba(232,105,42,0.12)
      Colors.transparent,
    ]),
  ),
)
```

---

### Screen 1 — Welcome: "Come Home"

**Purpose:** Establish the emotional contract — this is not another social app.

**Background:** Solid `#0D0A12`. One large ambient blob rendered as a blurred, non-interactive `Container` with `RadialGradient`:
- Color: `rgba(194, 82, 122, 0.18)` (Rose Violet bloom)
- Size: 400×400px
- Positioned: top-right, offset (-80px, -100px) using a `Stack`
- `ImageFilter.blur(sigmaX: 80, sigmaY: 80)` applied via `BackdropFilter` **on this specific decorative element only** (not on any UI card)

**Content layout (top → bottom, left-aligned, padding: 32px horizontal):**

1. **Headline block** (top third of screen):
   - Line 1: *"The internet is loud."* — Cormorant Garamond Italic, 40sp, `#F5EDE0`
   - Line 2: *"Tether is quiet."* — Cormorant Garamond Italic Bold, 44sp, `#E8692A`
   - 12px gap between lines

2. **Body copy** (mid section, 24px below headline):
   - DM Sans Regular, 15sp, `#A89880`, line-height 1.7, max-width: full screen minus 32px padding
   - *"Tether is a private sanctuary for the people who matter most — your close friends, your partner, your family. No algorithms. No likes. No noise."*

3. **Ambient Breathing Orb** (bottom section, centered):
   - A purely decorative animated orb — three nested `Container` widgets with `BoxDecoration(shape: BoxShape.circle)`
   - Outer ring: 96px, color `rgba(232, 105, 42, 0.10)`, solid fill
   - Middle ring: 64px, color `rgba(232, 105, 42, 0.20)`, solid fill
   - Core: 32px, color `#E8692A`, solid fill
   - All three scale together: 1.0 → 1.15 → 1.0, duration 4000ms, loop, `Curves.easeInOutSine`
   - Opacity oscillates simultaneously: 0.7 → 1.0 → 0.7

```dart
// AnimationController, repeat: true, duration: 4000ms
// ScaleTransition + FadeTransition on each Container
// Nested Stack for concentric rings
```

**Entrance animations (on screen appear):**
- Headline: FadeTransition + SlideTransition (Y: +16px → 0), 500ms, delay 0ms
- Body: FadeTransition, 500ms, delay 150ms
- Orb: FadeTransition, 600ms, delay 300ms

---

### Screen 2 — What Is Tether?

**Purpose:** Hard differentiation from every other social app. One screen, unmistakable.

**Background:** Solid `#0D0A12`. Amber blob (`rgba(240, 168, 50, 0.10)`) bottom-left, same blurred Container treatment as Screen 1.

**Content:**
- Headline: *"Not social media."* — Cormorant Garamond Italic, 36sp, `#F5EDE0`
- Sub-headline: *"A digital sanctuary."* — Cormorant Garamond Italic, 36sp, `#E8692A`
- Divider: `Divider(thickness: 1, color: Color(0x1FF5EDE0), indent: 0, endIndent: screenWidth - 48)`
- 20px gap below divider

**Contrast Grid — 3 rows:**

Each row is a `Container`:
- Background: `#1C1726` (solid elevated surface)
- Border: `Border.all(color: Color(0xFF2A2338), width: 1)`
- BorderRadius: `radius_md` (20px)
- Padding: `EdgeInsets.symmetric(horizontal: 16, vertical: 14)`
- `BoxShadow`: `shadow_sm`
- Layout: `Row` with two cells separated by a thin `VerticalDivider`

```
Left cell (❌ side):
  Icon(Icons.close_rounded, color: #C2527A, size: 16)
  SizedBox(width: 8)
  Text — DM Sans Regular, 14sp, #A89880

Right cell (✅ side):
  Icon(Icons.check_rounded, color: #E8692A, size: 16)
  SizedBox(width: 8)
  Text — DM Sans Medium, 14sp, #F5EDE0
```

| Left | Right |
|---|---|
| Algorithmic feeds | Chronological truth |
| Follower counts | Intimate circles |
| Likes & metrics | Pure connection |

**Entrance animations:** Rows stagger in — each row slides from Y+20px, opacity 0 → 1, duration 400ms, stagger delay 120ms between rows.

---

### Screen 3 — Feature: Circles

**Purpose:** Explain the core privacy model.

**Background:** Solid `#0D0A12`.

**Top illustration zone (upper 45% of screen):**

A `CustomPainter`-based illustration of three overlapping rings:
- Ring 1 ("Partner"): `#C2527A`, strokeWidth 2, diameter 120px
- Ring 2 ("Best Friends"): `#E8692A`, strokeWidth 2, diameter 180px
- Ring 3 ("Family"): `#F0A832`, strokeWidth 1.5, diameter 240px
- Rings overlap organically — not perfectly centered, offset by ±20px
- Each ring has a small label `Text` inside it: DM Sans Light 11sp, matching ring color
- Parallax: on `DeviceOrientationListener`, rings shift ±4px on tilt (X and Y), 3 different parallax depths (0.4, 0.7, 1.0 multipliers) for a subtle 3D effect
- Rings have a very gentle independent rotation: `AnimationController(duration: 20s)`, each ring rotates at a different speed (0.5°/s, 0.3°/s, 0.2°/s) — barely perceptible

**Content zone (lower 55%):**
- Headline: *"Your world, in circles."* — Cormorant Garamond Italic, 36sp, `#F5EDE0`
- Body: *"Share with exactly the right people. A post to your 'Best Friends' circle stays there. No oversharing. No context collapse. Just intentional closeness."* — DM Sans 15sp, `#A89880`, line-height 1.7

**Feature Bullets (3 items):**
Each bullet: `Row` with a `Container(width: 2, height: 36, color: rgba(232,105,42,0.4))` left accent bar, then icon + text:
```
🔒  Private micro-networks
📅  Strictly chronological — no AI curation
👁  You control who sees everything
```
Icon: 18sp, `#E8692A`. Text: DM Sans Medium 14sp, `#A89880`. Gap between bullets: 12px.

---

### Screen 4 — Feature: Emotional Wellness

**Purpose:** Introduce the mood system and the breathing tool.

**Background:** Solid `#0D0A12`. Rose violet ambient blob, top-right.

**Top zone (55% of screen) — two visual elements:**

**A. Mood Orb Row (horizontally scrollable):**
Five mood orbs in a `SingleChildScrollView(scrollDirection: Axis.horizontal)`:

| Label | Color | Size |
|---|---|---|
| 😌 Calm | `#7EB8D4` | 72×72px |
| 😊 Happy | `#F0A832` | 72×72px |
| 😐 Okay | `#A89880` | 72×72px |
| 😔 Low | `#C2527A` | 72×72px |
| 😤 Stressed | `#E87B5A` | 72×72px |

Each orb: `Container` with `BoxDecoration(shape: BoxShape.circle, color: <color>)`. Label below: DM Sans Light, 11sp, matching color. The "active" orb (default: Calm) is scaled 1.12, others 1.0. Tapping an orb animates its scale with a spring curve.

**B. Breathing Orb (below mood row, centered):**
Three nested circles — same structure as Screen 1's ambient orb but with added text label:
- Outer: 120px, `rgba(232, 105, 42, 0.08)` solid equivalent → `Color(0x14E8692A)`
- Middle: 80px, `Color(0x33E8692A)`
- Core: 32px, `Color(0xFFE8692A)`
- All pulse: scale 1.0 → 1.22 → 1.0, duration 4000ms, loop, `easeInOutSine`
- Below orb: `AnimatedSwitcher` cycling through text labels:
  - *"Breathe in..."* (shown 2000ms)
  - *"Hold..."* (shown 800ms)
  - *"Breathe out..."* (shown 2000ms)
  - DM Sans Light, 13sp, `#A89880`, centered

**Bottom zone (45%):**
- Headline: *"Your feelings live here too."* — Cormorant Garamond Italic, 34sp
- Body: *"Log your emotional state and share your vibe with your circles — on your terms. Friends can show up for you without you having to explain yourself."* — DM Sans 15sp, `#A89880`

---

### Screen 5 — Feature: Couples Module

**Purpose:** Showcase the private partner space.

**Background:** Solid `#0D0A12`.

**Top illustration (centered, upper 40%):**
Two interlocking ring shapes built with `CustomPainter`:
- Left ring: `#E8692A`, diameter 140px, strokeWidth 2
- Right ring: `#C2527A`, diameter 140px, strokeWidth 2
- Rings offset by 60px horizontally so they overlap at center
- Counter-rotation animation: left ring +1°/s, right ring -0.8°/s — very slow, looping
- At the intersection: a small solid ellipse, color `#E87B5A` (blend of the two), 40×40px

**Content:**
- Headline: *"A space for just the two of you."* — Cormorant Garamond Italic, 36sp
- Body: *"A fully private, encrypted world built for couples. Share milestones, plan your future together, and go deeper than day-to-day logistics."* — DM Sans 15sp, `#A89880`

**Two feature cards (horizontal `Row`, equal width):**

Each card:
- Background: `#1C1726` (solid elevated surface)
- Border: `1px solid #2A2338`
- BorderRadius: `radius_lg` (28px)
- Padding: 20px
- `BoxShadow`: `shadow_md`

```
Card 1:  [Icon: calendar_today, color: #E8692A]
         "Shared Calendar"
         DM Sans SemiBold 14sp, #F5EDE0
         "Plan life, celebrate history."
         DM Sans 13sp, #A89880

Card 2:  [Icon: lock_outline, color: #E8692A]
         "Private Vault"
         DM Sans SemiBold 14sp, #F5EDE0
         "Encrypted. Only yours."
         DM Sans 13sp, #A89880
```

---

### Screen 6 — Feature: Family Bento

**Purpose:** Show the visual richness of the Family module.

**Background:** Solid `#0D0A12`. Amber blob, bottom-center.

**Bento Grid Illustration (upper 50%):**
A non-interactive preview grid using Flutter's `GridView` or manual `Column`/`Row` layout:

```
┌────────────────────┬──────────┐
│   📸 Shared        │  🏆 Win  │
│   Memories         │          │
├──────────┬─────────────────────┤
│  ✅ Check │  🎙️ Voice Note     │
│  In      │                    │
└──────────┴────────────────────┘
```

Each cell:
- Background: `#1C1726` with a unique left-border accent:
  - Memories: `border-left: 3px solid #E8692A`
  - Win: `border-left: 3px solid #F0A832`
  - Check-in: `border-left: 3px solid #C2527A`
  - Voice: `border-left: 3px solid #E87B5A`
- Border: `1px solid #2A2338`
- BorderRadius: `radius_md`
- Padding: 14px
- Icon: 24sp, matching accent color
- Label: DM Sans SemiBold 13sp, `#F5EDE0`

**Entrance animation:** Each cell pops in from scale 0.85 → 1.0, opacity 0 → 1, 80ms stagger between cells.

**Content:**
- Headline: *"Family life, beautifully organised."* — Cormorant Garamond Italic, 34sp
- Body: *"The Family Bento brings your family's whole world into one modular, living dashboard. Memories, voices, check-ins — all in one beautiful place."* — DM Sans 15sp, `#A89880`

---

### Screen 7 — Privacy Promise

**Purpose:** Build trust. Manifesto tone. Most editorial screen in the onboarding.

**Background:** Solid `#13101A` (slightly different surface to signal a tonal shift).

**Design direction:** More minimalist, text-forward, fewer decorative elements. This screen earns its sobriety.

**Content:**
- Headline (2 lines): *"Your data is not our product."* — Cormorant Garamond Italic, 38sp, `#F5EDE0`, left-aligned
- Thin accent line: `Container(height: 1, width: 64, color: rgba(232,105,42,0.6))`, margin bottom 24px

**4 promise items (stacked list):**

Each item: `Row`, padding: `EdgeInsets.symmetric(vertical: 14)`, separated by `Divider(color: Color(0xFF2A2338))`:

```
[Icon — 24sp, #E8692A]   [Column]
                            [Title — DM Sans SemiBold 15sp, #F5EDE0]
                            [Body  — DM Sans 13sp, #A89880]

Item 1: lock_outline      "Row Level Security"
                          "Your data is protected at the database level."

Item 2: block             "No Third-Party Trackers"
                          "No pixels. No shadow profiles. Ever."

Item 3: money_off         "No Ads. Ever."
                          "We earn from subscriptions — not from selling you."

Item 4: code              "Clean Architecture"
                          "Built to be auditable and trustworthy by design."
```

**Entrance animation:** Items slide in from X+16px, opacity 0 → 1, 100ms stagger between items.

---

### Screen 8 — Get Started CTA

**Purpose:** Conversion. The moment of commitment.

**Background:** Solid `#0D0A12` with two ambient decorative blobs:
- Blob 1: `rgba(232, 105, 42, 0.14)` — top-center
- Blob 2: `rgba(194, 82, 122, 0.12)` — bottom-left

Both blobs: pure `RadialGradient` inside fixed-size `Container` + `ImageFilter.blur` on the blob Container itself (not any UI surface).

**Content (centered, padding: 32px):**
- Headline: *"Ready to come home?"* — Cormorant Garamond Italic, 42sp, `#F5EDE0`, centered
- Sub-copy: *"Tether is free to start. No algorithms. No ads. Just the people you love."* — DM Sans 15sp, `#A89880`, centered, line-height 1.7

**Primary CTA:**
```dart
// Full-width pill button
Container(
  width: double.infinity,
  height: 56,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(9999),
    gradient: LinearGradient(
      colors: [Color(0xFFE8692A), Color(0xFFF0A832)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    boxShadow: [BoxShadow(
      color: Color(0x33E8692A),
      blurRadius: 32,
      offset: Offset(0, 8),
    )],
  ),
  child: Text("Create My Circle", style: GoogleFonts.dmSans(
    fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0D0A12),
  )),
)

// On press: GestureDetector with onTapDown → scale 0.97, onTapUp → scale 1.0
// HapticFeedback.mediumImpact() on tap
```

**Secondary CTA:**
```dart
TextButton(
  onPressed: () => navigateToSignIn(),
  child: RichText(text: TextSpan(children: [
    TextSpan(text: "I already have an account — ", style: dmSans(14, #A89880)),
    TextSpan(text: "Sign In", style: dmSans(14, #E8692A, underline: true)),
  ])),
)
```

**Bottom safe area:**
```dart
SizedBox(height: MediaQuery.of(context).padding.bottom + 32)
```

---

## Flutter Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  flutter_animate: ^4.3.0        # Declarative animation chaining
  smooth_page_indicator: ^1.1.0  # Progress dots
  sensors_plus: ^4.0.0           # Device tilt for Circles parallax
  lottie: ^3.0.0                 # Optional: for Lottie micro-animations
```

## Global Flutter Notes

- All screens live inside a `PageView.builder` with `ClampingScrollPhysics`
- Use a `Stack` as the root of each screen: background blobs as bottom layer, content above
- All screens share the persistent bottom bar via a parent `Scaffold` with a custom `bottomNavigationBar`
- `SafeArea` applied at the `Scaffold` level, `useSafeArea: true`
- Test all text contrast ratios: minimum 4.5:1 body text, 3:1 large display text
- Minimum touch targets: 48×48dp for all interactive elements

---

*Tether Output A — Fresh Install Onboarding v1.0*
