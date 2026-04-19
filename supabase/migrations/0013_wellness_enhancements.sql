-- 0013_wellness_enhancements.sql

-- RLS for digital_hugs
DROP POLICY IF EXISTS "send_hugs" ON digital_hugs;
CREATE POLICY "send_hugs" ON digital_hugs
  FOR INSERT WITH CHECK (auth.uid() = sender_id);

DROP POLICY IF EXISTS "read_hugs" ON digital_hugs;
CREATE POLICY "read_hugs" ON digital_hugs
  FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- RLS for kindness_streaks
DROP POLICY IF EXISTS "insert_own_streaks" ON kindness_streaks;
CREATE POLICY "insert_own_streaks" ON kindness_streaks
  FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "read_circle_streaks" ON kindness_streaks;
CREATE POLICY "read_circle_streaks" ON kindness_streaks
  FOR SELECT USING (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM circle_members
      WHERE circle_id = kindness_streaks.circle_id
      AND user_id = auth.uid()
    )
  );

-- RLS for check_ins
DROP POLICY IF EXISTS "insert_own_check_in" ON check_ins;
CREATE POLICY "insert_own_check_in" ON check_ins
  FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "read_circle_check_ins" ON check_ins;
CREATE POLICY "read_circle_check_ins" ON check_ins
  FOR SELECT USING (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM circle_members
      WHERE circle_id = check_ins.circle_id
      AND user_id = auth.uid()
    )
  );

-- RLS for quiet_hours
DROP POLICY IF EXISTS "manage_own_quiet_hours" ON quiet_hours;
CREATE POLICY "manage_own_quiet_hours" ON quiet_hours
  FOR ALL USING (user_id = auth.uid());

DROP POLICY IF EXISTS "read_circle_quiet_hours" ON quiet_hours;
CREATE POLICY "read_circle_quiet_hours" ON quiet_hours
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM circle_members cm1
      JOIN circle_members cm2 ON cm1.circle_id = cm2.circle_id
      WHERE cm1.user_id = auth.uid()
      AND cm2.user_id = quiet_hours.user_id
    )
  );

-- RLS for shared_playlists
DROP POLICY IF EXISTS "read_circle_playlists" ON shared_playlists;
CREATE POLICY "read_circle_playlists" ON shared_playlists
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM circle_members
      WHERE circle_id = shared_playlists.circle_id
      AND user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "manage_own_playlists" ON shared_playlists;
CREATE POLICY "manage_own_playlists" ON shared_playlists
  FOR ALL USING (created_by = auth.uid());

-- Fix gratitude_journal RLS (ensure users can insert their own)
DROP POLICY IF EXISTS "insert_own_gratitude" ON gratitude_journal;
CREATE POLICY "insert_own_gratitude" ON gratitude_journal
  FOR INSERT WITH CHECK (auth.uid() = user_id);
