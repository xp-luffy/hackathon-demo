# Agentic Layer

## Risk Classification

| Action | Risk | Handling |
|---|---|---|
| Auto-tag appointment reason | Low | Auto — no approval |
| Summarise visit note (AI) | Low | Auto-draft, `review_status = unreviewed` |
| Flag low-stock item | Low | Auto on quantity save |
| Create draft reorder request | Medium | Staff approval before sending |
| Send SMS reminder to patient | Medium | Staff approval |
| Cancel all appointments at a branch | High | Admin approval + confirmation dialog |
| Delete patient record | Critical | Human-only, cannot be triggered by agent |
| Bulk-delete or data export with PII | Critical | Human-only |

## Named Tools (approved list)
- `summarise_visit_note(note_id)` — calls LLM, writes `ai_summary` + source + confidence + `review_status = unreviewed`
- `flag_low_stock(item_id)` — DB update only, no external call
- `draft_reorder_request(item_id, quantity)` — creates a draft record for staff approval

## Approval Flow
`Draft → Staff reviews in UI → Approves → Action executes → audit_log written`

## Audit Log Fields (every agent action)
```
actor_staff_id, action, table_name, record_id,
old_values (jsonb), new_values (jsonb), branch_id, created_at
```

## v1 vs Later
- **v1:** low-risk auto-flags only (low_stock, no_show rule)
- **Next:** AI visit note summary with review UI
- **Later:** SMS reminders (medium risk, approval gate), reorder drafts
