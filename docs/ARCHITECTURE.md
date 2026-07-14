# Architecture

## Stack
- **Frontend:** Next.js 14 (App Router) on Vercel
- **Database + Auth:** Supabase (Postgres, RLS, Auth)
- **Styling:** Tailwind CSS
- **State:** React Server Components + `@supabase/ssr` for data fetching

## Build Sequence
| Phase | What ships |
|---|---|
| Now | DB schema, seed data, appointments CRUD, patient records, inventory, rota, dashboard — no login wall |
| Next | Supabase Auth, role-based access, RLS owner policies |
| Later | SMS reminders, AI slot suggestions, supplier reorder, report exports |

## Key User Action — Cross-Branch Appointment Booking
1. Receptionist opens `/appointments/new`
2. Selects branch, searches for patient, picks doctor and time slot
3. Form POST hits `/api/appointments` → validates fields server-side
4. Row inserted into `appointments` with `status = 'scheduled'`
5. Audit log row written (`action = 'create'`, `table_name = 'appointments'`)
6. UI redirects to appointment detail; appointments list re-fetches and shows new row
7. Ops dashboard counter increments on next load

## Layer Plan
1. **Data layer** — Postgres tables with constraints and RLS policies (source of truth)
2. **App logic** — Next.js API routes enforce business rules (status transitions, low-stock recalc)
3. **Smart features** — AI summary of visit notes added later; core runs without it

## Core Without AI
All CRUD, dashboard counters, no-show flags, and low-stock alerts are computed from DB queries. Removing the AI layer leaves a fully functional operations tool.
