# REQUIREMENTS.md - Tether v1.0

## v1.0 MVP Scope

### Core Platform Features (MUST HAVE)

1. **Authentication**
   - Email/password signup & login
   - Magic link login
   - Session management with secure storage
   - Profile setup: username, display name, avatar

2. **Circles**
   - Create Friend Circle (2–20 members)
   - Create Couple Circle (exactly 2)
   - Create Family Circle
   - Invite via username/link
   - Comfort Radius settings (Inner/Close/All)

3. **Feed**
   - Chronological feed (no algorithm)
   - Posts: text, image
   - No likes, gentle reactions only
   - No engagement counts

4. **Messaging**
   - Direct messages
   - Voice notes
   - Read receipts (opt-in)

5. **Time-Adaptive UI**
   - 4 time slots with smooth transitions
   - Theme colors per slot
   - 15-minute crossfade

---

### v1.1 Wellness Features

6. **Mood Rooms**
   - Status: Need Quiet, Anxious, Want to Chat, Happy, Tired
   - Visible to Circle members
   - Auto-clear after 12 hours

7. **Check-In System**
   - One-tap daily check-in
   - Visible to Circles

8. **Quiet Hours / Wind Down**
   - User-defined quiet periods
   - UI dims before quiet hours

9. **Breathing Room**
   - Full-screen breathing exercise
   - 4-7-8 pattern

10. **Digital Hug**
    - No-text notification pulse
    - Haptic feedback

---

### v1.2 Couples Features (Unlocked with Couple Circle)

11. **Our Bubble** - Private shared space
12. **Heartbeat Check** - Visual pulse
13. **Good Morning / Good Night** - Scheduled messages
14. **Private Gallery** - Encrypted photos
15. **Milestones** - Auto-tracked timeline

---

### v1.3 Family Features (Unlocked with Family Circle)

16. **Family Circle** - Dedicated space
17. **Safety Check** - "Are you safe?" triggers
18. **Emergency SOS** - One-tap alert with location
19. **Location Sharing** - Family-only
20. **Grandparent Easy View** - Simplified UI

---

### v1.4 Extended Features

21. **Letter Mode** - Scheduled delivery
22. **Reflection Wall** - Private encrypted journal
23. **Gratitude Journal** - Daily with optional sharing
24. **Shared Playlists** - Ambient sounds
25. **Memories Lane** - Chronological timeline
26. **Gentle Reactions** - Warm, Comforting, I See You, Sending Strength

---

## Non-Functional Requirements

### Performance
- App launch < 2 seconds
- Feed load < 500ms
- Realtime latency < 1 second

### Security
- Client-side AES-256 encryption for sensitive data
- No plaintext storage of private content
- RLS enforced on Supabase

### Accessibility
- Screen reader support
- High contrast mode
- Scalable fonts

---

## Out of Scope for v1.0

- Public social features
- Ads or monetization
- Third-party integrations
- Web platform