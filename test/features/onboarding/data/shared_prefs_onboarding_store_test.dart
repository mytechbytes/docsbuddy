import 'package:docsbuddy/features/onboarding/data/shared_prefs_onboarding_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('persists and clears the completion flag', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = SharedPrefsOnboardingStore(prefs);

    expect(store.isComplete, isFalse);
    await store.setComplete(true);
    expect(prefs.getBool('onboarding_complete'), isTrue);
    await store.setComplete(false);
    expect(store.isComplete, isFalse);
  });
}
