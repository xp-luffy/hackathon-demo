# Test Plan

## Success Scenario (walk this after Sprint 4)
1. Open app URL in an incognito window (no login)
2. **Expect:** Dashboard loads with today's bookings count, no-show count, low-stock alerts — not a login page
3. Click **New Appointment**
4. Select "Southside Clinic", search for "Tom Gallagher", pick Dr. Ciara Walsh, set time 2 hours from now, reason "Follow-up"
5. Submit → **Expect:** redirected to appointments list; new row appears at top
6. Open `audit_logs` in Supabase dashboard → **Expect:** one row with `action = 'create'`, `table_name = 'appointments'`
7. Click **Mark No-Show** on the new appointment → **Expect:** `no_show = true` in DB; dashboard no-show counter increments
8. Open patient "Tom Gallagher" → Visit History shows the appointment
9. Click **Add Note** → type a note → submit → refresh → note persists

## Empty State Tests
- Delete all seed appointments → `/appointments` shows "No appointments booked yet" message
- Set all inventory quantities above threshold → low-stock section on dashboard shows "All stock levels OK"
- No shifts assigned for a branch → rota grid shows empty day cells, not a blank crash

## Error State Tests
- Submit appointment form with no patient selected → inline validation error, no DB write
- Submit note form with empty text → inline error, no DB write
- Simulate DB unavailable (disable Supabase row) → pages show "Unable to load data. Please refresh." not a white screen

## Inventory Test
- Adjust item "Disposable Gloves" at Northside from 8 to 5 (below threshold 10) → `low_stock = true`, badge appears
- Adjust back to 15 → `low_stock = false`, badge removed

## Rota Test
- Assign Dr. Aoife Murphy a shift on tomorrow's date at Northside 09:00–17:00
- Open rota weekly grid → shift appears in correct cell
- Delete shift → cell clears

## Audit Log Test
- After each create/edit/cancel/no-show action above, check `audit_logs` in Supabase
- **Expect:** one row per action with correct `action`, `table_name`, `record_id`, and non-null `new_values`

## Post-Sprint 5 Auth Tests
- Log in as receptionist → `/patients/[id]` shows no "Add Note" button
- Log in as doctor → "Add Note" button visible
- Log out → `GET /appointments` returns 0 rows (RLS blocks unauthenticated reads)
