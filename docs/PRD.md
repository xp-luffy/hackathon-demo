# PRD — Multi-Branch Clinic Operations Tool

## Problem
Clinic staff across multiple branches use disconnected spreadsheets and phone calls to manage appointments, patient records, stock, and rotas. This creates booking conflicts, lost visit history, stockouts, and no visibility into daily operations.

## Target Users
| Role | Primary need |
|---|---|
| Receptionist | Book / reschedule appointments across branches |
| Nurse | Record visit notes, check inventory |
| Doctor | View patient history, add clinical notes |
| Admin | Full ops view: dashboard, rota, all branches |

## Core Objects
- **Branch** — clinic location
- **Staff** — employee with role, linked to a branch
- **Patient** — demographics + visit history
- **Appointment** — cross-branch booking with status
- **Visit Note** — clinical note attached to an appointment
- **Inventory Item** — per-branch stock with low-stock flag
- **Shift** — staff rota entry (date + time + branch)
- **Audit Log** — every create/update/delete, who + when + what

## MVP Must-Haves (v1)
- [ ] Appointments list across all branches with create / edit / cancel
- [ ] Patient list with detail page and visit history
- [ ] Add clinical note to a visit
- [ ] Inventory list per branch with quantity adjustment
- [ ] Low-stock flag auto-set when quantity < reorder threshold
- [ ] Weekly shift rota — assign staff to shift slots
- [ ] Ops dashboard: today's bookings, no-shows, low-stock alerts
- [ ] Mark appointment as no-show
- [ ] Audit log written on every data change
- [ ] All screens handle loading / empty / error states

## Non-Goals (v1)
- SMS/email reminders
- Staff login / role-gated screens (Sprint 5)
- Billing or payments
- Supplier reorder automation
- AI features

## Definition of Done
A receptionist (demo, no login) opens the app, books a new appointment for an existing patient at a different branch, sees it appear instantly in the appointments list and on the ops dashboard, and the audit log contains one row recording the action. All five UI states are handled on every screen. No button is dead.
