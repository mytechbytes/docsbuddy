import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/appearance.dart';

/// Bound at the composition root (`bootstrap/dependencies.dart`).
final appearanceStoreProvider = Provider<AppearanceStore>(
  (ref) => throw UnimplementedError('appearanceStoreProvider must be overridden'),
);

class AppearanceController extends Notifier<AppearanceMode> {
  @override
  AppearanceMode build() => ref.watch(appearanceStoreProvider).load();

  Future<void> set(AppearanceMode mode) async {
    await ref.read(appearanceStoreProvider).save(mode);
    state = mode;
  }
}

final appearanceProvider = NotifierProvider<AppearanceController, AppearanceMode>(AppearanceController.new);
