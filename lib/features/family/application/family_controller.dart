import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/providers/core_providers.dart';
import '../domain/family_models.dart';
import '../domain/family_repository.dart';

/// Bound at the composition root (`bootstrap/dependencies.dart`).
final familyRepositoryProvider = Provider<FamilyRepository>(
  (ref) => throw UnimplementedError('familyRepositoryProvider must be overridden'),
);

/// Loads and mutates the caller's family. Actions throw [AppFailure]s with
/// user-safe messages. Membership changes bump [familyScopeProvider] so
/// family-scoped data (rooms, assets, reminders) reloads under the new scope.
class FamilyController extends AsyncNotifier<FamilyView> {
  FamilyRepository get _repo => ref.read(familyRepositoryProvider);

  @override
  Future<FamilyView> build() => _load(ref.watch(familyRepositoryProvider));

  Future<FamilyView> _load(FamilyRepository repo) async {
    final family = await repo.currentFamily();
    final members = family == null ? const <FamilyMember>[] : await repo.members(family.id);
    return FamilyView(family: family, members: members, myUserId: repo.currentUserId);
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _load(_repo));
  }

  Family get _family =>
      state.value?.family ?? (throw const ValidationFailure('No active family.'));

  void _scopeChanged() => ref.read(familyScopeProvider.notifier).changed();

  Future<void> createFamily(String name) async {
    if (name.trim().isEmpty) throw const ValidationFailure('Please enter a family name.');
    await _repo.createFamily(name.trim());
    _scopeChanged();
    await refresh();
  }

  Future<FamilyInvite> invite([FamilyRole role = FamilyRole.member]) =>
      _repo.createInvite(familyId: _family.id, role: role);

  Future<void> acceptInvite(String code) async {
    final normalized = code.trim().toUpperCase();
    if (normalized.isEmpty) throw const ValidationFailure('Enter a valid invite code.');
    await _repo.acceptInvite(normalized);
    _scopeChanged();
    await refresh();
  }

  Future<void> leave() async {
    final family = state.value?.family;
    if (family == null) return;
    await _repo.leaveFamily(family.id);
    _scopeChanged();
    await refresh();
  }

  Future<void> changeRole(FamilyMember member, FamilyRole role) async {
    if (role == member.role) return;
    if (member.userId == _family.ownerId) throw const ValidationFailure("The owner's role can't be changed.");
    await _repo.updateMemberRole(familyId: _family.id, userId: member.userId, role: role);
    await refresh();
  }

  Future<void> removeMember(FamilyMember member) async {
    if (member.userId == _family.ownerId) throw const ValidationFailure("The owner can't be removed.");
    await _repo.removeMember(familyId: _family.id, userId: member.userId);
    await refresh();
  }
}

final familyControllerProvider = AsyncNotifierProvider<FamilyController, FamilyView>(FamilyController.new);
