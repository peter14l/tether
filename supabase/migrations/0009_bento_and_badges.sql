-- 0009_bento_and_badges.sql

-- User Bento Preferences for Home/Circle screens
CREATE TABLE IF NOT EXISTS bento_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    screen_key TEXT NOT NULL, -- 'home' | 'family' | 'couples'
    layout_json JSONB NOT NULL, -- Custom tile arrangement
    updated_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(user_id, screen_key)
);

-- kindness_badges (Earned badges)
CREATE TABLE IF NOT EXISTS kindness_badges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    badge_type TEXT NOT NULL, -- 'heart_listener' | 'warm_presence' | etc.
    awarded_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(user_id, badge_type)
);

-- RLS
ALTER TABLE bento_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE kindness_badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "own_bento_preferences" ON bento_preferences FOR ALL USING (user_id = auth.uid());
CREATE POLICY "read_own_badges" ON kindness_badges FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "read_friend_badges" ON kindness_badges FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM circle_members cm1
    JOIN circle_members cm2 ON cm1.circle_id = cm2.circle_id
    WHERE cm1.user_id = auth.uid()
    AND cm2.user_id = kindness_badges.user_id
  )
);
