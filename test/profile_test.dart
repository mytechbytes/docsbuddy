import 'dart:typed_data';

import 'package:docsbuddy/features/auth/application/password_strength.dart';
import 'package:docsbuddy/features/profile/data/profile_repository.dart';
import 'package:docsbuddy/features/settings/data/notification_prefs_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('password strength scores by length and character classes', () {
    expect(passwordStrength('').$1, 0);
    expect(passwordStrength('abc').$1, 1); // short
    expect(passwordStrength('abcdefg1').$1, 2); // 8+, two classes
    expect(passwordStrength('Abcdefg123').$1, 3); // 10+, three classes
    final (score, label) = passwordStrength('Abcdefg123!x');
    expect(score, 4); // 12+, four classes
    expect(label, 'Excellent');
  });

  test('fake profile updates name, phone and avatar', () async {
    final repo = FakeProfileRepository();
    final before = await repo.get();
    expect(before.verified, isTrue);

    final updated = await repo.update(displayName: 'Anand Kumar', phone: '+919812345678');
    expect(updated.displayName, 'Anand Kumar');
    expect(updated.phone, '+919812345678');

    final withAvatar =
        await repo.setAvatar(bytes: Uint8List.fromList([1]), fileName: 'me.jpg', mimeType: 'image/jpeg');
    expect(withAvatar.avatarUrl, isNotNull);
    expect((await repo.get()).avatarUrl, withAvatar.avatarUrl);
  });

  test('notification prefs toggle channels and offsets', () async {
    final repo = FakeNotificationPrefsRepository();
    final initial = await repo.get();
    expect(initial.hasChannel('push'), isTrue);
    expect(initial.hasChannel('whatsapp'), isFalse);

    final updated = await repo.update(initial.copyWith(
      channels: [...initial.channels, 'whatsapp'],
      defaultOffsets: [60, 14, 1],
    ));
    expect(updated.hasChannel('whatsapp'), isTrue);
    expect((await repo.get()).defaultOffsets, [60, 14, 1]);
  });
}
