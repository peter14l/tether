# INTEGRATIONS - External Services & APIs

## Backend: Supabase

### Auth
- Email/password, magic link, optional Google OAuth
- Session via flutter_secure_storage

### Database Tables
profiles, circles, circle_members, posts, reactions, mood_rooms, check_ins, temperature_checks, digital_hugs, voice_notes, gratitude_journal, reflection_wall, shared_playlists, shared_calendar, couple_bubble, heartbeats, favor_coupons, future_letters, family_safety_checks, sos_alerts, quiet_hours, soft_blocks, kindness_streaks, heritage_corner, bedtime_stories, notifications_log

### Storage Buckets
| Bucket | Purpose | Access |
|-------|---------|-------|
| avatars | Profile pics | Public read |
| circle-media | Posts, images | Circle members |
| voice-notes | Audio | Circle members |
| private-gallery | Couple photos | Owners only |
| heritage-media | Family photos | Circle members |

### Realtime
Mood updates, Digital Hug, Heartbeat, Check-In, Temperature Check, new posts, SOS alerts, presence

### Edge Functions
deliver-future-letters, check-in-watchdog, safety-check-escalator, send-push-notification, delete-expired-one-way-posts, deliver-scheduled-messages

## Security
- Client-side AES-256 encryption for sensitive data
- RLS enforced on all tables