# Security

## Secret Handling
- `OPENAI_API_KEY` and `SUPABASE_SERVICE_ROLE_KEY` live in Vercel environment variables only
- Never referenced in any client-side file; only accessed inside `/api/*` server routes
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` and `NEXT_PUBLIC_SUPABASE_URL` are the only values exposed to the browser — both are safe by design (protected by RLS)

## Permission Model (v1 — demo open)
- All tables use permissive RLS: any visitor can read and write
- Acceptable for demo-only; no real user PII stored in v1
- Sprint 3 replaces all policies with `auth.uid() = user_id` — each user sees only their own rows

## Approved Tools Rule
- The generation API route calls `openai_chat_completion` only via a fixed server-side prompt template
- No client input reaches the model without sanitisation — pain_points and fit_notes are truncated to 500 chars and stripped of injection patterns before interpolation
- No `run_any` / `eval` / raw shell execution permitted

## Audit Principle
- Every `generate`, `edit`, and `regenerate` action writes a row to `audit_logs` before returning to the client
- Failures also log with `action=generate_script_failed` and error meta

## What Cannot Be Fully Verified Pre-Launch
- Prompt injection via adversarial `pain_points` input (mitigated by truncation; full red-team not done in v1 — flag before onboarding real users)
- Rate-limiting on `/api/generate` (add Vercel Edge middleware in Sprint 3)
