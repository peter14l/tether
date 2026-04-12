-- 0001_initial_schema.sql

-- Enable extension for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Updated at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- profiles
CREATE TABLE IF NOT EXISTS profiles (
    id UUID REFERENCES auth.users PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    display_name TEXT NOT NULL,
    avatar_url TEXT,
    bio TEXT,
    pronouns TEXT,
    mood_status TEXT,
    is_quiet BOOLEAN DEFAULT false,
    quiet_until TIMESTAMPTZ,
    timezone TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- circles
CREATE TABLE IF NOT EXISTS circles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    circle_type TEXT NOT NULL, -- 'friends' | 'couple' | 'family' | 'inlaw'
    created_by UUID REFERENCES profiles(id),
    avatar_url TEXT,
    description TEXT,
    comfort_radius TEXT DEFAULT 'inner', -- 'inner' | 'close' | 'all'
    is_encrypted BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TRIGGER update_circles_updated_at BEFORE UPDATE ON circles FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- circle_members
CREATE TABLE IF NOT EXISTS circle_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id),
    role TEXT DEFAULT 'member', -- 'admin' | 'member'
    joined_at TIMESTAMPTZ DEFAULT now()
);

-- posts
CREATE TABLE IF NOT EXISTS posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id) ON DELETE CASCADE,
    author_id UUID REFERENCES profiles(id),
    content_type TEXT NOT NULL, -- 'text' | 'image' | 'voice' | 'letter' | 'one_way'
    content_text TEXT,
    media_url TEXT,
    is_anonymous BOOLEAN DEFAULT false,
    deliver_at TIMESTAMPTZ,
    expires_after INTERVAL,
    is_soft_deleted BOOLEAN DEFAULT false,
    soft_deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- reactions
CREATE TABLE IF NOT EXISTS reactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id),
    reaction_type TEXT NOT NULL, -- 'warm' | 'comforting' | 'i_see_you' | 'sending_strength'
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(post_id, user_id)
);

-- mood_rooms
CREATE TABLE IF NOT EXISTS mood_rooms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) UNIQUE,
    status TEXT, -- 'need_quiet' | 'anxious' | 'want_to_chat' | 'happy' | etc.
    label TEXT, -- custom label
    color_key TEXT, -- maps to UI color
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TRIGGER update_mood_rooms_updated_at BEFORE UPDATE ON mood_rooms FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- check_ins
CREATE TABLE IF NOT EXISTS check_ins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id),
    checked_in_at TIMESTAMPTZ DEFAULT now(),
    circle_id UUID REFERENCES circles(id)
);

-- temperature_checks
CREATE TABLE IF NOT EXISTS temperature_checks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id),
    date DATE DEFAULT CURRENT_DATE,
    responses JSONB, -- { user_id: emoji_key }
    created_at TIMESTAMPTZ DEFAULT now()
);

-- digital_hugs
CREATE TABLE IF NOT EXISTS digital_hugs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID REFERENCES profiles(id),
    receiver_id UUID REFERENCES profiles(id),
    circle_id UUID REFERENCES circles(id),
    sent_at TIMESTAMPTZ DEFAULT now(),
    returned_at TIMESTAMPTZ
);

-- voice_notes
CREATE TABLE IF NOT EXISTS voice_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id),
    sender_id UUID REFERENCES profiles(id),
    storage_path TEXT NOT NULL,
    duration_secs INTEGER,
    is_slow_chat BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- gratitude_journal (encrypted)
CREATE TABLE IF NOT EXISTS gratitude_journal (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id),
    encrypted_blob TEXT NOT NULL, -- AES-256 encrypted client-side
    shared_with_circle_id UUID REFERENCES circles(id), -- null = private
    date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- reflection_wall (encrypted, always private)
CREATE TABLE IF NOT EXISTS reflection_wall (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id),
    encrypted_blob TEXT NOT NULL, -- never readable server-side
    created_at TIMESTAMPTZ DEFAULT now()
);

