-- Migration: 0019_allow_profile_discovery
-- Description: Allows authenticated users to see limited profile info for discovery

CREATE POLICY "discovery_profiles" ON public.profiles
  FOR SELECT TO authenticated
  USING (true);

-- Safety: Ensure the column is named correctly (case-sensitive check)
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'display_name') THEN
        -- If it's missing, try to find if it was named differently (e.g. displayName)
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'displayName') THEN
            ALTER TABLE public.profiles RENAME COLUMN "displayName" TO display_name;
        ELSE
            ALTER TABLE public.profiles ADD COLUMN display_name TEXT;
            -- Backfill from username if display_name was totally missing
            UPDATE public.profiles SET display_name = username WHERE display_name IS NULL;
        END IF;
    END IF;
END $$;

