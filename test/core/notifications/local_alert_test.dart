import 'package:docsbuddy/core/notifications/local_alert.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('applyQuietHours', () {
    test('wrapping window pushes late-evening and early-morning alerts to its end', () {
      // 23:00 is inside 22:00–07:00 → next day 07:00.
      expect(applyQuietHours(DateTime(2026, 7, 1, 23), quietStart: '22:00', quietEnd: '07:00'),
          DateTime(2026, 7, 2, 7));
      // 05:30 → same day 07:00.
      expect(applyQuietHours(DateTime(2026, 7, 1, 5, 30), quietStart: '22:00', quietEnd: '07:00'),
          DateTime(2026, 7, 1, 7));
      // 09:00 is outside → unchanged.
      expect(applyQuietHours(DateTime(2026, 7, 1, 9), quietStart: '22:00', quietEnd: '07:00'), DateTime(2026, 7, 1, 9));
    });

    test('same-day window and junk input', () {
      expect(applyQuietHours(DateTime(2026, 7, 1, 13), quietStart: '12:00', quietEnd: '14:00'), DateTime(2026, 7, 1, 14));
      final t = DateTime(2026, 7, 1, 23);
      expect(applyQuietHours(t, quietStart: null, quietEnd: '07:00'), t);
      expect(applyQuietHours(t, quietStart: 'garbage', quietEnd: '07:00'), t);
    });
  });

  test('minutesOfDay parses HH:mm and HH:mm:ss, rejects junk', () {
    expect(minutesOfDay('07:30'), 450);
    expect(minutesOfDay('22:00:00'), 1320);
    expect(minutesOfDay('25:00'), isNull);
    expect(minutesOfDay('7'), isNull);
  });

  test('alert ids are stable and deterministic', () {
    expect(stableAlertId('r1', 7), stableAlertId('r1', 7));
    expect(stableAlertId('r1', 7), isNot(stableAlertId('r1', 1)));
  });
}
