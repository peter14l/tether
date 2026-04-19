-- Create the avatars bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- Set up RLS policies for the avatars bucket
-- 1. Allow public access to view avatars
CREATE POLICY "Avatar public access"
  ON storage.objects FOR SELECT
  USING ( bucket_id = 'avatars' );

-- 2. Allow authenticated users to upload an avatar (matching the uid_timestamp.ext pattern)
CREATE POLICY "Avatar upload"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars' AND
    name LIKE (auth.uid()::text || '_%')
  );

-- 3. Allow authenticated users to update their own avatar
CREATE POLICY "Avatar update"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars' AND
    name LIKE (auth.uid()::text || '_%')
  );

-- 4. Allow authenticated users to delete their own avatar
CREATE POLICY "Avatar delete"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars' AND
    name LIKE (auth.uid()::text || '_%')
  );
