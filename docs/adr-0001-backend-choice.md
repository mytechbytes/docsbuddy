# ADR-0001 — Backend platform choice

- **Status:** Accepted
- **Date:** 2026-06-21
- **Context owner:** Solo founder / lead dev

## Context

DocsBuddy is a family-shared, local-first asset & due-date tracker (Flutter +
Drift on device). The device SQLite database is the source of truth; the backend
is a sync target, backup, and silent-push fan-out — see
`docs/architecture-review.md` and `design/README.md` (§3).

The backend must provide: a relational store (the data is genuinely relational —
families → locations → assets → asset_dates → documents), authentication
(email/password + Google + Apple), per-tenant authorization, file/object storage
with tenant isolation, scheduled jobs, and ideally realtime change feeds. Push
notifications are out of scope for the backend choice — FCM is required on every
option.

The team is one developer; minimizing moving parts is the highest-leverage
constraint.

## Decision

**Use Supabase for v1.** Postgres + Auth + Storage + Edge Functions + Cron +
Realtime in one console, with Row-Level Security as the authorization layer
instead of a hand-rolled permission service. SQL keeps the data portable.

## Alternatives considered

| Option | Verdict | Why |
|---|---|---|
| **Supabase** | ✅ Chosen | Real Postgres (JSONB, enums, recursive CTE, arrays), RLS = authz boundary, integrated Auth + Storage, Realtime; portable SQL. Best fit for relational, local-first data with a solo dev. |
| **Cloudflare** (D1 + R2 + Workers + Better Auth) | Rejected for v1 | No first-party consumer auth (bolt on Better Auth/Clerk); **no RLS** — authz hand-rolled in every Worker (the exact thing Supabase removes); D1 is SQLite (~10 GB/db, no JSONB/enums); no managed realtime. Adds moving parts. Strong at edge latency, free tier, Queues, and **R2 zero-egress**. |
| **Firebase** | Rejected | Best-in-class FCM/Crashlytics, but Firestore is awkward for hierarchical/recursive data and lock-in is real. |
| **Nhost** | Viable | Postgres + Hasura + Auth + Storage — the closest "different but keeps Postgres + DB-enforced permissions." Pick if GraphQL is wanted. |
| **PocketBase** | Viable (small scale) | Single Go binary, SQLite, auth + storage + realtime + admin UI. Excellent solo-dev DX; single-node vertical scaling only. |
| **Appwrite** | Viable | Open-source all-in-one; per-document permissions rather than true RLS. |
| **AWS Amplify** | Rejected for v1 | Most powerful, most flexible, biggest ops surface — overkill until well past initial scale. |

## Consequences

- The whole architecture (RLS helper `is_family_member`, Storage-folder tenant
  isolation, `0001_init.sql`) is written against Postgres/Supabase and stays as-is.
- **Revisit trigger:** if document-download bandwidth or global latency become
  real pain, the highest-leverage change is a **hybrid — keep Supabase for
  Postgres/Auth/RLS/Realtime, move file bytes to Cloudflare R2** (zero egress).
  The §4 storage seam already does direct-to-storage + signed URLs, so swapping
  Storage → R2 presigned URLs is low-friction and does not require a migration.
- FCM remains the push transport regardless of this decision.
