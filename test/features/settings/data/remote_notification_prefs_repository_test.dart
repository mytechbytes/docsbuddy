import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/settings/data/notification_prefs_remote_data_source.dart';
import 'package:docsbuddy/features/settings/data/remote_notification_prefs_repository.dart';
import 'package:docsbuddy/features/settings/domain/notification_prefs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements NotificationPrefsRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late RemoteNotificationPrefsRepository repo;

  setUp(() {
    remote = _MockRemote();
    repo = RemoteNotificationPrefsRepository(remote);
  });

  test('no row yet → defaults', () async {
    when(() => remote.fetch()).thenAnswer((_) async => null);
    expect(await repo.get(), const NotificationPrefs());
  });

  test('Postgres times are trimmed to HH:mm', () async {
    when(() => remote.fetch()).thenAnswer((_) async => {
          'channels': ['push', 'whatsapp'],
          'default_offsets': [14, 1],
          'quiet_start': '23:30:00',
          'quiet_end': null,
        });
    final prefs = await repo.get();
    expect(prefs.has(NotificationChannel.whatsapp), isTrue);
    expect(prefs.quietStart, '23:30');
    expect(prefs.quietEnd, '07:00');
  });

  test('update upserts for the signed-in user', () async {
    when(() => remote.currentUserId).thenReturn('u1');
    when(() => remote.upsert(any())).thenAnswer((_) async => {'channels': ['email']});
    final saved = await repo.update(const NotificationPrefs(channels: ['email']));
    final values = verify(() => remote.upsert(captureAny())).captured.single as Map;
    expect(values['user_id'], 'u1');
    expect(saved.channels, ['email']);
  });

  test('update when signed out is an AuthFailure', () async {
    when(() => remote.currentUserId).thenReturn(null);
    await expectLater(repo.update(const NotificationPrefs()), throwsA(isA<AuthFailure>()));
  });
}
