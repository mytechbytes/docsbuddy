import 'package:docsbuddy/features/onboarding/application/onboarding_controller.dart';
import 'package:docsbuddy/features/onboarding/presentation/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _harness(SharedPreferences prefs) {
  final router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingPage()),
      GoRoute(path: '/home', builder: (_, _) => const Scaffold(body: Text('HOME'))),
      GoRoute(path: '/sign-in', builder: (_, _) => const Scaffold(body: Text('SIGN-IN'))),
    ],
  );
  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  testWidgets('onboarding shows first slide and advances through all four', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(_harness(prefs));
    await tester.pumpAndSettle();

    // First slide.
    expect(find.text('Never miss a renewal again'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Advance to slide 2 and 3.
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('All your assets in one place'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Smart reminders, weeks ahead'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Keep the whole family in sync'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('finishing onboarding persists the flag and routes home', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(_harness(prefs));
    await tester.pumpAndSettle();

    // Jump to the last slide via Skip is not on last; swipe through quickly.
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
    expect(prefs.getBool('onboarding_complete'), isTrue);
  });
}
