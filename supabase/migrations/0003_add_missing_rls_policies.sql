-- Add missing RLS policies for profiles table

-- Allow users to insert their own profile
CREATE POLICY "Users can insert their own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Allow users to update their own profile
CREATE POLICY "Users can update their own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Allow users to select their own profile (in addition to existing circle-based policy)
CREATE POLICY "Users can select their own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

-- Ensure authenticated users can see other profiles if they are in the same circle (redundant but explicit)
-- The existing "read_shared_circle_profiles" already handles this.

-- Add policies for circles (allow creation)
CREATE POLICY "Users can create circles" ON circles
  FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update their own circles" ON circles
  FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Users can select circles they are members of" ON circles
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM circle_members
      WHERE circle_id = circles.id
      AND user_id = auth.uid()
    )
    OR created_by = auth.uid()
  );

-- Add policies for circle_members
CREATE POLICY "Users can join circles" ON circle_members
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can see members of their circles" ON circle_members
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM circle_members AS cm
      WHERE cm.circle_id = circle_members.circle_id
      AND cm.user_id = auth.uid()
    )
  );

-- Add policies for posts (allow creation)
CREATE POLICY "Users can create posts in their circles" ON posts
  FOR INSERT WITH CHECK (
    auth.uid() = author_id
    AND EXISTS (
      SELECT 1 FROM circle_members
      WHERE circle_id = posts.circle_id
      AND user_id = auth.uid()
    )
  );
