-- Migration: 0020_search_users_rpc
-- Description: Adds a search_users RPC to allow user discovery without RLS issues

CREATE OR REPLACE FUNCTION public.search_users(search_query TEXT, current_user_id UUID)
RETURNS TABLE (
    id UUID,
    username TEXT,
    display_name TEXT,
    avatar_url TEXT,
    bio TEXT,
    pronouns TEXT,
    mood_status TEXT,
    is_quiet BOOLEAN,
    quiet_until TIMESTAMPTZ,
    timezone TEXT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id, 
        p.username, 
        p.display_name, 
        p.avatar_url, 
        p.bio, 
        p.pronouns, 
        p.mood_status, 
        p.is_quiet, 
        p.quiet_until, 
        p.timezone, 
        p.created_at, 
        p.updated_at
    FROM public.profiles p
    WHERE (p.username ILIKE '%' || search_query || '%' OR p.display_name ILIKE '%' || search_query || '%')
      AND p.id != current_user_id
    LIMIT 20;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
