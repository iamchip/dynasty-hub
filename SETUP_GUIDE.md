# The League Hub — Setup Guide

## Files
- `index.html` — The complete website (open locally or deploy to Netlify/Vercel)
- `SUPABASE_SETUP.sql` — Run this in Supabase to create all tables
- `TCL_Icon.png`, `TDL_Icon.png`, `TSL_Icon.png` — League logos

---

## Step 1 — Run the Database Setup

1. Go to **supabase.com** → your project
2. Click **SQL Editor** → **New Query**
3. Paste the contents of `SUPABASE_SETUP.sql` and click **Run**

---

## Step 2 — Create the Storage Bucket

1. Go to **Storage** → **New Bucket**
2. Name it exactly: `draft-photos`
3. Toggle **Public bucket: ON**
4. Click **Create**
5. Go to **Storage → Policies** and add:
   - INSERT policy for `authenticated` role → `true`
   - SELECT policy for `public` → `true`

---

## Step 3 — Enable Discord Auth in Supabase

1. Go to **Authentication → Providers → Discord**
2. Toggle **Discord ON**
3. Enter:
   - **Client ID:** `1492250793045135512`
   - **Client Secret:** (from discord.com/developers → your app → OAuth2)
4. Copy the **Callback URL** shown in Supabase
5. Go back to **Discord Developer Portal → your app → OAuth2**
6. Paste that callback URL into **Redirects**
7. Save

---

## Step 4 — Deploy the Site

### Option A: Netlify (easiest, free)
1. Go to netlify.com → **Add new site → Deploy manually**
2. Drag the entire `fantasy-hub` folder onto the deploy box
3. Done — you'll get a `.netlify.app` URL

### Option B: Vercel
1. Push the folder to a GitHub repo
2. Connect repo to vercel.com
3. Deploy

### Option C: Run locally
Just open `index.html` in a browser — Discord OAuth won't work locally
(it needs a real URL), but all UI will render.

---

## Discord OAuth Redirect URL

When deploying, go to Discord Developer Portal and add your live site URL
to the OAuth2 Redirect URIs list. Also update the `redirectTo` value
in `index.html` if needed (it currently uses `window.location.href`).

---

## Adding a Custom Domain (Optional)
Both Netlify and Vercel let you add a custom domain for free.
Then add that domain to Discord OAuth2 Redirects.
