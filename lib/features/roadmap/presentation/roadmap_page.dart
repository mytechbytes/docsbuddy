import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Where the app stands: the stage it is in, what is still to do, and what has
/// shipped. Hand-maintained (the detailed checklist is docs/release-todo.md);
/// update [_stages] when the release moves on, and the lists as items land.
class RoadmapPage extends StatelessWidget {
  const RoadmapPage({super.key});

  /// The release pipeline, in order. Exactly one stage is [_StageState.current].
  static const _stages = <(_StageState, String, String)>[
    (_StageState.done, 'Build and CI', 'Signed release builds from CI'),
    (_StageState.current, 'Internal testing', 'Live on Google Play for internal testers'),
    (_StageState.upcoming, 'Wider testing and review', 'Store listing reviewed by Google, more testers'),
    (_StageState.upcoming, 'Production', 'Public release'),
  ];

  static const _sections = <(String, List<(bool, String)>)>[
    ('Pending — before wider release', [
      (false, 'Delete account from inside the app (also a Google Play requirement)'),
    ]),
    ('Pending — your setup', [
      (false, 'Play Console: send the store listing for review'),
      (false, 'Deploy notify-family + service account + webhook'),
      (false, 'WhatsApp: deploy sender + Meta API secrets + daily cron'),
      (false, 'Email: deploy sender + Resend secrets + daily cron'),
      (false, 'iOS: enable Associated Domains (universal links) in Xcode'),
    ]),
    ('Pending — next features', [
      (false, 'Apple sign-in (button disabled until Services ID + Supabase setup)'),
      (false, 'Microsoft sign-in (built; button disabled until Entra app + Supabase setup)'),
      (false, 'More languages (every screen is localised; English only for now)'),
      (false, 'Bump KGP-legacy plugins (Built-in Kotlin)'),
      (false, 'iOS: push (APNs), signing & provisioning'),
    ]),
    ('Shipped — assets, rooms & reminders', [
      (true, 'Assets, locations & reminders (core)'),
      (true, 'Asset fields: model, serial no., purchase date & price, store'),
      (true, 'Real rooms/locations table backing (with data backfill)'),
      (true, 'Appliance type catalog + picker + auto-seeded services'),
      (true, 'Add appliance: AMC date + invoice attach on create'),
      (true, 'Multi-step add asset and add reminder flows'),
      (true, 'Rooms & Room detail (photos, counts, add-here flow)'),
      (true, 'Rooms: drag to reorder'),
      (true, 'Asset photos: upload, change, thumbnails everywhere'),
      (true, 'Asset list: in-page search + photo thumbnails'),
      (true, 'Edit & delete assets and services'),
      (true, 'Service fields: provider, policy no., cost, notes'),
      (true, 'Service detail: cost, record & per-service documents'),
      (true, 'Mark service done → next due date rolls forward'),
      (true, 'Add reminder as a full page (offsets, attach document)'),
      (true, 'Dashboard stats: service counts + total appliances'),
      (true, 'Dashboard: group by asset, filter by type, pull to refresh'),
      (true, 'Search, notification inbox, stat links, filter, avatar'),
    ]),
    ('Shipped — documents', [
      (true, 'Documents — attach / upload / view (Supabase Storage)'),
      (true, 'Documents can attach to a specific service'),
      (true, 'Documents: thumbnail grid, in-app image viewer, share'),
      (true, 'Camera capture and multi-select for invoices & photos'),
    ]),
    ('Shipped — family', [
      (true, 'Families & invites'),
      (true, 'Family members show photo, name & contact number'),
      (true, 'Family roles: change/remove members; call & WhatsApp'),
    ]),
    ('Shipped — account & security', [
      (true, 'Onboarding walkthrough'),
      (true, 'Auth — sign in/up, OTP reset, secure session'),
      (true, 'Google sign-in: clean return to the app (no stray page, sheet closes)'),
      (true, 'App Links / deep-link auth redirect'),
      (true, 'Host /.well-known/assetlinks.json + apple-app-site-association'),
      (true, 'Profile (avatar, stats, family card) + edit info'),
      (true, 'Phone numbers validated to E.164'),
      (true, 'Settings: account / notification prefs / family sections'),
      (true, 'Change password with strength meter'),
      (true, 'Security: 2FA (TOTP), biometric unlock, app lock, sessions'),
      (true, '2FA step-up challenge on sign-in (AAL2)'),
    ]),
    ('Shipped — notifications', [
      (true, 'On-device reminder notifications (local scheduler)'),
      (true, 'Per-service notify offsets drive local notifications'),
      (true, 'Quiet hours editor + scheduler respects them'),
      (true, 'FCM push wired (Android) — device token registration'),
      (true, 'FCM sender — notify-family Edge Function'),
      (true, 'WhatsApp reminder sender (Edge Function + channel)'),
      (true, 'Email reminder sender (Edge Function)'),
    ]),
    ('Shipped — look & feel', [
      (true, 'Dark mode with an Appearance setting (System / Light / Dark)'),
      (true, 'Every screen localised (English for now; ready for more languages)'),
      (true, 'App icon (flutter_launcher_icons)'),
      (true, 'Sign-in / sign-up headed by the app icon + name'),
      (true, 'One consistent header style on every screen'),
      (true, 'Branded splash: app icon centred on the brand colour (Android + iOS)'),
      (true, 'Startup screen: stacked logo, spinner, step-by-step progress and a retry if it fails'),
    ]),
    ('Shipped — release & engineering', [
      (true, 'Supabase backend live (project, migrations, auth redirects)'),
      (true, 'Supabase-backed catalog (persists when configured)'),
      (true, 'Release build green on CI — signed AAB'),
      (true, 'Release signing: upload key and CI secrets in place'),
      (true, 'Live on Google Play internal testing'),
      (true, 'Store listing: icon, feature graphic, phone & tablet screenshots'),
      (true, 'Crash and error reporting (Firebase Crashlytics)'),
      (true, 'Layered architecture on Riverpod 3 with a swappable backend'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    final all = [for (final (_, list) in _sections) ...list];
    final shipped = all.where((i) => i.$1).length;

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        elevation: 0,
        iconTheme: IconThemeData(color: context.palette.text),
        title: Text('Roadmap', style: TextStyle(fontWeight: FontWeight.w800, color: context.palette.text)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          _StageCard(stages: _stages, shipped: shipped, total: all.length),
          for (final (title, items) in _sections) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
              child: Text(title.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.palette.textMuted, letterSpacing: 1)),
            ),
            Container(
              decoration: BoxDecoration(color: context.palette.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.palette.border)),
              child: Column(
                children: [
                  for (final (done, label) in items)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(color: done ? context.palette.success : context.palette.background, shape: BoxShape.circle, border: Border.all(color: done ? context.palette.success : context.palette.border, width: 1.5)),
                            child: done ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: done ? context.palette.text : context.palette.textSecondary))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _StageState { done, current, upcoming }

/// The current stage up top: where the release is in its pipeline, and how much
/// of the checklist below has shipped.
class _StageCard extends StatelessWidget {
  const _StageCard({required this.stages, required this.shipped, required this.total});

  final List<(_StageState, String, String)> stages;
  final int shipped;
  final int total;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final current = stages.firstWhere((s) => s.$1 == _StageState.current);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: p.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CURRENT STAGE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.textMuted, letterSpacing: 1.2)),
          const SizedBox(height: 4),
          Text(current.$2, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: p.text)),
          const SizedBox(height: 6),
          Text(
            'The app is live with internal testers on Google Play. The store listing is staged and ready to send for review.',
            style: TextStyle(fontSize: 13.5, height: 1.45, color: p.textMuted),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : shipped / total,
              minHeight: 6,
              backgroundColor: p.border,
              color: p.success,
            ),
          ),
          const SizedBox(height: 6),
          Text('$shipped of $total checklist items shipped', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: p.textMuted)),
          const SizedBox(height: 16),
          Divider(color: p.border, height: 1),
          const SizedBox(height: 8),
          for (final (state, title, subtitle) in stages) _StageRow(state: state, title: title, subtitle: subtitle),
        ],
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  const _StageRow({required this.state, required this.title, required this.subtitle});

  final _StageState state;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final current = state == _StageState.current;
    final done = state == _StageState.done;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: done
                  ? p.success
                  : current
                      ? p.accent
                      : p.background,
              shape: BoxShape.circle,
              border: Border.all(
                color: done
                    ? p.success
                    : current
                        ? p.accent
                        : p.border,
                width: 1.5,
              ),
            ),
            child: done
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : current
                    ? const Center(child: Icon(Icons.circle, size: 8, color: Colors.white))
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(title, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: state == _StageState.upcoming ? p.textSecondary : p.text)),
                    if (current)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: p.accentSoft, borderRadius: BorderRadius.circular(999)),
                        child: Text('NOW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: p.accent)),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12.5, color: p.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
