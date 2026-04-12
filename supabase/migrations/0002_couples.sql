-- 0002_couples.sql

-- Add Space to Breathe columns to couple_bubble
ALTER TABLE couple_bubble 
ADD COLUMN space_to_breathe_active BOOLEAN DEFAULT false,
ADD COLUMN space_to_breathe_until TIMESTAMPTZ,
ADD COLUMN space_to_breathe_by UUID REFERENCES profiles(id);

-- relationship_milestones
CREATE TABLE IF NOT EXISTS relationship_milestones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id) ON DELETE CASCADE,
    event_date DATE NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    category TEXT DEFAULT 'manual', -- 'auto' | 'manual'
    created_at TIMESTAMPTZ DEFAULT now()
);

-- private_gallery
CREATE TABLE IF NOT EXISTS private_gallery (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID REFERENCES circles(id) ON DELETE CASCADE,
    uploaded_by UUID REFERENCES profiles(id),
    storage_path TEXT NOT NULL,
    caption TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- RLS Policies
ALTER TABLE relationship_milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE private_gallery ENABLE ROW LEVEL SECURITY;

CREATE POLICY "read_milestones" ON relationship_milestones FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM circle_members
    WHERE circle_id = relationship_milestones.circle_id
    AND user_id = auth.uid()
  )
);

CREATE POLICY "insert_milestones" ON relationship_milestones FOR INSERT WITH CHECK (
  EXISTS (
    SELECT 1 FROM circle_members
    WHERE circle_id = circle_id
    AND user_id = auth.uid()
  )
);

CREATE POLICY "read_private_gallery" ON private_gallery FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM circle_members
    WHERE circle_id = private_gallery.circle_id
    AND user_id = auth.uid()
  )
);

CREATE POLICY "insert_private_gallery" ON private_gallery FOR INSERT WITH CHECK (
  EXISTS (
    SELECT 1 FROM circle_members
    WHERE circle_id = circle_id
    AND user_id = auth.uid()
  )
);
