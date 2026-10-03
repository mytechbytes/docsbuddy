import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/app_failure.dart';

/// Base for form controllers: `state` is the in-flight status, failures are normalised to [AppFailure],
/// stored in `state` and rethrown. Subclasses must resolve dependencies before the first `await`:
/// auto-disposed controllers may have lost `ref` by the time a save ends.
abstract class SubmitController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<T> submit<T>(Future<T> Function() action) async {
    state = const AsyncLoading();
    try {
      final result = await action();
      if (ref.mounted) state = const AsyncData(null);
      return result;
    } catch (e, st) {
      final failure = AppFailure.from(e);
      if (ref.mounted) state = AsyncError(failure, st);
      throw failure;
    }
  }
}
