# 07-monetization-CONTEXT.md

## Phase: 07 - Monetization & Subscription

### Goal
Implement the paywall system with Tether Plus subscription, feature gating based on tier, and PPP-adjusted pricing.

---

## Decisions

### D-01: Subscription Model
**Decision:** Tether Plus subscription with monthly/annual options
- Monthly: $4.99/month (base USD)
- Annual: $39.99/year (save 33%)
- Family Plan: $7.99/month or $59.99/year (up to 10 members)
- Student: $2.99/month with .edu verification

### D-02: Free Tier Limits
**Decision:** Lock features beyond:
- 1 Circle maximum
- 5 members per circle maximum
- 30 Gratitude Journal entries
- Text + image messaging only
- Core wellness (Mood Rooms, Breathing Room, Quiet Hours, Check-In)

### D-03: Paywalled Features
**Decision:** Lock behind Tether Plus:
- Unlimited Circles
- All Couples features (Our Bubble, Heartbeat, Good Morning/Night, etc.)
- All Family features (Safety Check, SOS, Heritage Corner, Bedtime Stories, etc.)
- Voice Notes (Slow Chat mode)
- Letter Mode (scheduled messages)
- Future Letters (time capsules)
- Memory Lane (unlimited)
- Shared Ambient Sounds
- Gentle Gamification badges

### D-04: Pricing Strategy
**Decision:** PPP (Purchasing Power Parity) adjusted pricing
- Base USD prices as floor
- Automatically adjust for regional markets based on GDP/purchasing power
- Use RevenueCat or similar for regional pricing tiers

### D-05: Subscription Provider
**Decision:** Use RevenueCat for subscription management
- Cross-platform (iOS + Android)
- Regional pricing support
- Analytics and cohort tracking
- Easy integration with Supabase for entitlement verification

### D-06: Feature Gating Architecture
**Decision:** Backend-based entitlement verification
- Store subscription status in Supabase (user_profiles table)
- Edge Functions verify entitlement before granting access
- Client-side UI shows "upgrade" prompts but doesn't block core functionality

### D-07: Grace Period Handling
**Decision:** 7-day grace period after subscription expires
- Users retain Plus features for 7 days
- Notification at day 3 and day 6
- After grace period, downgrade to Free tier UI

---

## Deferred Ideas

- **Web platform subscription** — Not in v1.0 scope
- **Lifetime purchase option** — Defer to v1.5
- **Referral program** — Defer to v1.5
- **Family plan with >10 members** — Defer to v2.0

---

## Implementation Approach

### Scope: Phase 7 (Monetization)

This phase covers:
1. **Subscription Infrastructure**
   - RevenueCat integration
   - Supabase entitlement table
   - Edge Functions for entitlement verification

2. **Feature Gating System**
   - Backend: API guardrails
   - Frontend: Upgrade prompts UI

3. **Pricing Display**
   - PPP-adjusted price display
   - Regional currency formatting

4. **User Subscription UI**
   - Subscription status screen
   - Upgrade flow
   - Manage subscription (link to App Store/Play Store)

5. **Grace Period Logic**
   - 7-day grace period after expiry
   - Notification system

---

## Feature Gating Map

| Feature | Free | Plus |
|---------|------|------|
| Circles (max 1) | ✅ | ✅ (unlimited) |
| Circle Members (max 5) | ✅ | ✅ (unlimited) |
| Mood Rooms | ✅ | ✅ |
| Breathing Room | ✅ | ✅ |
| Quiet Hours | ✅ | ✅ |
| Check-In System | ✅ | ✅ |
| Text Messaging | ✅ | ✅ |
| Image Messaging | ✅ | ✅ |
| Voice Notes | ❌ | ✅ |
| Letter Mode | ❌ | ✅ |
| Future Letters | ❌ | ✅ |
| Couples Features | ❌ | ✅ |
| Family Features | ❌ | ✅ |
| Memory Lane (unlimited) | ❌ | ✅ (limited in free) |
| Shared Ambient Sounds | ❌ | ✅ |
| Bedtime Stories | ❌ | ✅ |
| Gentle Gamification | ❌ | ✅ |
| Gratitude Journal (30 limit) | ✅ (30) | ✅ (unlimited) |

---

## Requirements

- **MON-01:** Subscription infrastructure (RevenueCat + Supabase)
- **MON-02:** Feature gating backend (Edge Functions)
- **MON-03:** Upgrade UI flow
- **MON-04:** Subscription status display
- **MON-05:** PPP-adjusted pricing display
- **MON-06:** Grace period handling

---

*Generated via /gsd-discuss-phase --auto*