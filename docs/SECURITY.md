# Security

## Secret Handling
- All Supabase keys in environment variables (`.env.local`), never in client bundle
- `SUPABASE_SERVICE_ROLE_KEY` used only in server-side API routes, never exposed to browser
- LLM API keys server-side only

## Permission Model
| Role | Appointments | Clinical Notes | Inventory | Rota | Dashboard | Admin |
|---|---|---|---|---|---|---|
| Receptionist | R/W | — | R | R | R | — |
| Nurse | R/W | R | R/W | R | R | — |
| Doctor | R/W | R/W | R | R | R | — |
| Admin | R/W | R/W | R/W | R/W | R/W | R/W |

- v1 (demo): open RLS policies
- Lock-down sprint: `auth.uid() = staff.user_id` + role column checked in API routes

## Approved Tools Rule
- Agent may only call named tools from `docs/AGENTIC_LAYER.md`
- No `run_any`, `exec`, or raw SQL from agent context
- Every tool call writes to `audit_logs` before returning

## Audit Principle
- Every create / update / delete on core tables writes a row to `audit_logs` with `old_values` and `new_values`
- `audit_logs` is append-only; no update/delete policies granted

## What Cannot Be Verified Without a Full Pentest
- Rate-limiting effectiveness under load
- All injection vectors in free-text note fields
- PII data-at-rest encryption beyond Supabase defaults

> If deploying with real patient data: stop and engage a qualified security reviewer before go-live.
