# Agentic Layer

## Risk Levels & Actions

### Low — Auto (no approval needed)
- **generate_script**: call OpenAI, insert script row, write audit log
- **tag_stage**: classify lead as MQL or SQL from form input
- **score_confidence**: apply rule-based confidence to new script

### Medium — Light approval (user confirms)
- **regenerate_script**: overwrite script body with new AI version (increments version, keeps prior)
- **edit_script**: inline edit saved to DB — user action IS the approval

### High — Always approval before executing *(v1: not built)*
- **send_script_by_email**: compose and dispatch via mail tool — requires explicit send confirmation

### Critical — Human only *(v1: not built)*
- **delete_lead**: permanent removal — confirmation dialog + audit entry required
- **bulk_export_PII**: export names/companies — manual only, logged

## Named Tools (v1)
- `openai_chat_completion` — script generation only; prompt template is server-side, never client-editable
- `supabase_insert` — leads, scripts, audit_logs
- `supabase_update` — script body (edit/regenerate)

## Audit Log Fields
`action`, `object_type`, `object_id`, `user_id`, `meta` (stage, version, confidence), `created_at`

## v1 vs Later
**v1:** generate + score + audit (auto-only actions)
**Later:** email send (high-risk, approval gate), delete with confirmation
