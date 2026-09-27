import 'dart:typed_data';

import 'package:docsbuddy/core/data/file_storage.dart';
import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/profile/data/profile_remote_data_source.dart';
import 'package:docsbuddy/features/profile/data/remote_profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_app.dart';

class _MockRemote extends Mock implements ProfileRemoteDataSource {}

class _MockFiles extends Mock implements FileStorage {}

Json _row({String? name, String? avatar}) => {'id': 'u1', 'display_name': name, 'avatar_url': avatar};

void main() {
  late _MockRemote remote;
  late _MockFiles files;
  late RemoteProfileRepository repo;
  late RecordingLogger logger;
  final now = DateTime(2026, 1, 1);

  setUpAll(() => registerFallbackValue(Uint8List(0)));

  setUp(() {
    remote = _MockRemote();
    files = _MockFiles();
    logger = RecordingLogger();
    repo = RemoteProfileRepository(remote, files,
        localTimezone: () async => 'Asia/Kolkata', logger: logger, clock: () => now);
    when(() => remote.currentUserId).thenReturn('u1');
    when(() => remote.authEmail).thenReturn('anand@kumar.dev');
    when(() => remote.emailConfirmed).thenReturn(true);
  });

  test('falls back to the auth email for name and address', () async {
    when(() => remote.fetch('u1')).thenAnswer((_) async => _row());
    final p = await repo.get();
    expect(p.displayName, 'anand');
    expect(p.email, 'anand@kumar.dev');
    expect(p.verified, isTrue);
  });

  test('update sends only meaningful changes; blank phone clears it', () async {
    when(() => remote.update('u1', any())).thenAnswer((_) async => _row(name: 'Anand'));
    await repo.update(displayName: '  ', phone: '');
    verify(() => remote.update('u1', {'phone': null})).called(1);
  });

  test('avatar needs a family; old bucket photo is removed', () async {
    when(() => remote.firstFamilyId()).thenAnswer((_) async => null);
    await expectLater(
      repo.setAvatar(bytes: Uint8List(1), fileName: 'me.jpg', mimeType: 'image/jpeg'),
      throwsA(isA<ValidationFailure>()),
    );

    when(() => remote.firstFamilyId()).thenAnswer((_) async => 'fam');
    when(() => remote.fetch('u1')).thenAnswer((_) async => _row(avatar: 'fam/avatars/u1/old.jpg'));
    when(() => files.upload(any(), any(), mimeType: any(named: 'mimeType'))).thenAnswer((_) async {});
    when(() => files.remove(any())).thenAnswer((_) async {});
    when(() => remote.update('u1', any())).thenAnswer((_) async => _row(avatar: 'new'));

    await repo.setAvatar(bytes: Uint8List(1), fileName: 'me.jpg', mimeType: 'image/jpeg');
    verify(() => files.upload('fam/avatars/u1/${now.millisecondsSinceEpoch}_me.jpg', any(), mimeType: 'image/jpeg'))
        .called(1);
    verify(() => files.remove('fam/avatars/u1/old.jpg')).called(1);
  });

  test('timezone sync is best-effort', () async {
    when(() => remote.update('u1', any())).thenThrow(Exception('offline'));
    await repo.syncTimezone(); // no throw
    expect(logger.warnings, ['Timezone sync failed']);
    verify(() => remote.update('u1', {'timezone': 'Asia/Kolkata'})).called(1);
  });

  test('signed-out calls fail with AuthFailure', () async {
    when(() => remote.currentUserId).thenReturn(null);
    await expectLater(repo.get(), throwsA(isA<AuthFailure>()));
  });
}
