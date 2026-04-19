-- 0010_e2ee_messaging.sql

CREATE TABLE IF NOT EXISTS user_keypairs (
    user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
    public_key TEXT NOT NULL,
    encrypted_private_key TEXT NOT NULL, -- Encrypted with the user's master AES key
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE user_keypairs ENABLE ROW LEVEL SECURITY;

-- Anyone in a shared circle or simply any authenticated user can read public keys
CREATE POLICY "read_public_keys" ON user_keypairs FOR SELECT USING (auth.role() = 'authenticated');

-- Users can insert/update their own keypairs
CREATE POLICY "insert_own_keypair" ON user_keypairs FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "update_own_keypair" ON user_keypairs FOR UPDATE USING (user_id = auth.uid());
