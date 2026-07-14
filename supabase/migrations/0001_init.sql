create table if not exists branches (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  name text not null,
  address text,
  phone text
);

create table if not exists staff (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  branch_id uuid references branches(id),
  full_name text not null,
  role text not null,
  email text,
  is_active boolean not null default true
);

create table if not exists patients (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  full_name text not null,
  date_of_birth date,
  phone text,
  email text,
  primary_branch_id uuid references branches(id),
  notes text
);

create table if not exists appointments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  branch_id uuid references branches(id),
  patient_id uuid references patients(id),
  doctor_id uuid references staff(id),
  appointment_at timestamptz not null,
  reason text,
  status text not null default 'scheduled',
  no_show boolean not null default false,
  booked_by_id uuid references staff(id)
);

create table if not exists visit_notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  appointment_id uuid references appointments(id),
  patient_id uuid references patients(id),
  author_id uuid references staff(id),
  note_text text not null,
  ai_summary text,
  ai_summary_source text,
  ai_summary_confidence numeric,
  ai_summary_review_status text default 'unreviewed'
);

create table if not exists inventory_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  branch_id uuid references branches(id),
  item_name text not null,
  quantity numeric not null default 0,
  unit text,
  reorder_threshold numeric not null default 10,
  low_stock boolean not null default false,
  last_adjusted_by uuid references staff(id),
  last_adjusted_at timestamptz
);

create table if not exists shifts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  branch_id uuid references branches(id),
  staff_id uuid references staff(id),
  shift_date date not null,
  start_time time not null,
  end_time time not null,
  role_on_shift text,
  notes text
);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  actor_staff_id uuid,
  action text not null,
  table_name text not null,
  record_id uuid,
  old_values jsonb,
  new_values jsonb,
  branch_id uuid
);

alter table branches enable row level security;
drop policy if exists "branches_v1_read" on branches;
create policy "branches_v1_read" on branches for select using (true);
drop policy if exists "branches_v1_write" on branches;
create policy "branches_v1_write" on branches for all using (true) with check (true);

alter table staff enable row level security;
drop policy if exists "staff_v1_read" on staff;
create policy "staff_v1_read" on staff for select using (true);
drop policy if exists "staff_v1_write" on staff;
create policy "staff_v1_write" on staff for all using (true) with check (true);

alter table patients enable row level security;
drop policy if exists "patients_v1_read" on patients;
create policy "patients_v1_read" on patients for select using (true);
drop policy if exists "patients_v1_write" on patients;
create policy "patients_v1_write" on patients for all using (true) with check (true);

alter table appointments enable row level security;
drop policy if exists "appointments_v1_read" on appointments;
create policy "appointments_v1_read" on appointments for select using (true);
drop policy if exists "appointments_v1_write" on appointments;
create policy "appointments_v1_write" on appointments for all using (true) with check (true);

alter table visit_notes enable row level security;
drop policy if exists "visit_notes_v1_read" on visit_notes;
create policy "visit_notes_v1_read" on visit_notes for select using (true);
drop policy if exists "visit_notes_v1_write" on visit_notes;
create policy "visit_notes_v1_write" on visit_notes for all using (true) with check (true);

alter table inventory_items enable row level security;
drop policy if exists "inventory_items_v1_read" on inventory_items;
create policy "inventory_items_v1_read" on inventory_items for select using (true);
drop policy if exists "inventory_items_v1_write" on inventory_items;
create policy "inventory_items_v1_write" on inventory_items for all using (true) with check (true);

alter table shifts enable row level security;
drop policy if exists "shifts_v1_read" on shifts;
create policy "shifts_v1_read" on shifts for select using (true);
drop policy if exists "shifts_v1_write" on shifts;
create policy "shifts_v1_write" on shifts for all using (true) with check (true);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into branches (id, name, address, phone) values
  ('b1000000-0000-0000-0000-000000000001', 'Northside Clinic', '12 North Ave, Dublin', '01-555-0101'),
  ('b1000000-0000-0000-0000-000000000002', 'Southside Clinic', '45 South Rd, Dublin', '01-555-0202'),
  ('b1000000-0000-0000-0000-000000000003', 'Westpark Clinic', '7 West Blvd, Cork', '021-555-0303')
on conflict (id) do nothing;

insert into staff (id, branch_id, full_name, role, email) values
  ('s1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001', 'Dr. Aoife Murphy', 'doctor', 'aoife.murphy@clinic.ie'),
  ('s1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001', 'Sean Byrne', 'receptionist', 'sean.byrne@clinic.ie'),
  ('s1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002', 'Dr. Ciara Walsh', 'doctor', 'ciara.walsh@clinic.ie'),
  ('s1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002', 'Niamh Kelly', 'nurse', 'niamh.kelly@clinic.ie'),
  ('s1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003', 'Dr. Liam Doyle', 'doctor', 'liam.doyle@clinic.ie'),
  ('s1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003', 'Emma Collins', 'admin', 'emma.collins@clinic.ie')
