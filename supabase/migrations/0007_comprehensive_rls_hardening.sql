-- 0007_comprehensive_rls_hardening.sql

-- Ensure RLS is enabled on all tables
ALTER TABLE circles ENABLE ROW LEVEL SECURITY;
ALTER TABLE circle_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE mood_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE check_ins ENABLE ROW LEVEL SECURITY;
ALTER TABLE voice_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE digital_hugs ENABLE ROW LEVEL SECURITY;

-- Disable generic read/write test policies if any exist (none explicitly written, but safety first)

-- Policy: Reactions
DROP POLICY IF EXISTS "read_circle_reactions" ON reactions;
CREATE POLICY "read_circle_reactions" ON reactions
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM posts WHERE posts.id = reactions.post_id AND is_member_of(posts.circle_id)
    )
  );

DROP POLICY IF EXISTS "insert_own_reactions" ON reactions;
CREATE POLICY "insert_own_reactions" ON reactions
  FOR INSERT WITH CHECK (
    auth.uid() = user_id AND
    EXISTS (
      SELECT 1 FROM posts WHERE posts.id = reactions.post_id AND is_member_of(posts.circle_id)
    )
  );

DROP POLICY IF EXISTS "delete_own_reactions" ON reactions;
CREATE POLICY "delete_own_reactions" ON reactions
  FOR DELETE USING (auth.uid() = user_id);

-- Policy: Messages
DROP POLICY IF EXISTS "insert_own_messages" ON messages;
CREATE POLICY "insert_own_messages" ON messages
  FOR INSERT WITH CHECK (
    auth.uid() = sender_id AND 
    (
      circle_id IS NULL OR is_member_of(circle_id)
    )
  );

-- Prevent unauthorized message updating
DROP POLICY IF EXISTS "update_own_messages" ON messages;
CREATE POLICY "update_own_messages" ON messages
  FOR UPDATE USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- Policy: Mood Rooms
DROP POLICY IF EXISTS "read_circle_moods" ON mood_rooms;
CREATE POLICY "read_circle_moods" ON mood_rooms
  FOR SELECT USING (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM circle_members cm
      WHERE cm.user_id = mood_rooms.user_id
      AND is_member_of(cm.circle_id)
    )
  );

DROP POLICY IF EXISTS "update_own_mood" ON mood_rooms;
CREATE POLICY "update_own_mood" ON mood_rooms
  FOR UPDATE USING (user_id = auth.uid());

DROP POLICY IF EXISTS "insert_own_mood" ON mood_rooms;
CREATE POLICY "insert_own_mood" ON mood_rooms
  FOR INSERT WITH CHECK (user_id = auth.uid());
