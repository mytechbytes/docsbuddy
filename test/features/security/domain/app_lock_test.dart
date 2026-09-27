import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('locks only once the away time reaches the auto-lock window', () {
    final paused = DateTime(2026, 1, 1, 12);
    expect(shouldAutoLock(pausedAt: paused, resumedAt: paused.add(const Duration(seconds: 59)), autoLockMinutes: 1),
        isFalse);
    expect(shouldAutoLock(pausedAt: paused, resumedAt: paused.add(const Duration(minutes: 1)), autoLockMinutes: 1),
        isTrue);
    expect(shouldAutoLock(pausedAt: paused, resumedAt: paused.add(const Duration(minutes: 4)), autoLockMinutes: 5),
        isFalse);
  });

  test('status reflects an enrolled factor', () {
    expect(const SecurityStatus().totpEnabled, isFalse);
    expect(const SecurityStatus(totpFactorId: 'f').totpEnabled, isTrue);
  });
}
