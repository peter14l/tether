-- Migration: 0017_fix_recursion_final
-- Description: Uses SECURITY DEFINER functions to break circular dependencies in RLS

-- 1. Helper function to check room participation without triggering RLS recursion
CREATE OR REPLACE FUNCTION public.is_room_member(p_room_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.participants
    WHERE room_id = p_room_id
    AND user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Drop all previous problematic policies
DROP POLICY IF EXISTS "see_own_rooms" ON rooms;
DROP POLICY IF EXISTS "participants_select_self" ON participants;
DROP POLICY IF EXISTS "participants_select_others" ON participants;
DROP POLICY IF EXISTS "see_room_participants" ON participants;
DROP POLICY IF EXISTS "see_room_messages" ON messages;
DROP POLICY IF EXISTS "insert_room_messages" ON messages;

-- 3. Simplified Participants Policy
-- A user can see any participant record if they themselves are a member of that room.
-- This calls is_room_member() which bypasses RLS for its internal check.
CREATE POLICY "select_participants" ON participants
    FOR SELECT USING (public.is_room_member(room_id));

-- 4. Simplified Rooms Policy
-- A user can see a room if they are a member of it.
CREATE POLICY "select_rooms" ON rooms
    FOR SELECT USING (public.is_room_member(id));

-- 5. Simplified Messages Policy
-- A user can see/insert messages if they are a member of the room.
CREATE POLICY "select_messages" ON messages
    FOR SELECT USING (public.is_room_member(room_id));

CREATE POLICY "insert_messages" ON messages
    FOR INSERT WITH CHECK (
        sender_id = auth.uid() AND
        public.is_room_member(room_id)
    );
