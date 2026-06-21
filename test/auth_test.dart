import 'package:docsbuddy/features/auth/presentation/forgot_password_page.dart';
import 'package:docsbuddy/features/auth/presentation/reset_password_page.dart';
import 'package:docsbuddy/features/auth/presentation/sign_in_page.dart';
import 'package:docsbuddy/features/auth/presentation/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget _harness() {
  final router = GoRouter(
    initialLocation: '/sign-in',
    routes: [
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/sign-up', builder: (_, _) => const SignUpPage()),
      GoRoute(path: '/forgot-password', builder: (_, _) => const ForgotPasswordPage()),
      GoRoute(path: '/reset-password', builder: (_, _) => const ResetPasswordPage()),
      GoRoute(path: '/home', builder: (_, _) => const Scaffold(body: Text('HOME'))),
    ],
  );
  return ProviderScope(child: MaterialApp.router(routerConfig: router));
}

Future<void> _settleFakeAuth(WidgetTester tester) async {
  await tester.pump(); // start the future
  await tester.pump(const Duration(seconds: 1)); // elapse the fake 700ms delay
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sign-in renders its fields and CTA', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.widgetWithText(TextField, '').evaluate().isNotEmpty, isTrue);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);
  });

  testWidgets('valid credentials sign in and route home', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'anand@kumar.dev');
    await tester.enterText(fields.at(1), 'secret123');
    await tester.tap(find.text('Sign In'));
    await _settleFakeAuth(tester);

    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('short password shows an error and stays on sign-in', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'anand@kumar.dev');
    await tester.enterText(fields.at(1), '123');
    await tester.tap(find.text('Sign In'));
    await _settleFakeAuth(tester);

    expect(find.text('Incorrect email or password.'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget); // still here
  });

  testWidgets('navigates from sign-in to sign-up', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);
  });
}
