# Data Model

## leads
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | gen_random_uuid() |
| user_id | uuid nullable | owner-scoping at lock-down |
| created_at | timestamptz | default now() |
| prospect_name | text | |
| company | text | |
| stage | text | CHECK IN ('MQL','SQL') |
| pain_points | text | free text from form |
| fit_notes | text | free text from form |

## scripts
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| created_at | timestamptz | |
| lead_id | uuid FK → leads.id | cascade delete |
| stage | text | MQL or SQL |
| script_body | text | **AI-generated** |
| script_body_source | text | e.g. `openai/gpt-4o` |
| script_body_confidence | numeric | 0–1, from model logprobs or heuristic |
| script_body_review_status | text | `unreviewed` / `approved` / `rejected` |
| version | integer | increments on regenerate |

## audit_logs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| created_at | timestamptz | |
| action | text | e.g. `generate_script`, `edit_script` |
| object_type | text | `lead`, `script` |
| object_id | uuid | row affected |
| meta | jsonb | extra context (stage, version) |

## RLS
- All tables: v1 permissive policies (select + all) — open for demo
- Sprint 3: replace with `auth.uid() = user_id` owner policies

## Relationships
`scripts.lead_id → leads.id` (many scripts per lead, cascade delete)
