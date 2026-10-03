import 'package:docsbuddy/core/widgets/db_logo.dart';
import 'package:docsbuddy/features/auth/presentation/forgot_password_page.dart';
import 'package:docsbuddy/features/auth/presentation/reset_password_page.dart';
import 'package:docsbuddy/features/auth/presentation/sign_in_page.dart';
import 'package:docsbuddy/features/auth/presentation/sign_up_page.dart';
import 'package:docsbuddy/core/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../helpers/test_app.dart';

Widget _harness() {
  final router = GoRouter(
    initialLocation: '/sign-in',
    routes: [
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/sign-up', builder: (_, _) => const SignUpPage()),
      GoRoute(path: '/forgot-password', builder: (_, _) => const ForgotPasswordPage()),
      GoRoute(path: '/reset-password', builder: (_, _) => const ResetPasswordPage()),
      GoRoute(path: '/dashboard', builder: (_, _) => const Scaffold(body: Text('DASH'))),
    ],
  );
  return ProviderScope(overrides: testOverrides(), retry: noRetry, child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ));
}

void main() {
  testWidgets('sign-in renders its fields and CTA', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    // The brand lockup (icon + wordmark) heads the screen instead of a title and tagline.
    expect(find.byType(DbLogo), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);
    expect(find.text('Sign in to keep your assets and reminders in sync.'), findsNothing);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);
    expect(find.text('Continue with Microsoft'), findsOneWidget);
  });

  OutlinedButton socialButton(WidgetTester tester, String label) => tester.widget<OutlinedButton>(
        find.ancestor(of: find.text(label), matching: find.byWidgetPredicate((w) => w is OutlinedButton)),
      );

  testWidgets('Google button signs in (fake backend) and reaches the app', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Continue with Google'));
    await tester.tap(find.text('Continue with Google'));
    await settle(tester, const Duration(seconds: 1));
    expect(find.text('DASH'), findsOneWidget);
  });

  testWidgets('Apple and Microsoft buttons are disabled; Google stays enabled', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    expect(socialButton(tester, 'Continue with Google').onPressed, isNotNull);
    expect(socialButton(tester, 'Continue with Apple').onPressed, isNull);
    expect(socialButton(tester, 'Continue with Microsoft').onPressed, isNull);

    // Tapping a disabled provider does nothing (it would otherwise reach DASH).
    await tester.ensureVisible(find.text('Continue with Apple'));
    await tester.tap(find.text('Continue with Apple'), warnIfMissed: false);
    await tester.tap(find.text('Continue with Microsoft'), warnIfMissed: false);
    await settle(tester, const Duration(seconds: 1));
    expect(find.text('DASH'), findsNothing);
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('valid credentials sign in and reach the app', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'anand@kumar.dev');
    await tester.enterText(fields.at(1), 'secret123');
    await tester.tap(find.text('Sign In'));
    await settle(tester, const Duration(seconds: 1));

    expect(find.text('DASH'), findsOneWidget);
  });

  testWidgets('short password shows the backend’s message and stays put', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'anand@kumar.dev');
    await tester.enterText(fields.at(1), '123');
    await tester.tap(find.text('Sign In'));
    await settle(tester, const Duration(seconds: 1));

    expect(find.text('Incorrect email or password.'), findsOneWidget);
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('sign-in shows its loader before the request finishes, and closes it on success', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'anand@kumar.dev');
    await tester.enterText(fields.at(1), 'secret123');
    await tester.tap(find.text('Sign In'));
    await tester.pump(const Duration(milliseconds: 200)); // the fake backend takes ~700 ms

    expect(find.text('Signing you in…'), findsOneWidget, reason: 'the loader names what is happening');
    expect(find.text('DASH'), findsNothing);

    await settle(tester, const Duration(seconds: 1));
    expect(find.text('Signing you in…'), findsNothing);
    expect(find.text('DASH'), findsOneWidget);
  });

  testWidgets('a failed sign-in closes the loader and shows the reason', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'anand@kumar.dev');
    await tester.enterText(fields.at(1), '123');
    await tester.tap(find.text('Sign In'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Signing you in…'), findsOneWidget);

    await settle(tester, const Duration(seconds: 1));

    expect(find.text('Signing you in…'), findsNothing);
    expect(find.text('Incorrect email or password.'), findsOneWidget);
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('the Google button says it is opening Google while it works', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Continue with Google'));
    await tester.tap(find.text('Continue with Google'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Opening Google…'), findsOneWidget);

    await settle(tester, const Duration(seconds: 1));
    expect(find.text('Opening Google…'), findsNothing);
  });

  testWidgets('navigates from sign-in to sign-up', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Sign up'));
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // Same brand lockup as sign-in, instead of a title and tagline.
    expect(find.byType(SignUpPage), findsOneWidget);
    expect(find.byType(DbLogo), findsOneWidget);
    expect(find.text('Create your account'), findsNothing);
    expect(find.text('Create Account'), findsOneWidget);
    expect(socialButton(tester, 'Continue with Apple').onPressed, isNull);
    expect(socialButton(tester, 'Continue with Microsoft').onPressed, isNull);
  });
}