-- shared_playlists
CREATE TABLE IF NOT EXISTS shared_playlists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id),
    created_by UUID REFERENCES profiles(id),
    title TEXT,
    type TEXT, -- 'ambient' | 'music' | 'lofi'
    tracks JSONB, -- array of track objects
    created_at TIMESTAMPTZ DEFAULT now()
);

-- shared_calendar
CREATE TABLE IF NOT EXISTS shared_calendar (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id),
    created_by UUID REFERENCES profiles(id),
    title TEXT NOT NULL,
    description TEXT,
    event_date DATE NOT NULL,
    is_recurring BOOLEAN DEFAULT false,
    recurrence_rule TEXT, -- iCal RRULE format
    created_at TIMESTAMPTZ DEFAULT now()
);

-- couple_bubble (extends circles for couple type)
CREATE TABLE IF NOT EXISTS couple_bubble (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id) UNIQUE,
    our_song_url TEXT,
    our_song_title TEXT,
    anniversary_date DATE,
    promise_ring_set_at TIMESTAMPTZ,
    promise_ring_text TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- heartbeats
CREATE TABLE IF NOT EXISTS heartbeats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID REFERENCES profiles(id),
    receiver_id UUID REFERENCES profiles(id),
    sent_at TIMESTAMPTZ DEFAULT now()
);

-- favor_coupons
CREATE TABLE IF NOT EXISTS favor_coupons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id),
    created_by UUID REFERENCES profiles(id),
    assigned_to UUID REFERENCES profiles(id),
    description TEXT NOT NULL,
    redeemed BOOLEAN DEFAULT false,
    redeemed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- future_letters
CREATE TABLE IF NOT EXISTS future_letters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id),
    sender_id UUID REFERENCES profiles(id),
    receiver_id UUID REFERENCES profiles(id),
    encrypted_blob TEXT NOT NULL,
    deliver_at TIMESTAMPTZ NOT NULL,
    delivered BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- family_safety_checks
CREATE TABLE IF NOT EXISTS family_safety_checks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id),
    triggered_by UUID REFERENCES profiles(id),
    responded_at TIMESTAMPTZ,
    timeout_minutes INTEGER DEFAULT 30,
    status TEXT DEFAULT 'pending', -- 'pending' | 'safe' | 'escalated'
    created_at TIMESTAMPTZ DEFAULT now()
);

-- sos_alerts
CREATE TABLE IF NOT EXISTS sos_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id),
    circle_id UUID REFERENCES circles(id),
    location_lat DOUBLE PRECISION,
    location_lng DOUBLE PRECISION,
    location_accuracy DOUBLE PRECISION,
    sent_at TIMESTAMPTZ DEFAULT now(),
    resolved_at TIMESTAMPTZ
);

-- quiet_hours
CREATE TABLE IF NOT EXISTS quiet_hours (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) UNIQUE,
    enabled BOOLEAN DEFAULT false,
    start_time TIME NOT NULL, -- e.g. 21:00
    end_time TIME NOT NULL, -- e.g. 07:00
    wind_down_start TIME, -- fade-out begins here
    days_active TEXT[], -- ['mon','tue','wed','thu','fri','sat','sun']
    created_at TIMESTAMPTZ DEFAULT now()
);

-- soft_blocks
CREATE TABLE IF NOT EXISTS soft_blocks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    blocker_id UUID REFERENCES profiles(id),
    blocked_id UUID REFERENCES profiles(id),
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(blocker_id, blocked_id)
);

-- kindness_streaks
CREATE TABLE IF NOT EXISTS kindness_streaks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id),
    circle_id UUID REFERENCES circles(id),
    action_type TEXT, -- 'voice_note' | 'check_in' | 'shared_something'
    logged_at TIMESTAMPTZ DEFAULT now()
);

-- heritage_corner
CREATE TABLE IF NOT EXISTS heritage_corner (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id),
    uploaded_by UUID REFERENCES profiles(id),
    media_url TEXT NOT NULL,
    caption TEXT,
    era_label TEXT, -- e.g. "1970s", "Before you were born"
    tags TEXT[],
    created_at TIMESTAMPTZ DEFAULT now()
);

