# Tasks & Sprints

## Sprint 1 — DB + Core Script Engine ✦ v1 functional milestone
**Goal:** A stranger opens the live URL, sees demo scripts, submits a lead, and gets a real AI script back.

- [ ] Apply migration SQL to Supabase (leads, scripts, audit_logs + seed rows)
- [ ] Build `/` homepage: renders seeded script cards from DB (no login)
- [ ] Build lead qualifier form component (name, company, stage toggle, pain_points, fit_notes)
- [ ] Create `/api/generate` server route: sanitise input → build prompt → call OpenAI → insert lead + script + audit row → return script
- [ ] Build script output screen: body display, copy-to-clipboard, stage badge
- [ ] Handle all UI states: loading spinner, error banner with retry, empty state for no scripts
- [ ] Deploy to Vercel; confirm live URL returns 200 for unauthenticated visitor
- [ ] Walk the full success scenario manually and confirm pass

**Definition of Done:** Recruiter visits live URL → sees demo scripts → fills form → receives generated script in <10 s → script appears in DB. No dead buttons. No login wall.

---

## Sprint 2 — History, Polish & Confidence
**Goal:** App feels complete and portfolio-ready.

- [ ] `/scripts` history page: list all scripts, MQL/SQL filter, created date
- [ ] Inline edit of script body — saves to DB on blur/submit
- [ ] Regenerate button — new AI call, version++, prior version preserved in DB
- [ ] Display confidence score and review_status badge on each script card
- [ ] Empty state on history page when no scripts exist
- [ ] Consistent Tailwind design pass across all screens

**Definition of Done:** All script cards show confidence + status. Edit and regenerate persist correctly. History filters work. Empty state renders.

---

## Sprint 3 — Lock It Down
**Goal:** Real user data is safe; auth gates the write paths.

- [ ] Add Supabase Auth (email/password)
- [ ] Replace v1 RLS policies with `auth.uid() = user_id` owner policies on all tables
- [ ] Add sign-up / sign-in pages; redirect after auth
- [ ] Bind `user_id` on all inserts
- [ ] Move seed rows to a named demo account
- [ ] Add rate-limiting middleware on `/api/generate`
- [ ] Verify zero cross-user data leakage in staging with two test accounts

**Definition of Done:** Two separate test accounts cannot see each other's data. Unauthenticated write attempts return 401.

---

## Sprint 4 — Portfolio Finish
**Goal:** Case study ready; recruiter can understand the app without guidance.

- [ ] Homepage 'How it works' banner (3-step explainer)
- [ ] README.md: problem, stack choices, AI design decisions, live URL
- [ ] `npm audit` — resolve any high/critical CVEs
- [ ] Review prompt template for injection risks; document what was not verified
- [ ] Final Vercel deploy; confirm clean URL, no console errors, 200 for logged-out visitor

**Definition of Done:** Live URL loads in <2 s for a stranger. README links to case study. npm audit shows zero high CVEs.

---

## Gantt (sprint → task group)
```
Sprint 1: DB schema · seed data · qualifier form · /api/generate · output screen · Vercel deploy
Sprint 2: History list · inline edit · regenerate · confidence badges · design polish
Sprint 3: Auth · RLS lock-down · rate-limiting · cross-user test
Sprint 4: Homepage explainer · README · security audit · final deploy
```
