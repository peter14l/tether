# Phase 11: Production Hardening, Real Data Integration, and User Guides - Research

## Technical Architecture & Implementation Strategy

### 1. Data Integration Strategy (Core v1.0 Flows)
The core v1.0 flows (Foundation, Circles & Feed, Messaging) require replacing static mock models with robust, fault-tolerant Supabase BLoC/Repository hooks. 
- **Feed Flow:** `FeedCubit` and `IFeedRepository` need to correctly handle fetching paginated real posts from the `posts` table (with `circle_id` filtering).
- **Messaging Flow:** Chat screen must fetch `messages`, user presence, and handle proper message sending flows. 

### 2. User Guides / Interactive Walkthroughs
- **Package Selection:** `showcaseview` is the standard Flutter package for creating sequence-based overlay tooltips. It aligns with the "safe and calm" requirement by gently pointing out features sequentially.
- **Implementation:** 
  - Wrap the app's root or top-level navigation screens with `ShowCaseWidget`.
  - Use `Showcase` widget to wrap key UI components (e.g., Circle Creation button, Messaging entry, Mood selection).
  - Use `SharedPreferences` to persistently track whether a user has already completed the "first visit" tutorial for a specific screen, ensuring they are only shown once.

### 3. Supabase Realtime Synchronization
- **Realtime Integration:** Supabase Realtime needs to be actively subscribed to in the core BLoCs (e.g., `MessagingBloc`, `FeedCubit`, `CirclesCubit`).
- **Implementation:**
  - Standardize on Supabase `.stream(primaryKey: ['id'])` to obtain real-time updates.
  - Listen to these streams within the Repositories/Data Sources and map them to domain entities via Dart Streams.
  - Update BLoC states on stream events. Requires handling `StreamSubscription` disposing on BLoC `close()`.

### 4. Consolidated SQL Migration (RLS Hardening)
- **Tables requiring RLS:** Focus on all 30+ tables (such as `users`, `circles`, `circle_members`, `posts`, `reactions`, `messages`, `moods`).
- **Policy Strategy:**
  - Authenticated Users Only (no public access).
  - Data isolation: Users can only select/insert/update data linked to their `id` or the `circle_id` they belong to (validated by `circle_members`).
  - Generate a `phase_11_hardening.sql` migration file using `supabase db commit` or manual migration file creation.

---

## Validation Architecture

### Verification Strategy
- **Unit Testing:** Validate `showcaseview` initialization and `SharedPreferences` logic. Mock Supabase real-time streams to test BLoC state emissions.
- **Integration Testing:** Test Supabase RLS policies by logging in as user A and attempting to query user B's private circle data; it should return null/empty.
- **UI Testing:** Verify `Showcase` tooltips appear correctly and only on the first visit. 

### Dependencies & Setup Requirements
- Add `showcaseview` and `shared_preferences` (if not already present) to `pubspec.yaml`.
- Requires a functional Supabase backend configured for testing.

---

## Conclusion
The path forward is clear. The key is to standardize real-time subscriptions, secure all database tables via a comprehensive RLS migration, and safely guide the user using `showcaseview`.
