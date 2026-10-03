import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Current time, injectable so time-dependent logic is testable.
typedef Clock = DateTime Function();

final clockProvider = Provider<Clock>((ref) => DateTime.now);

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden at startup'),
);

/// Bumped when the user's family membership changes; repositories caching family-scoped state watch it and rebuild.
class FamilyScope extends Notifier<int> {
  @override
  int build() => 0;

  void changed() => state++;
}

final familyScopeProvider = NotifierProvider<FamilyScope, int>(FamilyScope.new);

/// Which backend the composition root wired up (shown in Settings).
final backendLabelProvider = Provider<String>((ref) => 'Local (fake)');
