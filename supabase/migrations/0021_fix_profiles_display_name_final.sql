-- Migration: 0021_fix_profiles_display_name_final
-- Description: Aggressively ensures display_name column exists and is accessible

DO $$ 
BEGIN 
    -- 1. Check if the column exists in any case variation
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND lower(column_name) = 'display_name') THEN
        ALTER TABLE public.profiles ADD COLUMN display_name TEXT;
        UPDATE public.profiles SET display_name = username WHERE display_name IS NULL;
    END IF;

    -- 2. If it exists but is named exactly "displayName" (common mapping error), rename it
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'displayName') THEN
        ALTER TABLE public.profiles RENAME COLUMN "displayName" TO display_name;
    END IF;

    -- 3. Ensure it's not null to match the schema
    ALTER TABLE public.profiles ALTER COLUMN display_name SET NOT NULL;
END $$;

-- 4. Refresh the discovery policy
DROP POLICY IF EXISTS "discovery_profiles" ON public.profiles;
CREATE POLICY "discovery_profiles" ON public.profiles
  FOR SELECT TO authenticated
  USING (true);
