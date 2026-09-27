import 'package:docsbuddy/features/catalog/domain/reminder_ordering.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/catalog_fixtures.dart';

void main() {
  test('urgency ordering, soonest and per-asset selection', () {
    final a = reminderDueIn(10, assetId: 'a');
    final b = reminderDueIn(-1, assetId: 'b');
    final c = reminderDueIn(3, assetId: 'a');
    expect(sortedByUrgency([a, b, c]).map((r) => r.id), [b.id, c.id, a.id]);
    expect(soonest([a, b, c]), b);
    expect(soonest(const []), isNull);
    expect(remindersForAsset('a', [a, b, c]), [c, a]);
  });
}
