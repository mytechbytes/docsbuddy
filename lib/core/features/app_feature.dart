/// Features whose app side is built but that don't work end-to-end yet — they
/// need something outside the app first (a deployed Edge Function, a provider
/// account). Each is **off** until that exists; the UI shows it disabled,
/// "Coming soon", rather than offering a switch that does nothing.
///
/// This is the one place that says what is live. To turn one on once its
/// backend is ready, build with its flag — no code change:
///
///     flutter build appbundle --dart-define=FEATURE_EMAIL_REMINDERS=true
///
/// (CI: add it next to `SUPABASE_URL` in the build step). Or flip the default
/// here when it should ship on for everyone.
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
