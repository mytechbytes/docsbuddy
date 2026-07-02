import 'package:docsbuddy/core/notifications/reminder_schedule.dart';
import 'package:docsbuddy/features/catalog/data/catalog_models.dart';
import 'package:docsbuddy/features/catalog/data/fake_catalog_repository.dart';
import 'package:docsbuddy/features/profile/application/phone_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('quiet hours', () {
    test('wrapping window pushes late-evening and early-morning alerts to its end', () {
      // 23:00 is inside 22:00–07:00 → next day 07:00.
      expect(
        applyQuietHours(DateTime(2026, 7, 1, 23), quietStart: '22:00', quietEnd: '07:00'),
        DateTime(2026, 7, 2, 7),
      );
      // 05:30 → same day 07:00.
      expect(
        applyQuietHours(DateTime(2026, 7, 1, 5, 30), quietStart: '22:00', quietEnd: '07:00'),
        DateTime(2026, 7, 1, 7),
      );
      // 09:00 is outside → unchanged.
      expect(
        applyQuietHours(DateTime(2026, 7, 1, 9), quietStart: '22:00', quietEnd: '07:00'),
        DateTime(2026, 7, 1, 9),
      );
    });

    test('same-day window and junk input', () {
      expect(
        applyQuietHours(DateTime(2026, 7, 1, 13), quietStart: '12:00', quietEnd: '14:00'),
        DateTime(2026, 7, 1, 14),
      );
      final t = DateTime(2026, 7, 1, 23);
      expect(applyQuietHours(t, quietStart: null, quietEnd: '07:00'), t);
      expect(applyQuietHours(t, quietStart: 'garbage', quietEnd: '07:00'), t);
    });

    test('buildAlerts shifts alert times out of the quiet window', () {
      final r = Reminder(
        id: 'r1',
        assetId: 'a1',
        assetName: 'Bike',
        kind: ReminderKind.insurance,
        label: 'Insurance',
        dueDate: DateTime(2026, 1, 10),
        notifyOffsets: const [7],
      );
      // Alerts nominally at 06:00, inside 22:00–07:00 → shifted to 07:00.
      final alerts = buildAlerts([r],
          now: DateTime(2026, 1, 1), hour: 6, quietStart: '22:00', quietEnd: '07:00');
      expect(alerts.every((a) => a.when.hour == 7), isTrue);
    });
  });

  group('phone validation', () {
    test('normalizes valid E.164 and rejects junk', () {
      expect(normalizePhone('+91 98123 45678'), '+919812345678');
      expect(normalizePhone('+1 (415) 555-0100'), '+14155550100');
      expect(normalizePhone('9812345678'), isNull); // no country code
      expect(normalizePhone('+0 123'), isNull);
      expect(normalizePhone(''), isNull);
    });
  });

  group('room reordering', () {
    test('reorderLocations persists the new order', () async {
      final repo = FakeCatalogRepository();
      final before = await repo.locations();
      expect(before.length, greaterThanOrEqualTo(3));

      final reversed = before.reversed.map((l) => l.id).toList();
      await repo.reorderLocations(reversed);
      final after = await repo.locations();
      expect([for (final l in after) l.id], reversed);
    });
  });
}
