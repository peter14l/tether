# Tether — Output B: In-App Feature Onboarding
### Screen-by-Screen Contextual Walkthrough Documentation

---

## Overview

This document covers the **contextual onboarding overlays** that appear the **first time a user navigates to each major screen** within the app. These are not blocking modals — they use a layered **spotlight / coach mark** approach that highlights one component at a time and explains its purpose in Tether's voice.

Once a user has completed or dismissed the walkthrough for a screen, it never appears again (store completion state in Supabase user preferences or local SharedPreferences).

---

## Global Overlay Specification

### Visual Structure

```
Root: Stack
  └── Screen content (underneath, still visible)
  └── Overlay layer
        └── Dark scrim (semi-transparent, except spotlight cutout)
        └── Spotlight cutout (transparent, squircle-shaped, matching highlighted widget)
        └── Tooltip card (positioned above or below spotlight)
        └── Navigation controls (Next / Skip)
```

### Scrim

```
Color:            rgba(13, 10, 18, 0.82)   // Color(0xD10D0A12)
Applied via:      ColorFiltered or a custom painter with a "hole" punched out
Transition:       FadeTransition, duration 300ms, on step change
```

### Spotlight Cutout

Rendered as a `CustomPainter` that fills the canvas with the scrim color and subtracts the spotlight shape using `BlendMode.clear`. The spotlight shape mirrors the targeted widget's bounding box with a `radius_md` (20px) squircle shape and 8px padding on all sides.

Spotlight transitions between steps: animated via `TweenAnimationBuilder` on `Rect`, duration 380ms, `Curves.easeOutCubic`.

### Tooltip Card

```
Background:       #1C1726  (solid elevated surface — no transparency)
Border:           1px solid #2A2338
BorderRadius:     radius_lg (28px)
Padding:          20px all sides
BoxShadow:        shadow_lg (0 12px 40px rgba(0,0,0,0.55))
MaxWidth:         screen width - 48px
Position:         auto-positioned above or below spotlight, 12px gap,
                  clamped to screen edges with 24px margin
```

**Tooltip content layout:**
```
Row (top):
  [Step indicator — DM Sans Light 11sp, #6B5F52, e.g. "2 of 5"]
  Spacer
  [Skip button — DM Sans Medium 13sp, #A89880, "Skip Tour"]

Gap: 10px

[Title — DM Sans SemiBold 15sp, #F5EDE0]
[Gap: 6px]
[Body — DM Sans Regular 14sp, #A89880, lineHeight 1.6]

Gap: 16px

[Next button — right-aligned, DM Sans Medium 14sp, #E8692A, "Next →"]
  (Last step: "Got it ✓" — same style)
```

### Completion Toast

After the final step, the overlay fades out and a bottom toast appears:

```
Container:
  Background: #1C1726
  Border:     1px solid #2A2338
  BorderRadius: radius_full (pill)
  Padding:    EdgeInsets.symmetric(horizontal: 20, vertical: 12)
  BoxShadow:  shadow_md

Content: Row
  [Icon: check_circle_outline, color: #E8692A, size: 16]
  [Gap: 8px]
  [Text: "You're all set. Tap anything to explore." — DM Sans 14sp, #F5EDE0]

Animation: slides up from bottom + fade, auto-dismisses after 2500ms
```

---

## Screen 1 — Home / Feed Screen

**Screen purpose:** The chronological feed of all content shared across the user's Circles.

---

**Step 1 of 5 — The Feed**
- Spotlight: The main scrollable `ListView` feed area (full width, below filter bar)
- Title: "Your Feed"
- Body: *"Everything your Circles have shared, in the exact order it happened. No algorithm reranks it. No AI decides what you see. Just real, chronological life."*

**Step 2 of 5 — Circle Filter Bar**
- Spotlight: The horizontal chip/tab row at the top (All / Friends / Family / Partner chips)
- Title: "Filter by Circle"
- Body: *"Tap a Circle name to see only what's shared within that group. Your different worlds stay naturally separate."*

**Step 3 of 5 — Post Card**
- Spotlight: A single full post card in the feed
- Title: "A Post"
- Body: *"Each post shows who shared it, when, and to which Circle — and nothing else. No like count. No share count. Content and context, that's it."*

**Step 4 of 5 — Reactions**
- Spotlight: The reaction row at the bottom of the post card
- Title: "React with Words"
- Body: *"Tap to react with a real word — not a number. Your reaction lands inside the conversation, not as a metric on the post."*

**Step 5 of 5 — Compose Button**
- Spotlight: The floating action button (bottom-right)
- Title: "Share Something"
- Body: *"Tap here to post. Choose your Circle, pick your format — text, photo, voice note — and share. Only the people in your chosen Circle will ever see it."*

---

## Screen 2 — Circles Management Screen

**Screen purpose:** View, create, and manage all Circles.

---

**Step 1 of 5 — The Circle List**
- Spotlight: The full list of Circle cards
- Title: "Your Circles"
- Body: *"Each Circle is a private micro-network. What's shared inside one Circle never leaks to another. You architect your own social world."*

