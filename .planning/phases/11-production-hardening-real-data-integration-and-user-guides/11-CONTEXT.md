# 11-production-hardening-real-data-integration-and-user-guides-CONTEXT.md

## Phase: 11 - Production Hardening, Real Data Integration, and User Guides

### Goal
Move from mock data to production-ready real working data with proper logic, and create interactive user guides for screens.

---

## Decisions

### D-01: Data Integration Strategy
**Decision:** Focus on core v1.0 flows to ensure stability before expanding.
- Prioritize Foundation, Circles & Feed, and Messaging flows for real data integration logic.
- Ensure all logic works correctly for these flows before addressing extended features.

### D-02: User Guides Implementation
**Decision:** Interactive Walkthroughs for first visit.
- Use an overlay/tooltip approach (e.g., using `showcaseview`) on the user's first visit to a screen.
- Aligns with the "safe and calm" project philosophy to gently introduce features without overwhelming the user.

### D-03: Data Synchronization & Realtime
**Decision:** Supabase Realtime for live updates on all screens.
- Use Supabase Realtime subscriptions to stream live updates to all relevant screens, keeping data fully live.

### D-04: SQL Hardening & RLS Policies
**Decision:** Consolidated migration for all 75+ features.
- Create robust Row Level Security (RLS) policies for all 30+ tables.
- Generate a consolidated SQL migration file to establish a strong security foundation for the entire roadmap now.

---

## Canonical references
- .planning/ROADMAP.md
- .planning/PROJECT.md
- .planning/REQUIREMENTS.md

---

*Generated via /gsd-discuss-phase*
