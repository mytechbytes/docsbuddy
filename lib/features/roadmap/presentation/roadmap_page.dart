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
      (true, 'App Links / deep-link auth redirect'),
      (true, 'Play release setup — signed AAB, versionCode 30'),
    ]),
    ('Pending — your setup', [
      (false, 'Supabase: project, migrations, redirect URLs'),
      (false, 'Upload-key reset (lost key) + GitHub signing secrets'),
      (false, 'Host /.well-known/assetlinks.json + apple-app-site-association'),
      (false, 'Play Console: internal track, privacy policy, data safety'),
    ]),
    ('Pending — next features', [
      (false, 'Documents — pick, upload, view (Supabase Storage)'),
      (false, 'Push notifications — FCM + on-device scheduler'),
      (false, 'Supabase-backed catalog (assets/reminders sync)'),
      (false, 'App icon & splash branding'),
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