**Step 2 of 5 — Create a Circle**
- Spotlight: The "+" or "New Circle" button
- Title: "Start a New Circle"
- Body: *"Create a Circle for any context in your life — a group trip, a support system, a creative project. Give it a name and invite exactly the right people."*

**Step 3 of 5 — Circle Card**
- Spotlight: One Circle card (showing member avatars, name, and last activity timestamp)
- Title: "Circle at a Glance"
- Body: *"See who's in each Circle and when they last shared. Tap to enter that Circle's dedicated feed."*

**Step 4 of 5 — Member Avatars**
- Spotlight: The member avatar row inside a Circle detail view
- Title: "Circle Members"
- Body: *"Add or remove people at any time. Your guest list can evolve as life does — no awkward unfollows, no public announcements."*

**Step 5 of 5 — Circle Settings**
- Spotlight: The settings / kebab icon on a Circle card
- Title: "Circle Controls"
- Body: *"Rename the Circle, set a cover image, adjust notifications, or archive it. Full control, always yours."*

---

## Screen 3 — Compose / Post Creation Screen

**Screen purpose:** Create and share a new post to one or more Circles.

---

**Step 1 of 5 — Content Input**
- Spotlight: The main text input area
- Title: "What Would You Like to Share?"
- Body: *"Type freely — this is a judgment-free, private space. You can write, add a photo, record a voice note, or simply tag a mood. No performance required."*

**Step 2 of 5 — Circle Selector**
- Spotlight: The Circle selector (chips or dropdown)
- Title: "Choose Your Audience"
- Body: *"Pick one Circle or several. Only the people inside those specific Circles will ever see this post. This never changes after you share."*

**Step 3 of 5 — Media Attachments**
- Spotlight: The attachment icon row (photo, voice, file)
- Title: "Add to Your Post"
- Body: *"Attach photos, or hold the mic icon to record a voice note. Voice notes appear as an organic waveform — not a plain audio bar — because the shape of your voice carries tone."*

**Step 4 of 5 — Mood Tag**
- Spotlight: The mood / vibe selector
- Title: "Tag a Mood"
- Body: *"Optionally add how you're feeling. Your Circle can see your vibe and show up for you — without you having to find the words to explain it."*

**Step 5 of 5 — Share Button**
- Spotlight: The "Share" CTA button
- Title: "When You're Ready"
- Body: *"Tap Share when you're ready. There's no public to judge this. It's safe to be real here."*

---

## Screen 4 — Mood & Wellness Screen

**Screen purpose:** Log emotional state, access the breathing tool, view mood history, switch Safety Themes.

---

**Step 1 of 5 — Mood Logger**
- Spotlight: The mood color-orb selector row
- Title: "How Are You Feeling?"
- Body: *"Tap a mood to log your emotional state. The color palette is designed for nuance — not just 'happy' or 'sad.' Real emotional complexity lives somewhere in the middle."*

**Step 2 of 5 — Share Vibe Toggle**
- Spotlight: The "Share this vibe with…" toggle and Circle selector
- Title: "Let Your Circle Know"
- Body: *"You can share your current mood with specific Circles — without typing a single word. The people who care about you can check in proactively."*

**Step 3 of 5 — Breathing Tool**
- Spotlight: The breathing orb animation widget
- Title: "The Breathing Tool"
- Body: *"Tap the orb to start a guided breathing session. It syncs with your breath — in, hold, out. It's always here, one tap away, no matter how you got here."*

**Step 4 of 5 — Safety Themes**
- Spotlight: The theme switcher (Calm / Focus / etc.)
- Title: "Safety Themes"
- Body: *"Change how the entire app looks and feels based on what you need right now. 'Calm' softens everything. 'Focus' removes visual noise. Your app adapts to you."*

**Step 5 of 5 — Mood History**
- Spotlight: The mood timeline / history chart
- Title: "Your Mood History"
- Body: *"This is private to you — no one else sees it. Track patterns over time. Spot your good weeks and your rough ones. Know yourself better."*

---

## Screen 5 — Couples Space Screen

**Screen purpose:** A shared, end-to-end encrypted private world for two partners.

---

**Step 1 of 5 — The Shared Canvas**
- Spotlight: The main couples dashboard / overview area
- Title: "Your Shared Space"
- Body: *"This space is visible only to you and your partner. Think of it as a living digital home you've built together — private from everyone else, always."*

**Step 2 of 5 — Shared Calendar**
- Spotlight: The calendar widget or upcoming events section
- Title: "Plan Together"
- Body: *"Add dates, events, and countdowns. Tether remembers your milestones — anniversaries, first dates, trips — so you never have to dig through old messages."*

**Step 3 of 5 — Intimacy Check-In**
- Spotlight: The emotional check-in prompt card
- Title: "How Are We Doing?"
- Body: *"A gentle, periodic nudge to check in on the relationship itself — not logistics, not schedules. Just: how are we, as us? Prompted softly, never intrusively."*

