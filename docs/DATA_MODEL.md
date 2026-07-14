# Data Model

## branches
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable, for lock-down |
| name | text NOT NULL | |
| address | text | |
| phone | text | |
| created_at | timestamptz | |

## staff
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable → maps to auth.uid() at lock-down |
| branch_id | uuid FK → branches | |
| full_name | text NOT NULL | |
| role | text NOT NULL | receptionist / nurse / doctor / admin |
| email | text | |
| is_active | boolean | |

## patients
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| full_name | text NOT NULL | |
| date_of_birth | date | |
| phone | text | |
| primary_branch_id | uuid FK → branches | |
| notes | text | |

## appointments
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| branch_id | uuid FK → branches | cross-branch booking |
| patient_id | uuid FK → patients | |
| doctor_id | uuid FK → staff | |
| appointment_at | timestamptz NOT NULL | |
| reason | text | |
| status | text | scheduled / completed / cancelled |
| no_show | boolean | |
| booked_by_id | uuid FK → staff | for audit |

## visit_notes
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| appointment_id | uuid FK → appointments | |
| patient_id | uuid FK → patients | |
| author_id | uuid FK → staff | |
| note_text | text NOT NULL | |
| ai_summary | text | AI field |
| ai_summary_source | text | e.g. 'gpt-4o' |
| ai_summary_confidence | numeric | 0–1 |
| ai_summary_review_status | text | unreviewed / approved / rejected |

## inventory_items
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| branch_id | uuid FK → branches | |
| item_name | text NOT NULL | |
| quantity | numeric | |
| unit | text | |
| reorder_threshold | numeric | |
| low_stock | boolean | set when quantity < reorder_threshold |
| last_adjusted_by | uuid FK → staff | |
| last_adjusted_at | timestamptz | |

## shifts
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| branch_id | uuid FK → branches | |
| staff_id | uuid FK → staff | |
| shift_date | date NOT NULL | |
| start_time | time NOT NULL | |
| end_time | time NOT NULL | |
| role_on_shift | text | |
| notes | text | |

## audit_logs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| actor_staff_id | uuid FK → staff | who made the change |
| action | text | create / update / delete / no_show |
| table_name | text | which table was changed |
| record_id | uuid | which row |
| old_values | jsonb | snapshot before |
| new_values | jsonb | snapshot after |
| branch_id | uuid | for filtering |
| created_at | timestamptz | |

## RLS
- v1: permissive read + write for all tables (demo mode)
- Lock-down sprint: restrict to `auth.uid() = user_id` (staff) + role checks
