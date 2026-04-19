-- Test Script for E2EE Messaging V2
-- This script verifies the schema and triggers manually in the database

DO $$
DECLARE
    test_user1 UUID := '00000000-0000-0000-0000-000000000001';
    test_user2 UUID := '00000000-0000-0000-0000-000000000002';
    test_room_id UUID;
BEGIN
    -- 1. Setup Mock Profiles if they don't exist
    INSERT INTO profiles (id, username, display_name)
    VALUES (test_user1, 'tester1', 'Tester One'), (test_user2, 'tester2', 'Tester Two')
    ON CONFLICT (id) DO NOTHING;

    -- 2. Create a Room
    INSERT INTO rooms (name, is_group, created_by)
    VALUES ('Test Room', false, test_user1)
    RETURNING id INTO test_room_id;

    -- 3. Add Participants
    INSERT INTO participants (room_id, user_id)
    VALUES (test_room_id, test_user1), (test_room_id, test_user2);

    -- 4. Insert a Message (This should trigger on_new_message_v2_notify)
    INSERT INTO messages (room_id, sender_id, message_type, encrypted_text)
    VALUES (test_room_id, test_user1, 'text', '{"e2ee": true, "ciphertext": "mock_data"}');

    RAISE NOTICE 'Test data inserted successfully for room %', test_room_id;
END $$;

-- Check the results
SELECT * FROM rooms WHERE name = 'Test Room';
SELECT * FROM participants WHERE room_id = (SELECT id FROM rooms WHERE name = 'Test Room');
SELECT * FROM messages WHERE room_id = (SELECT id FROM rooms WHERE name = 'Test Room');
