# Design System Specification: The Intimate Sanctuary

## 1. Overview & Creative North Star

**Creative North Star: The Living Journal**
This design system moves away from the sterile, modular "tech" aesthetic and toward the tactile elegance of high-end editorial design. The goal is to create a digital sanctuary that feels like a handcrafted personal letter or a luxury linen journal. We achieve this through "The Living Journal" philosophy: layouts are intentionally asymmetric, surfaces feel soft and organic, and the interface breathes through generous white space and radial glows.

By rejecting rigid grids and harsh dividers, we foster an environment of emotional safety. We don't just display data; we curate moments of connection.

---

## 2. Colors & Tonal Depth

The palette is dynamic, shifting with the user’s circadian rhythm to reflect the emotional weight of different times of day. 

### The "No-Line" Rule
To maintain "Quiet Luxury," **1px solid borders are strictly prohibited for sectioning.** Boundaries must be defined through:
*   **Tonal Transitions:** Using a `surface-container-low` section sitting on a `surface` background.
*   **Soft Voids:** Using vertical white space to separate thoughts and content.

### Surface Hierarchy & Nesting
Treat the UI as stacked sheets of fine, semi-transparent paper. 
*   **Nesting:** Place a `surface-container-highest` card within a `surface-container-low` background to create a "nested" lift. 
*   **The Glass & Gradient Rule:** Use semi-transparent surface colors with a `backdrop-filter: blur(20px)` for floating elements (modals, navigation bars).
*   **Signature Textures:** Main CTAs should utilize a subtle linear gradient from `primary` to `primary-container` (at a 45-degree angle) to provide a "soulful" depth that flat colors lack.

### Time-Based Themes
1.  **Morning (5am–12pm):** Warm Linen (`#F5F0E8`) background. Focus on Terracotta accents and Sage secondary tones.
2.  **Afternoon (12pm–5:30pm):** Light Cream (`#F8F3EC`) background. Golden Amber accents and Muted Teal secondary.
3.  **Dusk (Hero Theme):** Deep Plum-Black (`#1A1018`) background. Sunset Orange and Rose-Violet accents. This aligns with our core Material tokens.
4.  **Night (9pm–5am):** Navy-Black (`#0E0C14`) background. Periwinkle and Lavender accents.

---

## 3. Typography: Editorial Authority

Typography is our primary tool for conveying "Handcrafted Warmth."

*   **Display & Headlines (Noto Serif / Playfair Display):** These should be treated as editorial anchors. Use `display-lg` for moments of reflection. The high-contrast serif adds a layer of sophisticated, human authority.
*   **Body & Titles (Plus Jakarta Sans / DM Sans):** A humanist sans-serif that ensures readability while remaining approachable. 
*   **Whisper Mode:** For sensitive or intimate content, use a specialized styling:
    *   **Font:** DM Sans 300
    *   **Size:** 12sp (label-md equivalent)
    *   **Letter Spacing:** 0.05em
    *   **Opacity:** 85% to mimic a soft breath.

---

## 4. Elevation & Depth: Tonal Layering

We reject traditional drop shadows. We create depth through "light" and "stacking."

*   **The Layering Principle:** Depth is achieved by "stacking" surface-container tiers. A `surface-container-lowest` card on a `surface-container-low` section creates a natural, soft recession.
*   **Ambient Shadows (The Glow):** When a floating effect is required, shadows must be extra-diffused.
    *   **Inner Bloom:** A soft inner shadow using `primary` at 10% opacity.
    *   **Outer Halo:** A large-spread shadow (30px–50px blur) using a tinted version of the `on-surface` color at 4%–8% opacity.
*   **The Ghost Border:** If a boundary is required for accessibility, use a "Ghost Border": `outline-variant` at **18% opacity**. Never use 100% opaque borders.

---

## 5. Components

### Cards & Containers
*   **Radius:** 18dp (`md/lg` scale).
*   **Rule:** No dividers. Separate content using `surface-variant` shifts or 24dp–32dp of vertical padding.
*   **Organic Shape:** Use "squircle" or slightly irregular rounded paths for profile avatars to emphasize the handcrafted feel.

### Buttons
*   **Radius:** 14dp (`DEFAULT` scale).
*   **Primary:** Gradient-filled (Primary to Primary-Container) with a subtle inner glow.
*   **Secondary:** Ghost Border (18% opacity) with a `surface-container-high` background.
*   **Animation:** Use a "Breathing Pulse"—a subtle 2% scale oscillation when a button is in a high-priority state.

### Input Fields
*   **Styling:** Soft-bottomed. Only use a bottom-stroke (Ghost Border style) or a fully enclosed container with a `surface-container-low` fill.
*   **States:** On focus, the container should emit a soft `primary_dim` radial glow from the center.

### Interaction Elements
*   **Chips:** Selection chips should use the `full` radius scale. When selected, apply a `secondary_container` fill with `on-secondary_container` text.
*   **Tooltips:** High-blur glassmorphism. Positioned with intentional asymmetry (e.g., slightly offset to the right) to feel less like a "system default."

### Signature Component: The Connection Pulse
A custom component for this app: a central, organic shape that uses **Radial Glows** to visualize the "heartbeat" of a connection. It uses multiple layers of `secondary` and `tertiary` colors at low opacities, expanding and contracting slowly.

---

## 6. Do's and Don'ts

### Do
*   **Do** use asymmetrical margins. If the left margin is 24dp, try a 32dp right margin for editorial flair.
*   **Do** prioritize "Tonal Layering" over shadows.
*   **Do** use "Whisper Mode" for secondary metadata to create visual hierarchy.
*   **Do** ensure all "Glass" elements have a high blur (20px+) to ensure text legibility.

### Don't
*   **Don't** use pure black (#000000) for text; always use the `on-surface` tokens which are warm-tinted.
*   **Don't** use sharp 90-degree corners anywhere in the application.
*   **Don't** use standard "Divider" lines to separate list items; use white space.
*   **Don't** use high-speed, "snappy" animations. Everything should feel like it is moving through water or air—graceful and intentional.