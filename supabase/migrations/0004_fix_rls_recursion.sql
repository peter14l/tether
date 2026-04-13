-- Fix infinite recursion in circle_members RLS policies

-- Helper function to check circle membership safely (SECURITY DEFINER)
CREATE OR REPLACE FUNCTION is_member_of(_circle_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM circle_members
    WHERE circle_id = _circle_id
    AND user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 1. Fix circle_members SELECT policy
DROP POLICY IF EXISTS "Users can see members of their circles" ON circle_members;
CREATE POLICY "Users can see circle members" ON circle_members
  FOR SELECT USING (is_member_of(circle_id));

-- 2. Fix profiles SELECT policy
DROP POLICY IF EXISTS "read_shared_circle_profiles" ON profiles;
DROP POLICY IF EXISTS "Users can select their own profile" ON profiles;
CREATE POLICY "read_profiles_in_circle" ON profiles
  FOR SELECT USING (
    id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM circle_members
      WHERE user_id = profiles.id
      AND is_member_of(circle_id)
    )
  );

-- 3. Fix circles SELECT policy
DROP POLICY IF EXISTS "Users can select circles they are members of" ON circles;
CREATE POLICY "read_member_circles" ON circles
  FOR SELECT USING (is_member_of(id) OR created_by = auth.uid());

-- 4. Fix posts SELECT policy
DROP POLICY IF EXISTS "read_circle_posts" ON posts;
CREATE POLICY "read_circle_posts" ON posts
  FOR SELECT USING (is_member_of(circle_id));

-- 5. Fix posts INSERT policy
DROP POLICY IF EXISTS "Users can create posts in their circles" ON posts;
CREATE POLICY "insert_circle_posts" ON posts
  FOR INSERT WITH CHECK (
    auth.uid() = author_id AND
    is_member_of(circle_id)
  );
