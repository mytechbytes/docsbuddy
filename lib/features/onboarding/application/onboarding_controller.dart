import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/onboarding_store.dart';

/// Bound at the composition root (`bootstrap/dependencies.dart`).
final onboardingStoreProvider = Provider<OnboardingStore>(
  (ref) => throw UnimplementedError('onboardingStoreProvider must be overridden'),
);

/// Whether first-launch onboarding has been completed on this device.
class OnboardingController extends Notifier<bool> {
  @override
  bool build() => ref.watch(onboardingStoreProvider).isComplete;

  Future<void> complete() async {
    await ref.read(onboardingStoreProvider).setComplete(true);
    state = true;
  }

  /// Clears the flag so the walkthrough shows again (replay from Settings).
  Future<void> reset() async {
    await ref.read(onboardingStoreProvider).setComplete(false);
    state = false;
  }
}

final onboardingControllerProvider = NotifierProvider<OnboardingController, bool>(OnboardingController.new);
