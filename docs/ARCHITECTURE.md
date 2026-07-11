# Architecture

## Stack
- **Frontend:** Next.js 14 (App Router) — Vercel-deployed
- **Database:** Supabase (Postgres + RLS)
- **AI:** OpenAI GPT-4o via server-side API route
- **Styling:** Tailwind CSS

## Now vs Later
**Now:** lead form → script generation → script display → history list
**Later:** auth + per-user isolation, regenerate/versioning UI, email send, team workspace

## Key User Action — Step by Step
1. Visitor lands on `/` — seeded demo scripts render from Supabase (no login)
2. Visitor fills qualifier form and clicks **Generate Script**
3. Next.js API route (`/api/generate`) receives form data
4. Server composes a prompt; calls OpenAI GPT-4o with the lead context
5. Response streamed back; script row inserted into `scripts` table with `confidence`, `source`, `review_status`
6. Lead row inserted into `leads` table
7. Audit log row written: `action=generate_script`
8. Script output screen renders — copy-to-clipboard active

## Layer Plan
1. **Data first** — tables, RLS, seed rows (Sprint 1)
2. **App logic** — form → API → insert → display (Sprint 1)
3. **Smart features** — confidence scoring, regenerate, inline review (Sprint 2)
4. **Auth + isolation** — lock-down sprint only after demo works (Sprint 3)

## Core Without AI
If the OpenAI call fails, the app shows a clear error and lets the user retry. Leads persist regardless. Manually written scripts can be inserted directly — the DB and UI work independently of the AI.
