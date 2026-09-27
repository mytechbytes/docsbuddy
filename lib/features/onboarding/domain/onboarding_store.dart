/// Device-local "has the walkthrough been completed" flag (not synced).
abstract interface class OnboardingStore {
  bool get isComplete;
  Future<void> setComplete(bool value);
}
