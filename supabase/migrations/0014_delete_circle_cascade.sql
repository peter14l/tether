-- 0014_delete_circle_cascade.sql

-- Allow circle creators to delete their circles
DROP POLICY IF EXISTS "Creators can delete their circles" ON circles;
CREATE POLICY "Creators can delete their circles" ON circles
  FOR DELETE USING (auth.uid() = created_by);

-- Drop existing constraints that might prevent deletion
ALTER TABLE circle_members DROP CONSTRAINT IF EXISTS circle_members_circle_id_fkey;
ALTER TABLE posts DROP CONSTRAINT IF EXISTS posts_circle_id_fkey;

DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'check_ins_circle_id_fkey') THEN
    ALTER TABLE check_ins DROP CONSTRAINT check_ins_circle_id_fkey;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'kindness_streaks_circle_id_fkey') THEN
    ALTER TABLE kindness_streaks DROP CONSTRAINT kindness_streaks_circle_id_fkey;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'digital_hugs_circle_id_fkey') THEN
    ALTER TABLE digital_hugs DROP CONSTRAINT digital_hugs_circle_id_fkey;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'shared_playlists_circle_id_fkey') THEN
    ALTER TABLE shared_playlists DROP CONSTRAINT shared_playlists_circle_id_fkey;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'messages_circle_id_fkey') THEN
    ALTER TABLE messages DROP CONSTRAINT messages_circle_id_fkey;
  END IF;
END $$;

-- Re-add constraints with ON DELETE CASCADE
ALTER TABLE circle_members ADD CONSTRAINT circle_members_circle_id_fkey FOREIGN KEY (circle_id) REFERENCES circles(id) ON DELETE CASCADE;
ALTER TABLE posts ADD CONSTRAINT posts_circle_id_fkey FOREIGN KEY (circle_id) REFERENCES circles(id) ON DELETE CASCADE;

DO $$ BEGIN
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'check_ins') THEN
    ALTER TABLE check_ins ADD CONSTRAINT check_ins_circle_id_fkey FOREIGN KEY (circle_id) REFERENCES circles(id) ON DELETE CASCADE;
  END IF;
  
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'kindness_streaks') THEN
    ALTER TABLE kindness_streaks ADD CONSTRAINT kindness_streaks_circle_id_fkey FOREIGN KEY (circle_id) REFERENCES circles(id) ON DELETE CASCADE;
  END IF;
  
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'digital_hugs') THEN
    ALTER TABLE digital_hugs ADD CONSTRAINT digital_hugs_circle_id_fkey FOREIGN KEY (circle_id) REFERENCES circles(id) ON DELETE CASCADE;
  END IF;
  
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'shared_playlists') THEN
    ALTER TABLE shared_playlists ADD CONSTRAINT shared_playlists_circle_id_fkey FOREIGN KEY (circle_id) REFERENCES circles(id) ON DELETE CASCADE;
  END IF;
  
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'messages') THEN
    ALTER TABLE messages ADD CONSTRAINT messages_circle_id_fkey FOREIGN KEY (circle_id) REFERENCES circles(id) ON DELETE CASCADE;
  END IF;
END $$;