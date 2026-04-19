-- 0012_fix_missing_columns.sql

-- Add missing columns to posts table
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'posts' AND column_name = 'circle_id') THEN
        ALTER TABLE posts ADD COLUMN circle_id UUID REFERENCES circles(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add missing columns to messages table
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'messages' AND column_name = 'receiver_id') THEN
        ALTER TABLE messages ADD COLUMN receiver_id UUID REFERENCES profiles(id);
    END IF;
END $$;

-- Add missing columns to circles table
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'circles' AND column_name = 'circle_type') THEN
        ALTER TABLE circles ADD COLUMN circle_type TEXT NOT NULL DEFAULT 'friends';
    END IF;
END $$;

-- Ensure RLS policies use the correct columns
DROP POLICY IF EXISTS "read_circle_posts" ON posts;
CREATE POLICY "read_circle_posts" ON posts FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM circle_members
    WHERE circle_id = posts.circle_id
    AND user_id = auth.uid()
  )
);

DROP POLICY IF EXISTS "read_own_messages" ON messages;
CREATE POLICY "read_own_messages" ON messages FOR SELECT USING (
  sender_id = auth.uid() OR receiver_id = auth.uid()
);
