import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/family/data/family_remote_data_source.dart';
import 'package:docsbuddy/features/family/data/remote_family_repository.dart';
import 'package:docsbuddy/features/family/domain/family_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockRemote extends Mock implements FamilyRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late RemoteFamilyRepository repo;

  setUp(() {
    remote = _MockRemote();
    repo = RemoteFamilyRepository(remote);
  });

  test('members map joined profile fields with sensible fallbacks', () async {
    when(() => remote.members('f1')).thenAnswer((_) async => [
          {'user_id': 'u1', 'role': 'owner', 'users': {'display_name': 'Anand', 'phone': '+91 1'}},
          {'user_id': 'u2', 'role': 'weird', 'users': null},
        ]);
    final members = await repo.members('f1');
    expect(members[0].displayName, 'Anand');
    expect(members[0].role, FamilyRole.owner);
    expect(members[1].displayName, 'Member');
    expect(members[1].role, FamilyRole.member);
  });

  test('no family row → null', () async {
    when(() => remote.firstFamily()).thenAnswer((_) async => null);
    expect(await repo.currentFamily(), isNull);
  });

  test('invites parse the RPC result; RPC errors become ServerFailure', () async {
    when(() => remote.createInvite('f1', 'admin'))
        .thenAnswer((_) async => {'code': 'AB12CD34', 'role': 'admin', 'expires_at': '2026-02-01T00:00:00Z'});
    final invite = await repo.createInvite(familyId: 'f1', role: FamilyRole.admin);
    expect(invite.code, 'AB12CD34');
    expect(invite.role, FamilyRole.admin);

    when(() => remote.acceptInvite('BAD')).thenThrow(const PostgrestException(message: 'Invite expired'));
    await expectLater(
        repo.acceptInvite('BAD'), throwsA(isA<ServerFailure>().having((f) => f.message, 'message', 'Invite expired')));
  });

  test('leaving requires a signed-in user', () async {
    when(() => remote.currentUserId).thenReturn(null);
    await expectLater(repo.leaveFamily('f1'), throwsA(isA<AuthFailure>()));
  });
}
