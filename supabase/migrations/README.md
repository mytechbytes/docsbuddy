# Migrations — sequential, feature-based

One file per feature, ordered by dependency. Apply in filename order (or run
the generated `../all_migrations.sql` in one shot).

| # | File | Feature |
|---|------|---------|
| 0001 | `0001_extensions.sql` | pgcrypto + moddatetime |
| 0002 | `0002_users_profiles.sql` | users mirror, auto-provisioning, devices |
| 0003 | `0003_families_sharing.sql` | families, roles, invites, RLS helpers & RPCs, member profile visibility |
| 0004 | `0004_locations_rooms.sql` | rooms/places (hierarchy, photo, sort order) |
| 0005 | `0005_asset_categories.sql` | appliance-type catalog + seed |
| 0006 | `0006_assets.sql` | assets + permission-matrix RLS |
| 0007 | `0007_services_reminders.sql` | services (asset_dates), notification log, recurrence RPC |
| 0008 | `0008_documents_storage.sql` | document metadata + private bucket & storage RLS |
| 0009 | `0009_notification_prefs.sql` | channels, default offsets, quiet hours |
| 0010 | `0010_sync_support.sql` | local-first sync cursors |

## History

This layout replaces the original patch-style series (`0001_init.sql` +
seven follow-ons, see git history before 2026-07-02). The final schema is
identical except that the two data backfills (`metadata.category/location`
→ FKs) were dropped — they only migrated data created by pre-FK app builds.

These files target a **clean database** — on a project that already has any
DocsBuddy objects (old series or partial install), use `../all_migrations.sql`
instead: it runs `../reset.sql` first (⚠️ drops all DocsBuddy data) and then
re-creates everything.

## Conventions

- Each feature file owns its tables, enums, indexes, `set_updated_at`
  trigger, RLS enablement and policies.
- Cross-feature policies live with the feature that introduces the concept
  (e.g. the family-wide profile-read policy on `users` ships with families).
- `all_migrations.sql` (one directory up) is generated:
  `cat ../reset.sql` + these files in order, prepend the header.
