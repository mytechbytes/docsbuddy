import 'package:docsbuddy/features/onboarding/presentation/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../helpers/test_app.dart';

Widget _harness(InMemoryOnboardingStore store) {
  final router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingPage()),
      GoRoute(path: '/sign-in', builder: (_, _) => const Scaffold(body: Text('SIGN-IN'))),
      GoRoute(path: '/sign-up', builder: (_, _) => const Scaffold(body: Text('SIGN-UP'))),
    ],
  );
  return ProviderScope(
    overrides: testOverrides(onboarding: store),
    child: MaterialApp.router(routerConfig: router),
  );
}

Future<void> _toLastSlide(WidgetTester tester) async {
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('onboarding advances through all four slides', (tester) async {
    await tester.pumpWidget(_harness(InMemoryOnboardingStore()));
    await tester.pumpAndSettle();

    expect(find.text('Never miss a renewal again'), findsOneWidget);
    await _toLastSlide(tester);
    expect(find.text('Keep the whole family in sync'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('finishing onboarding persists the flag and routes to sign-up', (tester) async {
    final store = InMemoryOnboardingStore();
    await tester.pumpWidget(_harness(store));
    await tester.pumpAndSettle();

    await _toLastSlide(tester);
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('SIGN-UP'), findsOneWidget);
    expect(store.isComplete, isTrue);
  });
}
