# Tasks & Sprints

## Sprint 1 — DB + Core Booking Engine
**Goal:** Appointments CRUD works end-to-end against the live DB. Viewable without login.

- [ ] Apply migration SQL to Supabase project
- [ ] Verify seed data loads on first visit (3 branches, 6 staff, 6 patients, 6 appointments)
- [ ] `/appointments` page: list all appointments, all branches, sorted by `appointment_at`
- [ ] Handle loading spinner, empty state ("No appointments yet"), and fetch error states
- [ ] `/appointments/new` form: branch selector, patient search, doctor picker, date/time, reason
- [ ] Form submits → inserts into `appointments` + writes `audit_logs` row
- [ ] Edit appointment (status, time, doctor) → updates DB + audit log
- [ ] Cancel appointment → sets `status = 'cancelled'` + audit log
- [ ] Redirect + list re-fetch after any mutation

**Definition of Done:** Create a new appointment in the form → it appears in the list → `audit_logs` has one row for the action. No login required.

---

## Sprint 2 — Patient Records + Visit History
**Goal:** Patient records and clinical notes work end-to-end.

- [ ] `/patients` list: name, DOB, primary branch, search by name
- [ ] `/patients/[id]` detail: demographics + chronological appointment list
- [ ] Visit history shows reason, date, doctor, status for each appointment
- [ ] "Add note" button on each completed appointment → opens note form
- [ ] Note form submits → inserts `visit_notes` row + audit log
- [ ] Notes display under the visit in chronological order
- [ ] All five UI states on each page

**Definition of Done:** Open a patient, add a note to a visit, refresh → note persists.

---

## Sprint 3 — Inventory + Shift Rota
**Goal:** Stock tracking and rota assignment work end-to-end.

- [ ] `/inventory` page: items grouped by branch, quantity, unit, low-stock badge
- [ ] Adjust quantity form: +/- input → updates `quantity`, recalculates `low_stock` flag
- [ ] Low-stock items visually highlighted; `low_stock = true` when `quantity < reorder_threshold`
- [ ] `/rota` page: weekly grid view per branch, staff shifts shown per day
- [ ] Assign shift form: staff picker, date, start/end time → inserts `shifts` row
- [ ] Edit / delete shift → updates DB + audit log
- [ ] All five UI states on each page

**Definition of Done:** Reduce item below threshold → low-stock badge appears. Assign shift → shows in weekly grid.

---

## Sprint 4 — Ops Dashboard ✅ v1 functional milestone
**Goal:** Live ops dashboard; no-show marking works.

- [ ] `/dashboard` as homepage: today's bookings count, no-shows count, low-stock alerts list
- [ ] Branch-by-branch breakdown table on dashboard
- [ ] "Mark no-show" button on appointment row → sets `no_show = true`, `status` stays `scheduled` → audit log
- [ ] Dashboard counters refresh on load from DB (no stale state)
- [ ] All five UI states on each dashboard widget
- [ ] Walk the full success scenario end-to-end (see PRD)

**Definition of Done:** Mark appointment no-show → dashboard no-show counter increments on next load. Full PRD success scenario passes.

---

## Sprint 5 — Auth + Role-Based Access (Lock it down)
**Goal:** Staff log in; screens gated by role; RLS enforced.

- [ ] Supabase Auth: email/password sign-up and login pages
- [ ] `staff.user_id` populated on login; RLS policies updated to `auth.uid() = user_id`
- [ ] Middleware redirects unauthenticated users to `/login`
- [ ] Role gates: receptionist hides clinical notes tab; doctor shows it
- [ ] Admin-only: branch management, staff management
- [ ] Confirm `audit_logs` captures `actor_staff_id` from authenticated session

**Definition of Done:** Login as receptionist → clinical notes hidden. Login as doctor → visible. Logout → redirected to `/login`.

---

## Sprint 6 — Reliability Hardening
**Goal:** Production-ready quality pass.

- [ ] Add DB constraints: NOT NULL on required fields, CHECK on status enums
- [ ] `audit_logs` has no update/delete RLS policy (append-only)
- [ ] Run `npm audit`; resolve critical/high vulnerabilities
- [ ] Verify no `SUPABASE_SERVICE_ROLE_KEY` in client bundle (`NEXT_PUBLIC_` prefix check)
- [ ] Rate-limit `/api/auth/*` endpoints
- [ ] Walk full `TEST_PLAN.md` manually on staging URL
- [ ] All test steps documented as pass/fail

**Definition of Done:** All TEST_PLAN steps pass. `npm audit` shows 0 critical. No secrets in client bundle.

---

## Gantt
```
Sprint 1  [DB + Booking]      ████
Sprint 2  [Patients]              ████
Sprint 3  [Inventory + Rota]          ████
Sprint 4  [Dashboard] ← v1          ████
Sprint 5  [Auth + Lock-down]              ████
Sprint 6  [Hardening]                         ████
```