**Step 4 of 5 — Private Vault**
- Spotlight: The Vault entry card (lock icon)
- Title: "The Private Vault"
- Body: *"End-to-end encrypted storage for your most sensitive documents, photos, and notes. Only the two of you can ever open it. Even Tether cannot access what's inside."*

**Step 5 of 5 — Shared Memory Stream**
- Spotlight: The shared post / memory feed
- Title: "Your Story, In Order"
- Body: *"A private, chronological stream of everything you've shared with each other. Your relationship's history — unfiltered, unranked, always yours."*

---

## Screen 6 — Family Bento Screen

**Screen purpose:** The modular family dashboard — the Family Bento Grid.

---

**Step 1 of 5 — The Bento Grid**
- Spotlight: The full grid layout
- Title: "Welcome to the Family Bento"
- Body: *"Each tile is a living widget — memories, voice notes, check-ins, shared calendars. Everything your family shares, organised into one beautiful, modular view."*

**Step 2 of 5 — Shared Memory Tile**
- Spotlight: The photos / scrapbook tile
- Title: "Shared Memories"
- Body: *"Any family member can drop a photo, a voice clip, or a 'little win' here. Over time, it becomes your family's living album — built together, one moment at a time."*

**Step 3 of 5 — Safety Check-In Tile**
- Spotlight: The check-in / safety tile
- Title: "Gentle Check-Ins"
- Body: *"A simple 'I'm okay' check-in — not tracking, not surveillance. Just the quiet comfort of knowing everyone in your family is doing alright today."*

**Step 4 of 5 — Voice Note Tile**
- Spotlight: The voice note widget
- Title: "Family Voice Notes"
- Body: *"Drop a voice note for the whole family. It renders as a warm, organic waveform — not a cold audio bar. Because voice carries what text simply can't."*

**Step 5 of 5 — Customise the Grid**
- Spotlight: The edit / customise button (pencil icon or "Edit Layout" option)
- Title: "Make It Yours"
- Body: *"Add new tiles, remove what you don't use, and rearrange until the Bento fits how your family actually lives. There's no default that works for everyone."*

---

## Screen 7 — Messaging / Chat Screen

**Screen purpose:** Direct messaging within a Circle or between individuals.

---

**Step 1 of 5 — The Chat Thread**
- Spotlight: The message thread / `ListView` area
- Title: "Private by Default"
- Body: *"Messages in Tether carry no read receipts by default. No blue ticks. No pressure to respond the moment you've read something. Reply when you're ready."*

**Step 2 of 5 — Voice Note Composer**
- Spotlight: The hold-to-record mic button
- Title: "Record a Voice Note"
- Body: *"Hold the mic icon to record. When sent, your voice appears as a living waveform — the other person can see the rhythm of your voice before they even press play."*

**Step 3 of 5 — Editorial Reactions**
- Spotlight: The long-press reaction menu
- Title: "React with Words"
- Body: *"Long-press any message to react. Your reaction appears woven into the thread — like a handwritten note in the margin. No thumbs-up counter. Just a real response."*

**Step 4 of 5 — Read Receipts Toggle**
- Spotlight: The chat settings → read receipts option
- Title: "No Read Receipt Anxiety"
- Body: *"Read receipts are off by default. If both of you want them on, you can enable them in chat settings. But the default is freedom from the pressure of the blue tick."*

**Step 5 of 5 — Thread Context Header**
- Spotlight: The top bar showing Circle name or contact
- Title: "Context Always Visible"
- Body: *"This conversation lives inside a Circle. Every message here is encrypted and only accessible to the members of that specific Circle — no one else."*

---

## Screen 8 — Settings / Profile Screen

**Screen purpose:** Account management, privacy controls, subscription, and personalization.

---

**Step 1 of 5 — Your Identity**
- Spotlight: Profile avatar + display name section
- Title: "Your Tether Identity"
- Body: *"Your name and photo are visible only to people already in your Circles. You're not discoverable publicly, not indexed anywhere. You're a person here — not a username."*

**Step 2 of 5 — Safety Themes**
- Spotlight: The theme selector section
- Title: "Safety Themes"
- Body: *"Switch how Tether looks and feels at any time — from here too. The theme follows you across the entire app the moment you change it."*

**Step 3 of 5 — Privacy Controls**
- Spotlight: The privacy settings section
- Title: "Your Privacy Controls"
- Body: *"Control who can find you, add you to Circles, or send you messages. Your defaults are already the most private possible — these settings let you go further if needed."*

**Step 4 of 5 — Tether Premium**
- Spotlight: The subscription / premium card
- Title: "Tether Premium"
- Body: *"Tether is free for the essentials. Premium unlocks unlimited Circles, the full encrypted Vault, and all Safety Themes. No ads. No data selling. Your subscription is how we stay independent."*

**Step 5 of 5 — Security**
- Spotlight: The account security section
- Title: "Lock Your Sanctuary"
- Body: *"Enable two-factor authentication and a passkey for the most secure, frictionless sign-in. Your data deserves a strong lock — this is where you set it."*

---

*Tether Output B — In-App Feature Onboarding v1.0*
