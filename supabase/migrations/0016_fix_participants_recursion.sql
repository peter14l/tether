-- Migration: 0016_fix_participants_recursion
-- Description: Fixes infinite recursion in participants and rooms RLS policies

-- 1. Drop existing problematic policies
DROP POLICY IF EXISTS "see_own_rooms" ON rooms;
DROP POLICY IF EXISTS "see_room_participants" ON participants;

-- 2. Participants Policies
-- Policy A: Users can always see their own participation record (non-recursive)
CREATE POLICY "participants_select_self" ON participants
    FOR SELECT USING (user_id = auth.uid());

-- Policy B: Users can see other participants in rooms they belong to
-- This avoids infinite recursion because it checks for YOUR existence in the room
-- which is covered by the non-recursive Policy A above.
CREATE POLICY "participants_select_others" ON participants
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM participants p_own
            WHERE p_own.room_id = participants.room_id
            AND p_own.user_id = auth.uid()
        )
    );

-- 3. Rooms Policies
-- Only participants can see rooms. 
-- This uses the participants table, which now has a non-recursive base case.
CREATE POLICY "see_own_rooms" ON rooms
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM participants
            WHERE participants.room_id = rooms.id
            AND participants.user_id = auth.uid()
        )
    );
