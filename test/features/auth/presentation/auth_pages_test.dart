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

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);
    expect(find.text('Continue with Microsoft'), findsOneWidget);
  });

  testWidgets('Microsoft button signs in (fake backend) and reaches the app', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Continue with Microsoft'));
    await tester.tap(find.text('Continue with Microsoft'));
    await settle(tester, const Duration(seconds: 1));
    expect(find.text('DASH'), findsOneWidget);
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
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('navigates from sign-in to sign-up', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Sign up'));
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);
  });
}
