# Intelligence Layer

## Messy Input
Free-text fields: `pain_points`, `fit_notes` — unstructured, varying length, may be vague.

## Auto-Structure Schema
Before prompting, the API route normalises input into:
```json
{
  "prospect_name": "Sarah Chen",
  "company": "Brightpath SaaS",
  "stage": "MQL",
  "pain_points": ["low trial conversion", "rep time on personalisation"],
  "fit_signals": ["uses Salesforce", "50-person team"],
  "script_tone": "consultative",
  "script_length": "short"
}
```

## Events to Track
- `lead_submitted` — form filled and sent
- `script_generated` — AI returned output
- `script_copied` — copy button clicked
- `script_edited` — inline edit saved
- `script_regenerated` — re-generation triggered

## Scoring Rules (v1 — rule-based)
- `confidence` = 0.95 if both pain_points + fit_notes filled; 0.75 if one missing; 0.5 if both blank
- `review_status` starts as `unreviewed`; user can flip to `approved` or `rejected`

## What Gets Ranked
- Scripts surface in history sorted by `created_at DESC`
- Later: rank by stage completeness and outcome signal

## v1 vs Later
**v1:** rule-based confidence, single script version per generation
**Later:** model logprob confidence, A/B script variants, outcome-linked scoring
