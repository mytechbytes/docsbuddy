import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../data/family_models.dart';
import '../data/family_repository.dart';
import '../data/fake_family_repository.dart';
import '../data/supabase_family_repository.dart';

/// Binds the active [FamilyRepository] — Supabase when configured, else fake.
final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  if (Env.hasSupabase) {
    return SupabaseFamilyRepository(Supabase.instance.client);
  }
  return FakeFamilyRepository();
});

/// Current family + its members.
typedef FamilyView = ({Family? family, List<FamilyMember> members});

/// Loads and mutates the caller's family. Display state lives in `state`;
/// action methods throw [FamilyFailure] so pages can show specific messages.
class FamilyController extends AsyncNotifier<FamilyView> {
  FamilyRepository get _repo => ref.read(familyRepositoryProvider);

  @override
  Future<FamilyView> build() => _load();

  Future<FamilyView> _load() async {
    final family = await _repo.currentFamily();
    final members = family == null ? <FamilyMember>[] : await _repo.members(family.id);
    return (family: family, members: members);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<void> createFamily(String name) async {
    await _repo.createFamily(name);
    await refresh();
  }

  Future<FamilyInvite> invite(FamilyRole role) async {
    final family = state.valueOrNull?.family;
    if (family == null) throw const FamilyFailure('No active family.');
    return _repo.createInvite(familyId: family.id, role: role);
  }

  Future<void> acceptInvite(String code) async {
    await _repo.acceptInvite(code);
    await refresh();
  }

  Future<void> leave() async {
    final family = state.valueOrNull?.family;
    if (family == null) return;
    await _repo.leaveFamily(family.id);
    await refresh();
  }

  /// The signed-in user's membership row, if loaded.
  FamilyMember? get me {
    final uid = _repo.currentUserId;
    return state.valueOrNull?.members.where((m) => m.userId == uid).firstOrNull;
  }

  Future<void> changeRole(FamilyMember member, FamilyRole role) async {
    final family = state.valueOrNull?.family;
    if (family == null) throw const FamilyFailure('No active family.');
    if (member.userId == family.ownerId) throw const FamilyFailure("The owner's role can't be changed.");
    await _repo.updateMemberRole(familyId: family.id, userId: member.userId, role: role);
    await refresh();
  }

  Future<void> removeMember(FamilyMember member) async {
    final family = state.valueOrNull?.family;
    if (family == null) throw const FamilyFailure('No active family.');
    if (member.userId == family.ownerId) throw const FamilyFailure("The owner can't be removed.");
    await _repo.removeMember(familyId: family.id, userId: member.userId);
    await refresh();
  }
}

final familyControllerProvider =
    AsyncNotifierProvider<FamilyController, FamilyView>(FamilyController.new);
