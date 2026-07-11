# PRD — Sales Script Generator

## Problem
Builders need a portfolio app that proves they can ship real AI. Salespeople need fast, stage-appropriate scripts without writing from scratch. This app solves both: a working AI tool a recruiter can try in 30 seconds.

## Target User
Portfolio reviewer (recruiter / hiring manager) trying the live demo; secondarily, any sales rep writing MQL or SQL outreach.

## Core Objects
- **Lead** — prospect being targeted (name, company, stage, pain points, fit notes)
- **Script** — AI-generated sales script tied to a lead (body, stage, version, confidence)
- **Audit Log** — record of every generation and edit action

## MVP Must-Haves
- [ ] Lead qualifier form: name, company, stage (MQL/SQL), pain points, fit notes
- [ ] Submit form → call AI → display generated script immediately
- [ ] Copy-to-clipboard on script output
- [ ] Homepage shows 4 seeded demo leads + scripts — no login required
- [ ] Loading, empty, error states handled on every screen
- [ ] Every button persists to the database; no dead UI
- [ ] Deployed on Vercel — live URL works for a stranger

## Non-Goals (v1)
- No CRM integration
- No user accounts or login wall
- No email sending
- No team/multi-user features
- No script performance tracking

## Success Criteria
A recruiter opens the live URL, sees the seeded demo scripts, fills in the qualifier form with a fake lead, clicks Generate, and receives a complete MQL or SQL script within 10 seconds — all without signing in. Pass = script appears and persists. Fail = any step produces a dead end or error with no recovery path.
