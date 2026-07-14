# Intelligence Layer

## Messy Inputs
- Free-text visit notes from doctors (variable length, no structure)
- Inventory adjustments with optional comments
- Appointment reasons typed ad-hoc

## Auto-Structure (v1 — rule-based, no AI yet)

```json
{
  "no_show_flag": {
    "rule": "appointment_at < now() AND status = 'scheduled'",
    "action": "set no_show = true, write audit_log"
  },
  "low_stock_flag": {
    "rule": "quantity < reorder_threshold",
    "action": "set low_stock = true"
  },
  "dashboard_counts": {
    "today_bookings": "COUNT appointments WHERE DATE(appointment_at) = today",
    "no_shows_today": "COUNT appointments WHERE no_show = true AND DATE(appointment_at) = today",
    "low_stock_items": "COUNT inventory_items WHERE low_stock = true"
  }
}
```

## Events to Track
- Appointment created / cancelled / marked no-show
- Inventory quantity adjusted
- Visit note added
- Shift assigned

## Scoring (v1 rules, later ML)
- **No-show risk score** — count of past no_shows / total appointments for patient (0–1)
- **Stock criticality** — (reorder_threshold - quantity) / reorder_threshold; higher = more urgent

## Ranked Views
- Low-stock list sorted by stock criticality DESC
- Patient no-show rate visible on appointment booking screen

## v1 vs Later
| Feature | v1 | Later |
|---|---|---|
| Low-stock flag | Rule-based | |
| No-show flag | Manual + rule | Auto-flag via cron |
| Visit note summary | — | AI (GPT-4o), stored with source + confidence |
| Slot demand forecast | — | ML on historical bookings |
