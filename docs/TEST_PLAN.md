# Test Plan

## Core Success Scenario (manual walkthrough)
1. Open live URL as a logged-out stranger → homepage loads with 4 script cards
2. Confirm cards show prospect name, company, stage badge, script body snippet
3. Click **Generate New Script**
4. Fill form: name=`Test Lead`, company=`Acme`, stage=`MQL`, pain_points=`low pipeline`, fit_notes=`50 reps`
5. Click **Generate**
6. Loading spinner appears immediately
7. Within 10 s: script output screen renders with generated body and Copy button
8. Click **Copy** → paste into a text editor → confirm full script text present
9. Navigate to `/scripts` history → new script appears at top of list
10. Confirm row exists in Supabase `scripts` table with correct `lead_id` and `stage`
11. Confirm row exists in `audit_logs` with `action=generate_script`

**Pass:** all 11 steps complete without error.

---

## Empty State
- Delete all scripts rows in Supabase → reload `/scripts` → empty state message renders (not a blank page)

## Error States
- Set `OPENAI_API_KEY` to an invalid value → submit form → error banner appears with retry option; no script row inserted; `generate_script_failed` written to audit_logs
- Submit form with all fields blank → client-side validation blocks submission; no API call made

## Data Persistence
- Generate a script → hard-refresh the page → script still appears (server-fetched, not localStorage)

## AI Field Integrity
- Every generated script row has non-null `script_body_source`, numeric `script_body_confidence`, and `script_body_review_status = 'unreviewed'`

## Security Smoke Test
- Open browser DevTools → confirm no `OPENAI_API_KEY` or `SUPABASE_SERVICE_ROLE_KEY` present in any network response or JS bundle
- Submit `pain_points` = `"); DROP TABLE leads; --` → confirm script generates normally, no DB error, value stored as plain text
