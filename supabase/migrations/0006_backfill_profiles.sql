-- Backfill missing profiles for existing users
-- This script finds users in auth.users who do not have a row in public.profiles
-- and creates a profile for them using their metadata or email.

INSERT INTO public.profiles (id, username, display_name, created_at, updated_at)
SELECT 
    id, 
    -- Try to get username from metadata, fallback to email prefix
    COALESCE(
      raw_user_meta_data->>'username', 
      split_part(email, '@', 1)
    ), 
    -- Try to get display_name from metadata, fallback to email prefix
    COALESCE(
      raw_user_meta_data->>'display_name', 
      split_part(email, '@', 1)
    ),
    created_at,
    updated_at
FROM auth.users
WHERE id NOT IN (SELECT id FROM public.profiles)
ON CONFLICT (id) DO NOTHING;
