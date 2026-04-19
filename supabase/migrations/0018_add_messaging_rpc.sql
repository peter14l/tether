-- Migration: 0018_add_messaging_rpc
-- Description: Adds RPC function to get or create a 1:1 messaging room

CREATE OR REPLACE FUNCTION public.get_or_create_1to1_room(user1_id UUID, user2_id UUID)
RETURNS UUID AS $$
DECLARE
    found_room_id UUID;
BEGIN
    -- 1. Try to find an existing 1:1 room between these two users
    SELECT p1.room_id INTO found_room_id
    FROM public.participants p1
    JOIN public.participants p2 ON p1.room_id = p2.room_id
    JOIN public.rooms r ON p1.room_id = r.id
    WHERE p1.user_id = user1_id
      AND p2.user_id = user2_id
      AND r.is_group = false
    LIMIT 1;

    -- 2. If no room exists, create a new one
    IF found_room_id IS NULL THEN
        -- Create room
        INSERT INTO public.rooms (is_group, created_by)
        VALUES (false, user1_id)
        RETURNING id INTO found_room_id;

        -- Add participants
        INSERT INTO public.participants (room_id, user_id)
        VALUES (found_room_id, user1_id), (found_room_id, user2_id);
    END IF;

    RETURN found_room_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
