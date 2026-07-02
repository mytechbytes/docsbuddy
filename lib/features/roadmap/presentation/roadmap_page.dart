import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// In-app view of the release checklist (mirrors docs/release-todo.md) so
/// progress is visible without leaving the app.
class RoadmapPage extends StatelessWidget {
  const RoadmapPage({super.key});

  static const _sections = <(String, List<(bool, String)>)>[
    ('Shipped', [
      (true, 'Onboarding walkthrough'),
      (true, 'Auth — sign in/up, OTP reset, secure session'),
      (true, 'Families & invites'),
      (true, 'Assets, locations & reminders (core)'),
      (true, 'Supabase-backed catalog (persists when configured)'),
      (true, 'Documents — attach / upload / view (Supabase Storage)'),
      (true, 'On-device reminder notifications (local scheduler)'),
      (true, 'FCM push wired (Android) — device token registration'),
      (true, 'FCM sender — notify-family Edge Function'),
      (true, 'App Links / deep-link auth redirect'),
      (true, 'App icon (flutter_launcher_icons)'),
      (true, 'Release build green on CI — signed AAB'),
      (true, 'Asset fields: model, serial no., purchase date & price, store'),
      (true, 'Real rooms/locations table backing (with data backfill)'),
      (true, 'Per-service notify offsets drive local notifications'),
      (true, 'Service fields: provider, policy no., cost, notes'),
      (true, 'Mark service done → next due date rolls forward'),
      (true, 'Documents can attach to a specific service'),
      (true, 'Dashboard stats: service counts + total appliances'),
      (true, 'WhatsApp reminder sender (Edge Function + channel)'),
      (true, 'Asset photos: upload, change, thumbnails everywhere'),
      (true, 'Appliance type catalog + picker + auto-seeded services'),
      (true, 'Add appliance: AMC date + invoice attach on create'),
      (true, 'Rooms & Room detail (photos, counts, add-here flow)'),
      (true, 'Profile (avatar, stats, family card) + edit info'),
      (true, 'Settings: account / notification prefs / family sections'),
      (true, 'Change password with strength meter'),
      (true, 'Add reminder as a full page (offsets, attach document)'),
      (true, 'Search, notification inbox, stat links, filter, avatar'),
      (true, 'Asset list: in-page search + photo thumbnails'),
    ]),
    ('Pending — your setup', [
      (false, 'Supabase: project, migrations, redirect URLs'),
      (false, 'Deploy notify-family + service account + webhook'),
      (false, 'Upload-key reset (lost key) + GitHub signing secrets'),
      (false, 'Host /.well-known/assetlinks.json + apple-app-site-association'),
      (false, 'Play Console: internal track, privacy policy, data safety'),
      (false, 'WhatsApp: deploy sender + Meta API secrets + daily cron'),
    ]),
    ('Pending — design gap (see docs/design-gap.md)', [
      (false, 'Per-service document grouping on asset detail'),
      (false, 'Camera capture for invoices/photos (image_picker)'),
      (false, 'Security: 2FA (TOTP), biometric login, app lock, sessions'),
    ]),
    ('Pending — next features', [
      (false, 'Branded splash screen'),
      (false, 'Bump KGP-legacy plugins (Built-in Kotlin)'),
      (false, 'iOS: push (APNs), signing & provisioning'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: const Text("What's pending", style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          for (final (title, items) in _sections) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
              child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 1)),
            ),
            Container(
              decoration: BoxDecoration(color: AppColors.paper, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.line)),
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
                            decoration: BoxDecoration(color: done ? AppColors.green : AppColors.bg, shape: BoxShape.circle, border: Border.all(color: done ? AppColors.green : AppColors.line, width: 1.5)),
                            child: done ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: done ? AppColors.ink : AppColors.ink2))),
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
