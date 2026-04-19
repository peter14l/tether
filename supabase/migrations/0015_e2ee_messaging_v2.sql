-- 0015_e2ee_messaging_v2.sql
-- Refactored E2EE Messaging with Rooms and Participants

-- Drop old messages table if it exists
DROP TABLE IF EXISTS messages CASCADE;

-- Rooms table
CREATE TABLE IF NOT EXISTS rooms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT, -- Null for 1:1, set for groups
    is_group BOOLEAN DEFAULT false,
    created_by UUID REFERENCES profiles(id),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Participants table
CREATE TABLE IF NOT EXISTS participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID REFERENCES rooms(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    last_read_at TIMESTAMPTZ DEFAULT now(),
    joined_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(room_id, user_id)
);

-- Messages table (E2EE + R2 Storage)
CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID REFERENCES rooms(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    message_type TEXT NOT NULL DEFAULT 'text', -- 'text', 'image', 'video', 'file'
    encrypted_text TEXT, -- AES-256 encrypted content
    r2_object_key TEXT, -- Cloudflare R2 key
    media_key TEXT, -- Encrypted AES key for the media file
    is_expired BOOLEAN DEFAULT false, -- To be toggled by a background job or logic if needed (lifecycle handles deletion)
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Indexing for performance
CREATE INDEX IF NOT EXISTS idx_messages_room_id ON messages(room_id);
CREATE INDEX IF NOT EXISTS idx_participants_user_id ON participants(user_id);
CREATE INDEX IF NOT EXISTS idx_participants_room_id ON participants(room_id);

-- Updated at trigger for rooms
CREATE TRIGGER update_rooms_updated_at BEFORE UPDATE ON rooms FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- RLS POLICIES

ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Rooms: Only participants can see rooms
CREATE POLICY "see_own_rooms" ON rooms FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM participants
        WHERE participants.room_id = rooms.id
        AND participants.user_id = auth.uid()
    )
);

-- Participants: Only participants can see other participants in the same room
CREATE POLICY "see_room_participants" ON participants FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM participants p2
        WHERE p2.room_id = participants.room_id
        AND p2.user_id = auth.uid()
    )
);

-- Messages: Only participants can see messages
CREATE POLICY "see_room_messages" ON messages FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM participants
        WHERE participants.room_id = messages.room_id
        AND participants.user_id = auth.uid()
    )
);

CREATE POLICY "insert_room_messages" ON messages FOR INSERT WITH CHECK (
    sender_id = auth.uid() AND
    EXISTS (
        SELECT 1 FROM participants
        WHERE participants.room_id = messages.room_id
        AND participants.user_id = auth.uid()
    )
);

-- Trigger for New Messages (V2)
CREATE OR REPLACE FUNCTION public.on_new_message_v2_notify()
RETURNS TRIGGER AS $$
DECLARE
  sender_name TEXT;
  target_user_ids UUID[];
  room_name TEXT;
  is_group_room BOOLEAN;
BEGIN
  -- Get sender name
  SELECT display_name INTO sender_name FROM profiles WHERE id = NEW.sender_id;
  
  -- Get room info
  SELECT name, is_group INTO room_name, is_group_room FROM rooms WHERE id = NEW.room_id;
  
  -- Get all participants except the sender
  SELECT array_agg(user_id) INTO target_user_ids
  FROM participants
  WHERE room_id = NEW.room_id AND user_id != NEW.sender_id;
  
  IF target_user_ids IS NOT NULL THEN
    PERFORM public.send_push_notification(
      target_user_ids,
      CASE WHEN is_group_room THEN room_name ELSE sender_name END,
      CASE 
        WHEN NEW.message_type = 'text' THEN 'New message'
        WHEN NEW.message_type = 'image' THEN '📷 Image'
        WHEN NEW.message_type = 'video' THEN '🎥 Video'
        WHEN NEW.message_type = 'file' THEN '📁 File'
        ELSE 'Sent you a message'
      END,
      jsonb_build_object(
        'sender_id', NEW.sender_id, 
        'room_id', NEW.room_id, 
        'message_id', NEW.id,
        'sender_name', sender_name,
        'is_group', is_group_room
      ),
      'chat'
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_on_new_message_notify ON messages;
CREATE TRIGGER trigger_on_new_message_notify
  AFTER INSERT ON messages
  FOR EACH ROW EXECUTE PROCEDURE public.on_new_message_v2_notify();
