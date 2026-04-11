-- ============================================================
-- THE LEAGUE HUB — SUPABASE SETUP
-- Run this entire file in: Supabase → SQL Editor → New Query
-- ============================================================

-- 1. CHAMPIONS TABLE
create table if not exists champions (
  id uuid default gen_random_uuid() primary key,
  year integer not null,
  league_id text not null,
  champion_name text not null,
  team_name text,
  record text,
  championship_score text,
  added_by uuid references auth.users(id),
  created_at timestamptz default now()
);

alter table champions enable row level security;

-- Anyone logged in can read champions
create policy "Champions are public" on champions
  for select using (true);

-- Only authenticated users can insert
create policy "Auth users can add champions" on champions
  for insert with check (auth.role() = 'authenticated');


-- 2. DRAFT PHOTOS TABLE
create table if not exists draft_photos (
  id uuid default gen_random_uuid() primary key,
  storage_path text not null,
  league_id text not null,
  year integer,
  caption text,
  uploaded_by uuid references auth.users(id),
  created_at timestamptz default now()
);

alter table draft_photos enable row level security;

-- Anyone can view photos
create policy "Photos are public" on draft_photos
  for select using (true);

-- Only authenticated users can upload
create policy "Auth users can upload photos" on draft_photos
  for insert with check (auth.role() = 'authenticated');


-- 3. PROSPECT APPLICATIONS TABLE
create table if not exists prospect_applications (
  id uuid default gen_random_uuid() primary key,
  first_name text not null,
  last_name text not null,
  email text not null,
  discord text,
  experience text,
  leagues_interested text[],
  message text,
  referred_by text,
  status text default 'pending',
  created_at timestamptz default now()
);

alter table prospect_applications enable row level security;

-- Anyone can submit an application (no auth required)
create policy "Anyone can submit application" on prospect_applications
  for insert with check (true);

-- Only authenticated users can read applications (admins)
create policy "Auth users can view applications" on prospect_applications
  for select using (auth.role() = 'authenticated');


-- ============================================================
-- STORAGE BUCKET SETUP
-- Do this in Supabase → Storage → New Bucket
-- ============================================================
-- Bucket name: draft-photos
-- Public bucket: YES (toggle on)
-- After creating the bucket, add this policy in Storage → Policies:
--
--   Policy name: "Anyone can view photos"
--   For: SELECT
--   Target roles: public
--   Policy: true
--
--   Policy name: "Auth users can upload"
--   For: INSERT
--   Target roles: authenticated
--   Policy: true
-- ============================================================

-- ============================================================
-- UPDATE (run this if you already ran the setup above)
-- Adds award_type column to champions table
-- ============================================================
alter table champions add column if not exists award_type text default 'superbowl';

-- Allow authenticated users to delete champions (enforced in app by admin check)
create policy "Auth users can delete champions" on champions
  for delete using (auth.role() = 'authenticated');

-- Allow authenticated users to delete photos (enforced in app by admin check)
create policy "Auth users can delete photos" on draft_photos
  for delete using (auth.role() = 'authenticated');
