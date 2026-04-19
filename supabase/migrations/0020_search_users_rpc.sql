-- Migration: 0020_search_users_rpc
-- Description: Adds a search_users RPC to allow user discovery without RLS issues

DROP FUNCTION IF EXISTS public.search_users(TEXT, UUID);

CREATE OR REPLACE FUNCTION public.search_users(search_query TEXT, current_user_id UUID)
RETURNS SETOF public.profiles AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM public.profiles
    WHERE (username ILIKE ('%' || search_query || '%') OR display_name ILIKE ('%' || search_query || '%'))
      AND id != current_user_id
    LIMIT 20;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
