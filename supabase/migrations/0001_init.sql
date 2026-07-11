create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  prospect_name text not null,
  company text not null,
  stage text not null check (stage in ('MQL', 'SQL')),
  pain_points text,
  fit_notes text
);

alter table leads enable row level security;
drop policy if exists "leads_v1_read" on leads;
create policy "leads_v1_read" on leads for select using (true);
drop policy if exists "leads_v1_write" on leads;
create policy "leads_v1_write" on leads for all using (true) with check (true);

create table if not exists scripts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  lead_id uuid references leads(id) on delete cascade,
  stage text not null check (stage in ('MQL', 'SQL')),
  script_body text not null,
  script_body_source text not null default 'openai/gpt-4o',
  script_body_confidence numeric,
  script_body_review_status text not null default 'unreviewed',
  version integer not null default 1
);

alter table scripts enable row level security;
drop policy if exists "scripts_v1_read" on scripts;
create policy "scripts_v1_read" on scripts for select using (true);
drop policy if exists "scripts_v1_write" on scripts;
create policy "scripts_v1_write" on scripts for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  action text not null,
  object_type text not null,
  object_id uuid,
  meta jsonb
);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into leads (id, prospect_name, company, stage, pain_points, fit_notes) values
  ('a1000000-0000-0000-0000-000000000001', 'Sarah Chen', 'Brightpath SaaS', 'MQL', 'Struggling to convert trial users to paid; reps spend too long personalising outreach', 'Uses Salesforce; 50-person team; evaluating outreach tools'),
  ('a1000000-0000-0000-0000-000000000002', 'Marcus Webb', 'NovaBuild Construction', 'SQL', 'Losing deals in proposal stage; no consistent messaging from reps', 'Decision-maker confirmed; $30k budget; Q3 close target'),
  ('a1000000-0000-0000-0000-000000000003', 'Priya Nair', 'HealthSync', 'MQL', 'Cold outreach open rates below 10%; generic messaging', 'Downloaded whitepaper; 200-seat company; in healthcare compliance space'),
  ('a1000000-0000-0000-0000-000000000004', 'Derek Lau', 'FinFlow Analytics', 'SQL', 'CFO wants ROI proof before signing; deal stuck in legal', 'Pilot completed; 3 champions identified; contract review in progress');

insert into scripts (lead_id, stage, script_body, script_body_source, script_body_confidence, script_body_review_status, version) values
  ('a1000000-0000-0000-0000-000000000001', 'MQL', 'Hi Sarah — I noticed Brightpath is scaling its SaaS trial base. A lot of teams at your stage tell us their reps burn 40% of outreach time on personalisation that still feels generic. We built something that generates a tailored script from a 30-second form. Worth a 15-minute look? I can show you a live demo right now.', 'openai/gpt-4o', 0.91, 'unreviewed', 1),
  ('a1000000-0000-0000-0000-000000000002', 'SQL', 'Marcus, great news — we''re at the finish line. Your reps have already seen the platform close two proposals in the pilot. I want to make sure nothing stalls between now and your Q3 target. Can we lock in a 20-minute call this week to walk NovaBuild''s legal team through our standard DPA and security overview? I''ll have everything ready.', 'openai/gpt-4o', 0.88, 'unreviewed', 1),
  ('a1000000-0000-0000-0000-000000000003', 'MQL', 'Hey Priya — you grabbed our whitepaper on outreach benchmarks last week, so you already know a sub-10% open rate isn''t a copywriting problem — it''s a personalisation gap. We solve that for healthcare teams who need compliant, specific messaging at scale. Happy to send a 2-minute screen recording showing how it works for a team your size?', 'openai/gpt-4o', 0.85, 'unreviewed', 1),
  ('a1000000-0000-0000-0000-000000000004', 'SQL', 'Derek, I hear you — the CFO needs numbers, not slides. Here''s what I can do: I''ll pull the exact ROI calc from your pilot data and send it over as a one-pager your CFO can review independently. Meanwhile, our legal team can turn the contract redlines around in 48 hours. Who''s the best person to CC on both?', 'openai/gpt-4o', 0.93, 'approved', 1);