on conflict (id) do nothing;

insert into patients (id, full_name, date_of_birth, phone, primary_branch_id) values
  ('p1000000-0000-0000-0000-000000000001', 'James O''Brien', '1985-03-14', '087-111-2001', 'b1000000-0000-0000-0000-000000000001'),
  ('p1000000-0000-0000-0000-000000000002', 'Mary Fitzgerald', '1972-07-22', '086-222-3002', 'b1000000-0000-0000-0000-000000000001'),
  ('p1000000-0000-0000-0000-000000000003', 'Tom Gallagher', '1990-11-05', '085-333-4003', 'b1000000-0000-0000-0000-000000000002'),
  ('p1000000-0000-0000-0000-000000000004', 'Sarah Quinn', '2001-02-18', '083-444-5004', 'b1000000-0000-0000-0000-000000000002'),
  ('p1000000-0000-0000-0000-000000000005', 'Patrick Nolan', '1965-09-30', '089-555-6005', 'b1000000-0000-0000-0000-000000000003'),
  ('p1000000-0000-0000-0000-000000000006', 'Sinead Brennan', '1998-06-12', '087-666-7006', 'b1000000-0000-0000-0000-000000000003')
on conflict (id) do nothing;

insert into appointments (id, branch_id, patient_id, doctor_id, appointment_at, reason, status, no_show, booked_by_id) values
  ('a1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001', 'p1000000-0000-0000-0000-000000000001', 's1000000-0000-0000-0000-000000000001', now() + interval '2 hours', 'Annual check-up', 'scheduled', false, 's1000000-0000-0000-0000-000000000002'),
  ('a1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001', 'p1000000-0000-0000-0000-000000000002', 's1000000-0000-0000-0000-000000000001', now() + interval '4 hours', 'Follow-up on blood pressure', 'scheduled', false, 's1000000-0000-0000-0000-000000000002'),
  ('a1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002', 'p1000000-0000-0000-0000-000000000003', 's1000000-0000-0000-0000-000000000003', now() - interval '1 day', 'Flu symptoms', 'completed', false, 's1000000-0000-0000-0000-000000000004'),
  ('a1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002', 'p1000000-0000-0000-0000-000000000004', 's1000000-0000-0000-0000-000000000003', now() - interval '2 hours', 'Missed appointment', 'scheduled', true, 's1000000-0000-0000-0000-000000000004'),
  ('a1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003', 'p1000000-0000-0000-0000-000000000005', 's1000000-0000-0000-0000-000000000005', now() + interval '1 day', 'Diabetes review', 'scheduled', false, 's1000000-0000-0000-0000-000000000006'),
  ('a1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003', 'p1000000-0000-0000-0000-000000000006', 's1000000-0000-0000-0000-000000000005', now() + interval '3 days', 'Skin rash consultation', 'scheduled', false, 's1000000-0000-0000-0000-000000000006')
on conflict (id) do nothing;

insert into inventory_items (id, branch_id, item_name, quantity, unit, reorder_threshold, low_stock, last_adjusted_by) values
  ('i1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001', 'Paracetamol 500mg', 200, 'tablets', 50, false, 's1000000-0000-0000-0000-000000000002'),
  ('i1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001', 'Disposable Gloves (M)', 8, 'boxes', 10, true, 's1000000-0000-0000-0000-000000000002'),
  ('i1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002', 'Blood Pressure Cuffs', 5, 'units', 3, false, 's1000000-0000-0000-0000-000000000004'),
  ('i1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002', 'Ibuprofen 200mg', 6, 'boxes', 10, true, 's1000000-0000-0000-0000-000000000004'),
  ('i1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003', 'Insulin Syringes', 150, 'units', 30, false, 's1000000-0000-0000-0000-000000000006'),
  ('i1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003', 'Sterile Wound Dressings', 9, 'packs', 15, true, 's1000000-0000-0000-0000-000000000006')
on conflict (id) do nothing;

insert into shifts (id, branch_id, staff_id, shift_date, start_time, end_time, role_on_shift) values
  ('sh100000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001', 's1000000-0000-0000-0000-000000000001', current_date, '08:00', '16:00', 'doctor'),
  ('sh100000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001', 's1000000-0000-0000-0000-000000000002', current_date, '09:00', '17:00', 'receptionist'),
  ('sh100000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002', 's1000000-0000-0000-0000-000000000003', current_date, '08:00', '14:00', 'doctor'),
  ('sh100000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002', 's1000000-0000-0000-0000-000000000004', current_date, '14:00', '22:00', 'nurse'),
  ('sh100000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003', 's1000000-0000-0000-0000-000000000005', current_date + 1, '08:00', '16:00', 'doctor'),
  ('sh100000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003', 's1000000-0000-0000-0000-000000000006', current_date + 1, '09:00', '17:00', 'admin')
on conflict (id) do nothing;