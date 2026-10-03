import 'package:docsbuddy/core/l10n/app_language.dart';
import 'package:docsbuddy/core/theme/app_theme.dart';
import 'package:docsbuddy/features/auth/presentation/forgot_password_page.dart';
import 'package:docsbuddy/features/auth/presentation/otp_verify_page.dart';
import 'package:docsbuddy/features/auth/presentation/reset_password_page.dart';
import 'package:docsbuddy/features/auth/presentation/sign_in_page.dart';
import 'package:docsbuddy/features/auth/presentation/sign_up_page.dart';
import 'package:docsbuddy/features/catalog/presentation/add_asset_page.dart';
import 'package:docsbuddy/features/catalog/presentation/assets_page.dart';
import 'package:docsbuddy/features/catalog/presentation/rooms_page.dart';
import 'package:docsbuddy/features/dashboard/presentation/dashboard_tab.dart';
import 'package:docsbuddy/features/family/presentation/family_page.dart';
import 'package:docsbuddy/features/profile/presentation/profile_page.dart';
import 'package:docsbuddy/features/reminders/presentation/notifications_page.dart';
import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:docsbuddy/features/security/presentation/lock_screen.dart';
import 'package:docsbuddy/features/security/presentation/security_page.dart';
import 'package:docsbuddy/features/settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

/// Every language on a representative set of real screens, on a phone-sized
/// window: the screen has to build, lay out without overflowing, and run the
/// right way round (Arabic mirrors). Layout is judged with the app's real
/// font, so Latin scripts — the longest strings, Spanish and French — are
/// measured honestly; the other scripts fall back to the test font, which is
/// wider than any real one, so a clean pass there is the stricter result.
void main() {
  setUpAll(() async {
    final font = FontLoader(AppTheme.fontFamily)..addFont(rootBundle.load('assets/fonts/PlusJakartaSans-Variable.ttf'));
    await font.load();
  });

  // A phone with both Face ID and a fingerprint reader, so Settings and
  // Security show the lock at its longest ("Lock with Face ID or fingerprint").
  FakeBiometrics phone([BiometricResult result = BiometricResult.success]) => FakeBiometrics()
    ..available = true
    ..availableKinds = const [BiometricKind.face, BiometricKind.fingerprint]
    ..result = result;

  final screens = <String, Widget Function()>{
    'sign in': () => const SignInPage(),
    'sign up': () => const SignUpPage(),
    'forgot password': () => const ForgotPasswordPage(),
    'verify code': () => const OtpVerifyPage(email: 'anand@kumar.dev'),
    'reset password': () => const ResetPasswordPage(),
    'dashboard': () => const DashboardTab(),
    'assets': () => const AssetsPage(),
    'rooms': () => const RoomsPage(),
    'add asset': () => const AddAssetPage(),
    'family': () => const FamilyPage(),
    'profile': () => const ProfilePage(),
    'notifications': () => const NotificationsPage(),
    'security': () => const SecurityPage(),
    'settings': () => const SettingsPage(),
  };

  // The lock screen in the states with the most on it.
  final lockScreens = <String, BiometricResult>{
    'lock screen (not recognised)': BiometricResult.failed,
    'lock screen (no screen lock set up)': BiometricResult.unavailable,
  };

  for (final language in AppLanguage.explicit) {
    group(language.code, () {
      for (final screen in screens.entries) {
        testWidgets('${screen.key} builds and fits a phone screen', (tester) async {
          tester.view
            ..physicalSize = const Size(360, 740)
            ..devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(testApp(
            screen.value(),
            locale: language.locale,
            overrides: testOverrides(biometrics: phone()),
          ));
          await settle(tester);

          expect(tester.takeException(), isNull, reason: '${screen.key} in ${language.code}');
          final direction = Directionality.of(tester.element(find.byType(Scaffold).first));
          expect(direction, language.isRtl ? TextDirection.rtl : TextDirection.ltr);
        });
      }
      for (final lock in lockScreens.entries) {
        testWidgets('${lock.key} fits a phone screen', (tester) async {
          tester.view
            ..physicalSize = const Size(360, 740)
            ..devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(testApp(
            const LockScreen(),
            locale: language.locale,
            overrides: testOverrides(biometrics: phone(lock.value)),
          ));
          await tester.pump();
          await tester.pump();

          expect(tester.takeException(), isNull, reason: '${lock.key} in ${language.code}');
          expect(find.byType(LockScreen), findsOneWidget);
        });
      }
    });
  }
}