-- bedtime_stories
CREATE TABLE IF NOT EXISTS bedtime_stories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id),
    recorded_by UUID REFERENCES profiles(id),
    title TEXT,
    storage_path TEXT NOT NULL,
    duration_secs INTEGER,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- notifications_log
CREATE TABLE IF NOT EXISTS notifications_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id),
    type TEXT, -- 'digital_hug' | 'check_in_missed' | etc.
    payload JSONB,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- messages (New for DMs)
CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID REFERENCES profiles(id),
    receiver_id UUID REFERENCES profiles(id),
    circle_id UUID REFERENCES circles(id), -- optional, for circle-scoped DMs
    content_type TEXT NOT NULL, -- 'text' | 'image' | 'voice'
    content_text TEXT,
    media_url TEXT,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- escrow_keys (New for Cloud Escrow Strategy)
CREATE TABLE IF NOT EXISTS escrow_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) UNIQUE,
    encrypted_master_key TEXT NOT NULL,
    salt TEXT NOT NULL,
    iv TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TRIGGER update_escrow_keys_updated_at BEFORE UPDATE ON escrow_keys FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- RLS POLICIES (From PRD 6.6)

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE circles ENABLE ROW LEVEL SECURITY;
ALTER TABLE circle_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE mood_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_ins ENABLE ROW LEVEL SECURITY;
ALTER TABLE digital_hugs ENABLE ROW LEVEL SECURITY;
ALTER TABLE voice_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE gratitude_journal ENABLE ROW LEVEL SECURITY;
ALTER TABLE reflection_wall ENABLE ROW LEVEL SECURITY;
ALTER TABLE shared_playlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE shared_calendar ENABLE ROW LEVEL SECURITY;
ALTER TABLE couple_bubble ENABLE ROW LEVEL SECURITY;
ALTER TABLE heartbeats ENABLE ROW LEVEL SECURITY;
ALTER TABLE favor_coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE future_letters ENABLE ROW LEVEL SECURITY;
ALTER TABLE family_safety_checks ENABLE ROW LEVEL SECURITY;
ALTER TABLE sos_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiet_hours ENABLE ROW LEVEL SECURITY;
ALTER TABLE soft_blocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE kindness_streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE heritage_corner ENABLE ROW LEVEL SECURITY;
ALTER TABLE bedtime_stories ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE escrow_keys ENABLE ROW LEVEL SECURITY;

-- read_shared_circle_profiles
CREATE POLICY "read_shared_circle_profiles" ON profiles FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM circle_members cm1
    JOIN circle_members cm2 ON cm1.circle_id = cm2.circle_id
    WHERE cm1.user_id = auth.uid()
    AND cm2.user_id = profiles.id
  )
);

-- read_circle_posts
CREATE POLICY "read_circle_posts" ON posts FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM circle_members
    WHERE circle_id = posts.circle_id
    AND user_id = auth.uid()
  )
);

-- own_soft_blocks
CREATE POLICY "own_soft_blocks" ON soft_blocks FOR ALL USING (blocker_id = auth.uid());

-- private_reflection_wall
CREATE POLICY "private_reflection_wall" ON reflection_wall FOR ALL USING (user_id = auth.uid());

-- read_gratitude
CREATE POLICY "read_gratitude" ON gratitude_journal FOR SELECT USING (
  user_id = auth.uid()
  OR (
    shared_with_circle_id IS NOT NULL
    AND EXISTS (
      SELECT 1 FROM circle_members
      WHERE circle_id = shared_with_circle_id
      AND user_id = auth.uid()
    )
  )
);

-- messages policy: sender or receiver
CREATE POLICY "read_own_messages" ON messages FOR SELECT USING (
  sender_id = auth.uid() OR receiver_id = auth.uid()
);

-- escrow_keys policy: own keys
CREATE POLICY "own_escrow_keys" ON escrow_keys FOR ALL USING (user_id = auth.uid());
