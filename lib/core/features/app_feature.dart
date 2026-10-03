/// Features that are built but not connected end-to-end yet (they need a deployed function or provider account).
/// Each is off until its flag is set, and the UI shows it disabled as "Coming soon".
///
/// Enable one per build with `--dart-define=FEATURE_EMAIL_REMINDERS=true` (CI: a repository variable of the
/// same name). See docs/feature-flags.md.
enum AppFeature {
  /// Settings → Push notifications. Nothing reads this preference: reminders
  /// are scheduled on the device whatever it says, and the push function
  /// (`notify-family`, a silent sync wake) ignores it.
  pushReminders(live: bool.fromEnvironment('FEATURE_PUSH_REMINDERS')),

  /// Settings → Email reminders. Needs `send-reminders-email` deployed with
  /// its Resend secrets and the daily cron.
  emailReminders(live: bool.fromEnvironment('FEATURE_EMAIL_REMINDERS')),

  /// Settings → WhatsApp reminders. Needs `send-reminders-whatsapp` deployed
  /// with its Meta API secrets and the daily cron.
  whatsappReminders(live: bool.fromEnvironment('FEATURE_WHATSAPP_REMINDERS')),

  /// "Continue with Apple". Needs the Apple Services ID and its Supabase setup.
  appleSignIn(live: bool.fromEnvironment('FEATURE_APPLE_SIGN_IN')),

  /// "Continue with Microsoft". Needs the Entra app and its Supabase setup.
  microsoftSignIn(live: bool.fromEnvironment('FEATURE_MICROSOFT_SIGN_IN'));

  const AppFeature({required this.live});

  /// Whether the feature works end-to-end in this build.
  final bool live;
}
